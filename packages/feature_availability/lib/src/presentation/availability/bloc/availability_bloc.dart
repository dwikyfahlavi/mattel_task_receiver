import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/availability_repository.dart';

part 'availability_bloc.freezed.dart';
part 'availability_event.dart';
part 'availability_state.dart';

/// App-scoped availability (doc 4.1). Check In / Check Out use
/// `droppable()` (doc 7.4).
class AvailabilityBloc extends Bloc<AvailabilityEvent, AvailabilityState> {
  AvailabilityBloc({
    required AvailabilityRepository repository,
    required ReadinessService readiness,
    required TaskSessionBloc tasks,
    required ConnectivityService connectivity,
    required AppClock clock,
    RealtimeService? realtime,
    PushService? push,
  }) : _repo = repository,
       _readiness = readiness,
       _tasks = tasks,
       _connectivity = connectivity,
       _clock = clock,
       super(const AvailabilityState()) {
    on<AvailabilityStarted>(_onStarted, transformer: droppable());
    on<AvailabilityRefreshed>(_onRefreshed, transformer: droppable());
    on<CheckInPressed>(_onCheckIn, transformer: droppable());
    on<CheckOutPressed>(_onCheckOut, transformer: droppable());
    on<ReadinessDismissed>(
      (_, emit) =>
          emit(state.copyWith(readiness: null, readinessForCheckIn: false)),
    );
    on<ReadinessRecheckRequested>(_onRecheck, transformer: droppable());
    on<_CheckOutConflict>((_, emit) async {
      emit(
        state.copyWith(checkOutConflictCount: state.checkOutConflictCount + 1),
      );
      await _refresh(emit);
    }, transformer: sequential());
    on<ImmediateCheckOut>(_onImmediateCheckOut, transformer: droppable());
    on<AvailabilityReset>((_, emit) => emit(const AvailabilityState()));
    on<_AvailabilityLost>(
      (_, emit) => emit(state.copyWith(available: false, checkedInAt: null)),
    );
    // Reject, timeout, late delivery and offline-missed make the technician
    // Unavailable; they must check in again (doc 4.1).
    _lostSub = _tasks.availabilityLost.listen(
      (_) => add(const _AvailabilityLost()),
    );
    // The optimistic Check Out was refused (e.g. a task is in progress on the
    // server): the server state wins (doc 16).
    _conflictSub = _repo.checkOutConflicts.listen(
      (_) => add(const _CheckOutConflict()),
    );
    on<_StatusReceived>(_onStatus, transformer: sequential());
    // The server confirms every change with `status:changed` (also when the
    // other device or the system caused it) and every connect with a
    // snapshot: the UI follows them (backend guide, part 1 step 4).
    void onEvent(RealtimeEvent e) {
      final status = switch (e) {
        StatusChanged(:final status) => status,
        SnapshotReceived(:final snapshot) => snapshot.status,
        _ => null,
      };
      if (status != null) add(_StatusReceived(status));
    }

    _eventSubs = [
      if (realtime != null) realtime.events.listen(onEvent),
      if (push != null) push.messages.listen((m) => onEvent(m.event)),
    ];
  }

  late final List<StreamSubscription<Object?>> _eventSubs;

  void _onStatus(_StatusReceived e, Emitter<AvailabilityState> emit) {
    // Never overwrite the result of a request in flight.
    if (state.busy != AvailabilityBusy.none) return;
    emit(
      state.copyWith(
        available: e.status.checkedIn,
        checkedInAt: e.status.checkedIn ? e.status.checkedInAt : null,
      ),
    );
  }

  final AvailabilityRepository _repo;
  final ReadinessService _readiness;
  final TaskSessionBloc _tasks;
  final ConnectivityService _connectivity;
  final AppClock _clock;
  late final StreamSubscription<ResolutionReason> _lostSub;
  late final StreamSubscription<OutboxConflict> _conflictSub;

  /// Items a background check may raise. Network is excluded: the offline
  /// banner already shows it, and a sheet on every offline resume is noise.
  static bool _raisedInBackground(ReadinessResult r) =>
      r.blocks && r.item != ReadinessItem.network;

  Future<void> _onRecheck(
    ReadinessRecheckRequested e,
    Emitter<AvailabilityState> emit,
  ) async {
    // Never interrupt a Check In in progress or an open checklist.
    if (state.busy != AvailabilityBusy.none || state.readiness != null) return;
    final report = await _readiness.check();
    if (!report.results.any(_raisedInBackground)) return;
    if (state.busy != AvailabilityBusy.none || state.readiness != null) return;
    emit(state.copyWith(readiness: report, readinessForCheckIn: false));
  }

  Future<void> _onStarted(
    AvailabilityStarted e,
    Emitter<AvailabilityState> emit,
  ) => _refresh(emit);

  Future<void> _onRefreshed(
    AvailabilityRefreshed e,
    Emitter<AvailabilityState> emit,
  ) => _refresh(emit);

  Future<void> _refresh(Emitter<AvailabilityState> emit) async {
    if (!_connectivity.isOnline) return;
    final status = (await _repo.current()).valueOrNull;
    if (status == null || state.busy != AvailabilityBusy.none) return;
    emit(
      state.copyWith(
        available: status.checkedIn,
        checkedInAt: status.checkedIn ? status.checkedInAt : null,
      ),
    );
  }

  Future<void> _onCheckIn(
    CheckInPressed e,
    Emitter<AvailabilityState> emit,
  ) async {
    if (state.available) return;
    emit(
      state.copyWith(
        busy: AvailabilityBusy.checkingIn,
        error: null,
        readiness: null,
      ),
    );
    // Readiness check on every Check In tap (doc 12).
    final report = await _readiness.check();
    final blocked = !report.canCheckIn;
    final warned = report.failures.isNotEmpty;
    if (blocked || (warned && !e.skipWarnings)) {
      emit(
        state.copyWith(
          busy: AvailabilityBusy.none,
          readiness: report,
          readinessForCheckIn: true,
        ),
      );
      return;
    }
    final r = await _repo.checkIn();
    emit(
      r.fold(
        (s) => state.copyWith(
          busy: AvailabilityBusy.none,
          available: s.checkedIn,
          checkedInAt: s.checkedInAt ?? _clock.serverNowUtc(),
        ),
        (f) => state.copyWith(busy: AvailabilityBusy.none, error: f),
      ),
    );
  }

  Future<void> _onCheckOut(
    CheckOutPressed e,
    Emitter<AvailabilityState> emit,
  ) async {
    if (!state.available) return;
    if (_tasks.state.isInProgress) {
      emit(
        state.copyWith(checkOutBlockedCount: state.checkOutBlockedCount + 1),
      );
      return;
    }
    emit(state.copyWith(busy: AvailabilityBusy.checkingOut, error: null));
    await _repo.checkOut(sessionExpiresAt: e.sessionExpiresAt);
    emit(
      state.copyWith(
        busy: AvailabilityBusy.none,
        available: false,
        checkedInAt: null,
        checkOutQueuedCount: _connectivity.isOnline
            ? state.checkOutQueuedCount
            : state.checkOutQueuedCount + 1,
      ),
    );
  }

  Future<void> _onImmediateCheckOut(
    ImmediateCheckOut e,
    Emitter<AvailabilityState> emit,
  ) async {
    if (state.available) await _repo.checkOutNow();
    emit(state.copyWith(available: false, checkedInAt: null));
  }

  @override
  Future<void> close() async {
    await _lostSub.cancel();
    await _conflictSub.cancel();
    for (final s in _eventSubs) {
      await s.cancel();
    }
    return super.close();
  }
}
