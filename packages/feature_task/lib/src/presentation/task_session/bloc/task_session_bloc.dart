import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:flutter/widgets.dart' show AppLifecycleState, WidgetsBinding;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/task_repository.dart';

part 'task_session_bloc.freezed.dart';
part 'task_session_event.dart';
part 'task_session_state.dart';

/// The only listener of work-order events (doc 7.1), from the socket and
/// from FCM (D-21). Owns the current work order, the In Progress guard and
/// alert start/stop.
///
/// * Every (re)connect sends `state:snapshot`; the bloc redraws from it
///   (backend guide, part 4 rule 1).
/// * Accept, decline, cancel and reconcile use `droppable()`, so a double
///   tap sends one request (doc 7.4). Events are processed `sequential()`.
/// * A 409 "already answered" is normal: another device or the timer was
///   first; the prompt closes quietly.
class TaskSessionBloc extends Bloc<TaskSessionEvent, TaskSessionState> {
  TaskSessionBloc({
    required TaskRepository repository,
    required TaskEventProcessor processor,
    required RealtimeService realtime,
    required PushService push,
    required TaskNotifications notifications,
    required AlertService alerts,
    required AppClock clock,
    required ConnectivityService connectivity,
    bool Function()? isInForeground,
    this.expiryRecheck = const Duration(seconds: 3),
  }) : _repo = repository,
       _processor = processor,
       _realtime = realtime,
       _push = push,
       _notifications = notifications,
       _alerts = alerts,
       _clock = clock,
       _connectivity = connectivity,
       _isInForeground = isInForeground ?? _bindingForeground,
       super(const TaskSessionState.idle()) {
    on<TaskSessionStarted>(_onStarted, transformer: droppable());
    on<TaskSessionStopped>(_onStopped, transformer: sequential());
    on<_EventReceived>(_onEvent, transformer: sequential());
    on<TaskReconcileRequested>(_onReconcile, transformer: droppable());
    on<TaskNotificationTapped>(
      (_, emit) => _restoreFromStore(emit),
      transformer: sequential(),
    );
    on<TaskAcceptPressed>(_onAccept, transformer: droppable());
    on<TaskRejectConfirmed>(_onReject, transformer: droppable());
    on<TaskCancelConfirmed>(_onCancel, transformer: droppable());
    on<TaskCountdownExpired>(_onExpired, transformer: droppable());
    on<TaskCountdownUrgent>((_, _) => _alerts.escalate());
    on<TaskAcceptedScreenClosed>(_onAcceptedClosed);
    on<TaskResultClosed>(_onResultClosed, transformer: sequential());
  }

  final TaskRepository _repo;
  final TaskEventProcessor _processor;
  final RealtimeService _realtime;
  final PushService _push;
  final TaskNotifications _notifications;
  final AlertService _alerts;
  final AppClock _clock;
  final ConnectivityService _connectivity;
  final bool Function() _isInForeground;

  /// While the server has not auto-declined yet (it does so a few seconds
  /// after the countdown), the expiry is re-checked this often.
  final Duration expiryRecheck;

  /// The server auto-declines at about 65 s; after this much past
  /// `respond_by` the work order is treated as timed out locally.
  static const autoDeclineSlack = Duration(seconds: 12);

  StreamSubscription<RealtimeEvent>? _realtimeSub;
  StreamSubscription<IncomingPush>? _pushSub;
  Timer? _expiryTimer;
  final _notices = StreamController<TaskNotice>.broadcast();
  final _availabilityLost = StreamController<ResolutionReason>.broadcast();

  /// One-shot UI messages.
  Stream<TaskNotice> get notices => _notices.stream;

  /// Fires when a work order ended in a way that checks the technician out
  /// (decline, cancel, timeout). The server also sends `status:changed`; this
  /// is the immediate local signal (doc 4.1).
  Stream<ResolutionReason> get availabilityLost => _availabilityLost.stream;

  bool get _started => _realtimeSub != null;

  static bool _bindingForeground() {
    final s = WidgetsBinding.instance.lifecycleState;
    return s == null || s == AppLifecycleState.resumed;
  }

