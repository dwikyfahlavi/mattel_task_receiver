import 'package:core/core.dart';

import 'task_api.dart';
import 'task_dtos.dart';

/// Outcome of a successful accept.
class AcceptResult {
  const AcceptResult(this.task, this.acceptedAt);
  final TaskAssignment task;
  final DateTime acceptedAt;
}

/// Work-order data access. Remote calls are mapped to [Failure]s; local
/// state (active work order, pending results, dedupe) lives in Drift via
/// [TaskEventStore].
///
/// The backend has no idempotency keys: an answer sent twice gets 409
/// "already answered", which the session bloc treats as "someone else was
/// first" (and the double tap is blocked by `droppable()`).
class TaskRepository {
  TaskRepository({
    required TaskApi api,
    required ErrorMapper errors,
    required TaskEventStore store,
    required RealtimeService realtime,
    required AppClock clock,
  }) : _api = api,
       _errors = errors,
       _store = store,
       _realtime = realtime,
       _clock = clock;

  final TaskApi _api;
  final ErrorMapper _errors;
  final TaskEventStore _store;
  final RealtimeService _realtime;
  final AppClock _clock;

  TaskEventStore get store => _store;

  /// `GET /technicians/me/state`: the truth after any gap.
  Future<Result<StateSnapshot>> fetchState() =>
      _errors.guard(() async => StateSnapshot.parse(await _api.state()));

  Future<Result<AcceptResult>> accept(TaskAssignment task) =>
      _errors.guard(() async {
        await _api.accept(task.taskId);
        final acceptedAt = _clock.serverNowUtc();
        await _store.saveActiveTask(
          ActiveTask(
            task: task,
            phase: ActiveTaskPhase.inProgress,
            acceptedAt: acceptedAt,
          ),
        );
        return AcceptResult(task, acceptedAt);
      });

  Future<Result<void>> decline(TaskAssignment task) => _errors.guard(() async {
    await _api.decline(task.taskId);
    await _resolved(task, ResolutionReason.rejected);
  });

  Future<Result<void>> cancel(TaskAssignment task) => _errors.guard(() async {
    await _api.cancel(task.taskId);
    await _resolved(task, ResolutionReason.cancelled);
  });

  Future<void> _resolved(TaskAssignment task, ResolutionReason reason) async {
    await _store.clearActiveTask();
    await _store.record(
      task.taskId,
      nowUtc: _clock.serverNowUtc(),
      presented: true,
      resolved: true,
      reason: reason,
    );
  }

  /// `work-order:ack` over the socket (status PENDING -> READ). Best effort.
  Future<void> acknowledge(String workOrderId) async {
    final ok = await _realtime.ack(workOrderId);
    if (!ok) AppLogger.debug('Work order ack not confirmed');
  }

  static const pageSize = 20;

  Future<Result<WorkOrderPageDto>> history({
    int page = 1,
    Set<WorkOrderDisplayStatus> statuses = const {},
  }) => _errors.guard(
    () => _api.workOrders(
      status: statuses.isEmpty
          ? null
          : statuses.map((s) => s.wireName).join(','),
      page: page,
      perPage: pageSize,
    ),
  );

  Future<Result<WorkOrderDto>> detail(String workOrderId) =>
      _errors.guard(() => _api.workOrder(workOrderId));

  DateTime now() => _clock.serverNowUtc();
}
