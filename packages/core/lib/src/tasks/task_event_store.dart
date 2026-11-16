import 'dart:convert';

import 'package:drift/drift.dart';

import '../db/app_database.dart';
import 'task_models.dart';

/// Phase of the locally persisted current task.
enum ActiveTaskPhase {
  assigned('assigned'),
  inProgress('in_progress');

  const ActiveTaskPhase(this.dbValue);
  final String dbValue;

  static ActiveTaskPhase parse(String raw) =>
      raw == inProgress.dbValue ? inProgress : assigned;
}

/// The current task as persisted in Drift.
class ActiveTask {
  const ActiveTask({required this.task, required this.phase, this.acceptedAt});

  final TaskAssignment task;
  final ActiveTaskPhase phase;
  final DateTime? acceptedAt;

  bool get isInProgress => phase == ActiveTaskPhase.inProgress;
}

/// What this device knows about a work order (dedupe record).
class WorkOrderRecord {
  const WorkOrderRecord({
    required this.resolved,
    required this.presented,
    this.reason,
  });

  final bool resolved;
  final bool presented;
  final ResolutionReason? reason;
}

/// Drift access for work-order events.
class TaskEventStore {
  TaskEventStore(this._db);

  final AppDatabase _db;

  /// Resolved and seen work order ids are kept about this long (doc 7.2).
  static const retention = Duration(hours: 1);

  Future<WorkOrderRecord?> recordOf(String taskId) async {
    final row = await (_db.select(
      _db.workOrderRecords,
    )..where((t) => t.taskId.equals(taskId))).getSingleOrNull();
    if (row == null) return null;
    return WorkOrderRecord(
      resolved: row.resolved,
      presented: row.presented,
      reason: row.resolutionReason == null
          ? null
          : ResolutionReason.parse(row.resolutionReason),
    );
  }

  Future<void> record(
    String taskId, {
    required DateTime nowUtc,
    required bool presented,
    bool resolved = false,
    ResolutionReason? reason,
  }) => _db
      .into(_db.workOrderRecords)
      .insertOnConflictUpdate(
        WorkOrderRecordsCompanion.insert(
          taskId: taskId,
          resolved: Value(resolved),
          presented: Value(presented),
          resolutionReason: Value(reason?.wireName),
          updatedAt: nowUtc,
        ),
      );

  Future<void> purgeOlderThan(DateTime cutoffUtc) => (_db.delete(
    _db.workOrderRecords,
  )..where((t) => t.updatedAt.isSmallerThanValue(cutoffUtc))).go();

  Future<ActiveTask?> activeTask() async {
    final row = await _db.select(_db.activeTasks).getSingleOrNull();
    if (row == null) return null;
    final json = jsonDecode(row.taskJson) as Map<String, dynamic>;
    return ActiveTask(
      task: TaskAssignment.fromJson(json),
      phase: ActiveTaskPhase.parse(row.phase),
      acceptedAt: row.acceptedAt,
    );
  }

  Future<void> saveActiveTask(ActiveTask active) => _db
      .into(_db.activeTasks)
      .insertOnConflictUpdate(
        ActiveTasksCompanion.insert(
          slot: const Value(0),
          taskJson: jsonEncode(active.task.toJson()),
          phase: active.phase.dbValue,
          acceptedAt: Value(active.acceptedAt),
        ),
      );

  Future<void> clearActiveTask() => _db.delete(_db.activeTasks).go();

  Future<void> addPendingResult(
    TaskOutcome outcome, {
    required DateTime nowUtc,
  }) => _db
      .into(_db.pendingResults)
      .insertOnConflictUpdate(
        PendingResultsCompanion.insert(
          taskId: outcome.task.taskId,
          outcomeJson: jsonEncode(outcome.toJson()),
          createdAt: nowUtc,
        ),
      );

  /// Oldest unseen result first.
  Future<TaskOutcome?> nextPendingResult() async {
    final row =
        await (_db.select(_db.pendingResults)
              ..orderBy([(t) => OrderingTerm.asc(t.createdAt)])
              ..limit(1))
            .getSingleOrNull();
    if (row == null) return null;
    return TaskOutcome.fromJson(
      jsonDecode(row.outcomeJson) as Map<String, dynamic>,
    );
  }

  /// Marks a result as seen by removing it (history keeps the record
  /// server-side).
  Future<void> markResultSeen(String taskId) => (_db.delete(
    _db.pendingResults,
  )..where((t) => t.taskId.equals(taskId))).go();
}