  // ------------------------------------------------------------- lifecycle

  Future<void> _onStarted(
    TaskSessionStarted e,
    Emitter<TaskSessionState> emit,
  ) async {
    if (_started) return;
    _realtimeSub = _realtime.events.listen((ev) => add(_EventReceived(ev)));
    _pushSub = _push.messages.listen(
      (m) => add(_EventReceived(m.event, fromPush: true)),
    );
    final initial = await _push.initialMessage();
    if (initial != null) add(_EventReceived(initial.event, fromPush: true));
    final tapped = await _notifications.launchTaskId();
    if (tapped != null) add(TaskNotificationTapped(tapped));
    await _restoreFromStore(emit);
    // With the socket the snapshot arrives on connect; without it (FCM-only
    // delivery, or not connected yet) ask over HTTP.
    if (!_realtime.isConnected) await _reconcileWithServer(emit);
  }

  Future<void> _onStopped(
    TaskSessionStopped e,
    Emitter<TaskSessionState> emit,
  ) async {
    await _realtimeSub?.cancel();
    await _pushSub?.cancel();
    _realtimeSub = null;
    _pushSub = null;
    _expiryTimer?.cancel();
    await _stopAlerts();
    emit(const TaskSessionState.idle());
  }

  @override
  void onChange(Change<TaskSessionState> change) {
    super.onChange(change);
    final was = change.currentState;
    final now = change.nextState;
    if (now is TaskAssigned && was is! TaskAssigned) {
      unawaited(_alerts.start());
    } else if (was is TaskAssigned && now is! TaskAssigned) {
      // Vibration and sound stop immediately on every exit (doc 10.1).
      unawaited(_stopAlerts());
    }
  }

  Future<void> _stopAlerts() async {
    await _alerts.stop();
    await _notifications.cancelTaskAlert();
  }

  @override
  Future<void> close() async {
    await _realtimeSub?.cancel();
    await _pushSub?.cancel();
    _expiryTimer?.cancel();
    await _stopAlerts();
    await _notices.close();
    await _availabilityLost.close();
    return super.close();
  }

  // ---------------------------------------------------------------- events

  Future<void> _onEvent(
    _EventReceived e,
    Emitter<TaskSessionState> emit,
  ) async {
    if (!_started) return;
    final now = _clock.serverNowUtc();
    switch (e.event) {
      case SnapshotReceived(:final snapshot):
        await _applySnapshot(snapshot, emit);
      case WorkOrderAssigned(:final task):
        await _presentDecision(
          await _processor.assigned(task, serverNowUtc: now),
          emit,
          fromPush: e.fromPush,
        );
      case final WorkOrderUpdated updated:
        await _applyDecision(
          await _processor.updated(updated, serverNowUtc: now),
          emit,
        );
      case _:
        break; // status, watches and session events belong to other blocs
    }
  }

  Future<void> _presentDecision(
    TaskEventDecision decision,
    Emitter<TaskSessionState> emit, {
    bool fromPush = false,
  }) async {
    switch (decision) {
      case PresentAssignment(:final task):
        unawaited(_repo.acknowledge(task.taskId));
        if (state is TaskInProgress) return;
        emit(TaskSessionState.assigned(task: task));
        // In the background the app shows the full-screen alert itself; a
        // push in the background is handled by the background isolate.
        if (!_isInForeground() && !fromPush) {
          await _notifications.showTaskAlert(
            task,
            remaining: task.expiresAt.difference(_clock.serverNowUtc()),
          );
        }
      case ShowMissed(:final outcome):
        _signalAvailability(outcome.reason);
        // Never interrupt an open popup or job; it is shown afterwards.
        if (state is TaskIdle) emit(TaskSessionState.result(outcome: outcome));
      case _:
        await _applyDecision(decision, emit);
    }
  }

