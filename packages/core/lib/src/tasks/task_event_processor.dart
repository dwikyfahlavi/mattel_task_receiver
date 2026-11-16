import 'package:meta/meta.dart';

import '../realtime/realtime_event.dart';
import '../realtime/realtime_models.dart';
import 'task_event_store.dart';
import 'task_models.dart';

/// What the caller should do after a work-order event was processed.
@immutable
sealed class TaskEventDecision {
  const TaskEventDecision();
}

/// Duplicate, out-of-date or irrelevant event.
final class IgnoreEvent extends TaskEventDecision {
  const IgnoreEvent(this.why);
  final String why;
  @override
  String toString() => 'IgnoreEvent($why)';
}

/// A fresh assignment: show the popup (and the full-screen alert when the
/// app is in the background).
final class PresentAssignment extends TaskEventDecision {
  const PresentAssignment(this.task);
  final TaskAssignment task;
}

/// The active assignment ended (other device, timer, decline elsewhere).
/// Close the popup; show [outcome] unless [silent].
final class DismissActive extends TaskEventDecision {
  const DismissActive(this.outcome, {required this.silent});
  final TaskOutcome outcome;
  final bool silent;
}

/// Accepted on the technician's other device: show it as In Progress here.
final class MoveToInProgress extends TaskEventDecision {
  const MoveToInProgress(this.task, {this.acceptedAt});
  final TaskAssignment task;
  final DateTime? acceptedAt;
}

/// The repair of the job In Progress was finished.
final class CompleteActive extends TaskEventDecision {
  const CompleteActive(this.task);
  final TaskAssignment task;
}

/// A work order this device never presented as actionable ended. Explain it
/// (doc 10.3). The outcome is already stored as a pending result.
final class ShowMissed extends TaskEventDecision {
  const ShowMissed(this.outcome);
  final TaskOutcome outcome;
}

/// This device, to tell its own actions from those of the technician's
/// other device (`by` of `work-order:updated`).
@immutable
class ThisDevice {
  const ThisDevice({required this.kind, this.deviceId});

  /// [SessionKind.personal] (phone) or [SessionKind.shared] (watch).
  final SessionKind kind;

  /// The enrolled watch id; null on the phone.
  final String? Function()? deviceId;

  bool isActor(ActorRef? by) {
    if (by == null || by.isSystem || by.deviceKind != kind) return false;
    if (kind == SessionKind.personal) return true;
    final own = deviceId?.call();
    return own != null && by.deviceId == own;
  }
}

/// Applies the ordering and dedupe rules of doc 7.2 against Drift.
///
/// * The backend sends no versions; a work order is tracked by id.
/// * `work-order:updated` before `work-order:assigned`: the end is recorded
///   as "not presented"; the late assignment is never actionable and is
///   explained as missed (unless the reason needs no explanation).
/// * An assignment that arrives after `respond_by` becomes a late-delivery
///   result instead of an actionable popup.
/// * Only one active work order at a time (client guard, doc 4.2 rule 6).
/// * Every unseen result is stored in Drift so it survives process death.
class TaskEventProcessor {
  TaskEventProcessor(this._store, {required this.self});

  final TaskEventStore _store;
  final ThisDevice self;

