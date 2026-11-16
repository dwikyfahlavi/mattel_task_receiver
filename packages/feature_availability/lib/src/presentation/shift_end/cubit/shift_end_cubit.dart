import 'dart:async';

import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../availability/bloc/availability_bloc.dart';

part 'shift_end_state.dart';

/// Mirrors the server's shift-end cutoff locally (doc 4.3) so it also works
/// offline. Schedules one timer for the next boundary and re-evaluates on
/// start, resume, connectivity change and task changes.
///
/// At the cutoff: always check out; log out on the watch, and on phones and
/// tablets only with `auto_logout_mobile`. Never mid-job: an In Progress
/// task delays the logout until it is completed or the grace period ends.
/// After the logout, a downloaded Shorebird patch is applied (doc 13.2).
class ShiftEndCubit extends Cubit<ShiftBanner> {
  ShiftEndCubit({
    required SessionCubit session,
    required TaskSessionBloc tasks,
    required AvailabilityBloc availability,
    required AppClock clock,
    required PatchUpdater patches,
    required AppConfig config,
    this.onShiftEnd,
  }) : _session = session,
       _tasks = tasks,
       _availability = availability,
       _clock = clock,
       _patches = patches,
       _config = config,
       super(const NoShiftBanner()) {
    _sessionSub = _session.stream.listen((_) => evaluate());
    _taskSub = _tasks.stream.listen((_) => evaluate());
  }

  final SessionCubit _session;
  final TaskSessionBloc _tasks;
  final AvailabilityBloc _availability;
  final AppClock _clock;
  final PatchUpdater _patches;
  final AppConfig _config;

  /// Runs once per cutoff after the check-out (and logout). The shell uses
  /// it for the shift-end version check (doc 13.1).
  final void Function()? onShiftEnd;
  late final StreamSubscription<SessionState> _sessionSub;
  late final StreamSubscription<TaskSessionState> _taskSub;
  Timer? _timer;
  bool _ending = false;

  /// Cutoff for which the automatic check-out already ran (mobile without
  /// auto logout keeps its session, so it must not repeat every evaluation).
  DateTime? _checkedOutFor;

  void evaluate() {
    _timer?.cancel();
    final info = _session.state.infoOrNull;
    if (info == null || isClosed) {
      _emit(const NoShiftBanner());
      return;
    }
    final now = _clock.serverNowUtc();
    final phase = ShiftEndPolicy.evaluate(
      nowUtc: now,
      policy: info.policy,
      taskInProgress: _tasks.state.isInProgress,
    );
    switch (phase) {
      case ShiftActive():
        _emit(const NoShiftBanner());
      case ShiftEndingSoon(:final cutoff):
        _emit(ShiftEndingBanner(cutoff));
      case ShiftEndBlockedByTask(:final forceAt):
        _emit(ShiftBlockedBanner(forceAt));
      case ShiftEnded():
        unawaited(_end(info.policy.sessionExpiresAt));
        return;
    }
    final next = ShiftEndPolicy.nextTransition(phase);
    if (next != null) {
      // Re-check at the boundary; capped so a clock correction is picked up.
      final wait = next.difference(now);
      final capped = wait > const Duration(minutes: 5)
          ? const Duration(minutes: 5)
          : wait;
      _timer = Timer(capped.isNegative ? Duration.zero : capped, evaluate);
    }
  }

  Future<void> _end(DateTime cutoff) async {
    if (_ending) return;
    final logout = _session.logsOutAtShiftEnd;
    if (!logout && _checkedOutFor == cutoff) {
      _emit(const NoShiftBanner());
      return;
    }
    _ending = true;
    try {
      _availability.add(const ImmediateCheckOut());
      _checkedOutFor = cutoff;
      if (logout) await _session.end(SessionEndReason.shiftEnd);
      onShiftEnd?.call();
      // Safe point: nobody is signed in, nothing is Assigned or In Progress.
      if (logout && _config.isWatch) await _patches.restartIfReady();
      _emit(const NoShiftBanner());
    } finally {
      _ending = false;
    }
  }

  void _emit(ShiftBanner banner) {
    if (!isClosed) emit(banner); // Cubit skips equal states.
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    await _sessionSub.cancel();
    await _taskSub.cancel();
    return super.close();
  }
}