  Future<void> _applyDecision(
    TaskEventDecision decision,
    Emitter<TaskSessionState> emit,
  ) async {
    switch (decision) {
      case DismissActive(:final outcome, :final silent):
        _signalAvailability(outcome.reason);
        if (silent) {
          _notify(TaskNotice.alreadyResolved);
          await _showNextOrIdle(emit, force: true);
        } else {
          emit(TaskSessionState.result(outcome: outcome));
        }
      case MoveToInProgress(:final task, :final acceptedAt):
        _notify(TaskNotice.acceptedElsewhere);
        emit(
          TaskSessionState.inProgress(
            task: task,
            acceptedAt: acceptedAt ?? _clock.serverNowUtc(),
          ),
        );
      case CompleteActive():
        _notify(TaskNotice.completed);
        await _showNextOrIdle(emit, force: true);
      case PresentAssignment() || ShowMissed():
        await _presentDecision(decision, emit);
      case IgnoreEvent():
        break;
    }
  }

  // ------------------------------------------------------------- reconcile

  Future<void> _onReconcile(
    TaskReconcileRequested e,
    Emitter<TaskSessionState> emit,
  ) async {
    if (!_started) return;
    await _restoreFromStore(emit);
    await _reconcileWithServer(emit);
  }

  /// Rebuilds state from Drift after a restart or a background delivery.
  Future<void> _restoreFromStore(Emitter<TaskSessionState> emit) async {
    final active = await _repo.store.activeTask();
    if (active != null) {
      if (active.isInProgress) {
        if (state is! TaskInProgress) {
          emit(
            TaskSessionState.inProgress(
              task: active.task,
              acceptedAt: active.acceptedAt ?? _clock.serverNowUtc(),
            ),
          );
        }
        return;
      }
      if (_clock.serverNowUtc().isBefore(active.task.expiresAt)) {
        if (state is! TaskAssigned) {
          emit(TaskSessionState.assigned(task: active.task));
        }
        return;
      }
      // Expired while we were away: the server decides; reconcile shows it.
    }
    if (state is TaskIdle) await _showNextOrIdle(emit);
  }

  Future<void> _reconcileWithServer(Emitter<TaskSessionState> emit) async {
    if (!_connectivity.isOnline) return;
    final snapshot = (await _repo.fetchState()).valueOrNull;
    if (snapshot != null) await _applySnapshot(snapshot, emit);
  }

  /// The snapshot is the truth (backend guide, part 4 rule 1).
  Future<void> _applySnapshot(
    StateSnapshot snapshot,
    Emitter<TaskSessionState> emit,
  ) async {
    final now = _clock.serverNowUtc();
    final active = snapshot.activeWorkOrder;
    final pending = snapshot.pendingWorkOrder;

    if (active != null) {
      await _repo.store.record(active.taskId, nowUtc: now, presented: true);
      final s = state;
      final acceptedAt = s is TaskInProgress && s.task.taskId == active.taskId
          ? s.acceptedAt
          : snapshot.activeSince ?? now;
      await _repo.store.saveActiveTask(
        ActiveTask(
          task: active,
          phase: ActiveTaskPhase.inProgress,
          acceptedAt: acceptedAt,
        ),
      );
      if (s is! TaskInProgress || s.task.taskId != active.taskId) {
        emit(TaskSessionState.inProgress(task: active, acceptedAt: acceptedAt));
      }
      return;
    }

    final local = await _repo.store.activeTask();
    if (pending != null) {
      if (local != null && local.task.taskId != pending.taskId) {
        await _repo.store.clearActiveTask();
      }
      final s = state;
      if (s is TaskAssigned && s.task.taskId == pending.taskId) return;
      await _presentDecision(
        await _processor.assigned(pending, serverNowUtc: now),
        emit,
      );
      return;
    }

    // The server has no open work order for us.
    if (local != null) {
      await _repo.store.clearActiveTask();
      final s = state;
      if (s is TaskAssigned && s.action == TaskAction.none) {
        // It ended while we could not see it: explain it (doc 10.3).
        final reason = now.isBefore(local.task.expiresAt)
            ? ResolutionReason.takenByOtherDevice
            : ResolutionReason.offlineMissed;
        await _repo.store.record(
          local.task.taskId,
          nowUtc: now,
          presented: true,
          resolved: true,
          reason: reason,
        );
        if (reason.isSilent) {
          await _showNextOrIdle(emit, force: true);
        } else {
          _signalAvailability(reason);
          emit(
            TaskSessionState.result(
              outcome: TaskOutcome(task: local.task, reason: reason),
            ),
          );
        }
        return;
      }
      if (s is TaskInProgress && s.action == TaskAction.none) {
        _notify(TaskNotice.completed);
        await _showNextOrIdle(emit, force: true);
        return;
      }
    }
    if (state is TaskIdle) await _showNextOrIdle(emit);
  }