  Future<TaskEventDecision> assigned(
    TaskAssignment task, {
    required DateTime serverNowUtc,
  }) async {
    final now = serverNowUtc;
    await _store.purgeOlderThan(now.subtract(TaskEventStore.retention));
    final stored = await _store.recordOf(task.taskId);

    if (stored != null && stored.resolved) {
      final reason = stored.reason ?? ResolutionReason.timeout;
      if (stored.presented || !_explainsUnseen(reason)) {
        return const IgnoreEvent('assignment for a resolved work order');
      }
      await _store.record(
        task.taskId,
        nowUtc: now,
        presented: true,
        resolved: true,
        reason: reason,
      );
      final outcome = TaskOutcome(task: task, reason: reason);
      await _store.addPendingResult(outcome, nowUtc: now);
      return ShowMissed(outcome);
    }

    final active = await _store.activeTask();
    if (active != null && active.task.taskId == task.taskId) {
      return const IgnoreEvent('duplicate assignment');
    }
    if (active != null) {
      // The backend must not assign while a job is open. If it does, its
      // timer declines it; the user is not shown a second popup.
      await _store.record(task.taskId, nowUtc: now, presented: false);
      return const IgnoreEvent('another work order is active');
    }

    if (!now.isBefore(task.expiresAt)) {
      const reason = ResolutionReason.lateDelivery;
      final outcome = TaskOutcome(task: task, reason: reason);
      await _store.record(
        task.taskId,
        nowUtc: now,
        presented: true,
        resolved: true,
        reason: reason,
      );
      await _store.addPendingResult(outcome, nowUtc: now);
      return ShowMissed(outcome);
    }

    await _store.record(task.taskId, nowUtc: now, presented: true);
    await _store.saveActiveTask(
      ActiveTask(task: task, phase: ActiveTaskPhase.assigned),
    );
    return PresentAssignment(task);
  }

  Future<TaskEventDecision> updated(
    WorkOrderUpdated event, {
    required DateTime serverNowUtc,
  }) async {
    final now = serverNowUtc;
    final id = event.workOrderId;
    final stored = await _store.recordOf(id);
    final active = await _store.activeTask();
    final isActive = active != null && active.task.taskId == id;
    final own = self.isActor(event.by);

    if (event.change == WorkOrderChange.accepted) {
      // Our own accept is completed by the HTTP answer (it also shows the
      // "Penugasan Diterima" screens).
      if (own) return const IgnoreEvent('own accept');
      final task = isActive ? active.task : event.workOrder;
      if (task == null) return const IgnoreEvent('accept without details');
      if (isActive && active.isInProgress) {
        return const IgnoreEvent('already in progress');
      }
      await _store.record(id, nowUtc: now, presented: true);
      await _store.saveActiveTask(
        ActiveTask(
          task: task,
          phase: ActiveTaskPhase.inProgress,
          acceptedAt: event.at,
        ),
      );
      return MoveToInProgress(task, acceptedAt: event.at);
    }

    final reason = switch (event.change) {
      WorkOrderChange.autoDeclined => ResolutionReason.timeout,
      WorkOrderChange.declined => ResolutionReason.rejected,
      WorkOrderChange.cancelled => ResolutionReason.cancelled,
      WorkOrderChange.completed => ResolutionReason.completed,
      _ => null,
    };
    if (reason == null) return const IgnoreEvent('unknown change');
    if (stored != null && stored.resolved) {
      return const IgnoreEvent('already resolved here');
    }
    await _store.record(
      id,
      nowUtc: now,
      presented: stored?.presented ?? false,
      resolved: true,
      reason: reason,
    );
    if (!isActive) {
      // Unseen here (no assignment yet): the late assignment, if it comes,
      // is explained as missed.
      return const IgnoreEvent('end without an active work order');
    }

    final task = active.task;
    await _store.clearActiveTask();
    if (reason == ResolutionReason.completed) return CompleteActive(task);

    // The other device declined or cancelled: close quietly here (the user
    // made the choice on the other device), still Unavailable.
    final silent = !own && reason != ResolutionReason.timeout;
    final outcome = TaskOutcome(task: task, reason: reason);
    if (!silent) await _store.addPendingResult(outcome, nowUtc: now);
    return DismissActive(outcome, silent: silent);
  }

  /// Declines and cancels made on another device of the same technician,
  /// and silent reasons, do not need an explanation on this device.
  bool _explainsUnseen(ResolutionReason reason) =>
      !reason.isSilent &&
      reason != ResolutionReason.rejected &&
      reason != ResolutionReason.cancelled;
}