  // --------------------------------------------------------------- actions

  Future<void> _onAccept(
    TaskAcceptPressed e,
    Emitter<TaskSessionState> emit,
  ) async {
    final s = state;
    if (s is! TaskAssigned || s.action != TaskAction.none) return;
    if (!_connectivity.isOnline) {
      emit(s.copyWith(error: const NoConnectionFailure()));
      return;
    }
    emit(s.copyWith(action: TaskAction.accepting, error: null));
    final result = await _repo.accept(s.task);
    if (state is! TaskAssigned) return; // resolved elsewhere meanwhile
    await result.fold(
      (ok) async => emit(
        TaskSessionState.inProgress(
          task: ok.task,
          acceptedAt: ok.acceptedAt,
          showAcceptedScreen: true,
        ),
      ),
      (failure) => _handleAnswerFailure(s.task, failure, emit),
    );
  }

  Future<void> _onReject(
    TaskRejectConfirmed e,
    Emitter<TaskSessionState> emit,
  ) async {
    final s = state;
    if (s is! TaskAssigned || s.action != TaskAction.none) return;
    if (!_connectivity.isOnline) {
      emit(s.copyWith(error: const NoConnectionFailure()));
      return;
    }
    emit(s.copyWith(action: TaskAction.rejecting, error: null));
    final result = await _repo.decline(s.task);
    if (state is! TaskAssigned) return;
    await result.fold((_) async {
      const reason = ResolutionReason.rejected;
      _signalAvailability(reason);
      emit(
        TaskSessionState.result(
          outcome: TaskOutcome(task: s.task, reason: reason),
        ),
      );
    }, (failure) => _handleAnswerFailure(s.task, failure, emit));
  }

  Future<void> _onCancel(
    TaskCancelConfirmed e,
    Emitter<TaskSessionState> emit,
  ) async {
    final s = state;
    if (s is! TaskInProgress || s.action != TaskAction.none) return;
    if (!_connectivity.isOnline) {
      emit(s.copyWith(error: const NoConnectionFailure()));
      return;
    }
    emit(s.copyWith(action: TaskAction.cancelling, error: null));
    final result = await _repo.cancel(s.task);
    final now = state;
    if (now is! TaskInProgress) return; // finished meanwhile
    await result.fold(
      (_) async {
        const reason = ResolutionReason.cancelled;
        _signalAvailability(reason);
        emit(
          TaskSessionState.result(
            outcome: TaskOutcome(task: s.task, reason: reason),
          ),
        );
      },
      (failure) async {
        if (failure is ApiFailure &&
            (failure.hasCode(ApiErrorCode.workOrderNotAccepted) ||
                failure.hasCode(ApiErrorCode.workOrderNotFound))) {
          // Already finished or never ours: the server state wins.
          emit(now.copyWith(action: TaskAction.none));
          _notify(TaskNotice.conflict);
          await _reconcileWithServer(emit);
        } else {
          emit(now.copyWith(action: TaskAction.none, error: failure));
        }
      },
    );
  }

  /// Accept / decline failed.
  Future<void> _handleAnswerFailure(
    TaskAssignment task,
    Failure failure,
    Emitter<TaskSessionState> emit,
  ) async {
    final code = failure is ApiFailure ? failure.code : null;
    switch (code) {
      case ApiErrorCode.workOrderAlreadyAnswered ||
          ApiErrorCode.workOrderNotFound:
        // Another device or the timer was first; the update event (or the
        // snapshot) tells the story.
        await _repo.store.clearActiveTask();
        _notify(TaskNotice.alreadyResolved);
        await _showNextOrIdle(emit, force: true);
        await _reconcileWithServer(emit);
      case ApiErrorCode.notCheckedIn:
        // The timer already declined it and checked the technician out.
        await _endLocally(task, ResolutionReason.timeout, emit);
      case ApiErrorCode.technicianUnavailable:
        // An accepted job exists (other device): show it.
        await _repo.store.clearActiveTask();
        await _showNextOrIdle(emit, force: true);
        await _reconcileWithServer(emit);
      case _:
        final s = state;
        if (s is TaskAssigned) {
          emit(s.copyWith(action: TaskAction.none, error: failure));
        }
    }
  }

  /// Local countdown hit zero. The server decides (it auto-declines a few
  /// seconds later), so keep the popup in "checking" until it does.
  Future<void> _onExpired(
    TaskCountdownExpired e,
    Emitter<TaskSessionState> emit,
  ) async {
    final s = state;
    if (s is! TaskAssigned ||
        (s.action != TaskAction.none &&
            s.action != TaskAction.checkingExpiry)) {
      return;
    }
    _expiryTimer?.cancel();
    emit(s.copyWith(action: TaskAction.checkingExpiry));
    final pastSlack = !_clock.serverNowUtc().isBefore(
      s.task.expiresAt.add(autoDeclineSlack),
    );
    if (_connectivity.isOnline && !pastSlack) {
      final snapshot = (await _repo.fetchState()).valueOrNull;
      if (state is! TaskAssigned) return; // an event resolved it meanwhile
      if (snapshot != null &&
          (snapshot.activeWorkOrder?.taskId == s.task.taskId ||
              snapshot.pendingWorkOrder?.taskId != s.task.taskId)) {
        await _applySnapshot(snapshot, emit);
        if (state is! TaskAssigned) return;
      }
      if (snapshot == null ||
          snapshot.pendingWorkOrder?.taskId == s.task.taskId) {
        _expiryTimer = Timer(expiryRecheck, () {
          if (!isClosed) add(const TaskCountdownExpired());
        });
        return;
      }
    }
    await _endLocally(s.task, ResolutionReason.timeout, emit);
  }

  Future<void> _endLocally(
    TaskAssignment task,
    ResolutionReason reason,
    Emitter<TaskSessionState> emit,
  ) async {
    _expiryTimer?.cancel();
    await _repo.store.clearActiveTask();
    await _repo.store.record(
      task.taskId,
      nowUtc: _clock.serverNowUtc(),
      presented: true,
      resolved: true,
      reason: reason,
    );
    _signalAvailability(reason);
    emit(
      TaskSessionState.result(
        outcome: TaskOutcome(task: task, reason: reason),
      ),
    );
  }

  void _onAcceptedClosed(
    TaskAcceptedScreenClosed e,
    Emitter<TaskSessionState> emit,
  ) {
    final s = state;
    if (s is TaskInProgress) emit(s.copyWith(showAcceptedScreen: false));
  }

  Future<void> _onResultClosed(
    TaskResultClosed e,
    Emitter<TaskSessionState> emit,
  ) async {
    final s = state;
    if (s is! TaskResult) return;
    await _repo.store.markResultSeen(s.outcome.task.taskId);
    await _showNextOrIdle(emit, force: true);
  }

  /// Shows the next unseen result (doc 10.3) or goes idle.
  Future<void> _showNextOrIdle(
    Emitter<TaskSessionState> emit, {
    bool force = false,
  }) async {
    if (!force && state is! TaskIdle && state is! TaskResult) return;
    _expiryTimer?.cancel();
    final next = await _repo.store.nextPendingResult();
    if (next != null && next.reason.isSilent) {
      await _repo.store.markResultSeen(next.task.taskId);
      return _showNextOrIdle(emit, force: true);
    }
    emit(
      next == null
          ? const TaskSessionState.idle()
          : TaskSessionState.result(outcome: next),
    );
  }

  void _signalAvailability(ResolutionReason reason) {
    if (reason.makesUnavailable && !_availabilityLost.isClosed) {
      _availabilityLost.add(reason);
    }
  }

  void _notify(TaskNotice notice) {
    if (!_notices.isClosed) _notices.add(notice);
  }
}
