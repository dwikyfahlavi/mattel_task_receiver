import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Work orders this device has seen, for dedupe and ordering (doc 7.2).
/// The backend sends no versions, so a work order is tracked by id and by
/// whether it was presented and resolved. Rows are purged about one hour
/// after their last update.
class WorkOrderRecords extends Table {
  TextColumn get taskId => text()();
  BoolColumn get resolved => boolean().withDefault(const Constant(false))();
  TextColumn get resolutionReason => text().nullable()();

  /// False when the work order was only seen through `work-order:updated`
  /// (out of order).
  BoolColumn get presented => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {taskId};
}

/// The single current assignment (Assigned or In Progress). Survives process
/// death so the popup and the In Progress card are rebuilt (doc 4.2 rule 6).
class ActiveTasks extends Table {
  IntColumn get slot => integer().withDefault(const Constant(0))();
  TextColumn get taskJson => text()();

  /// `assigned` or `in_progress`.
  TextColumn get phase => text()();
  DateTimeColumn get acceptedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {slot};
}

/// Results not shown yet (doc 10.3).
class PendingResults extends Table {
  TextColumn get taskId => text()();
  TextColumn get outcomeJson => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {taskId};
}

/// Offline queue (doc 16). Holds no tokens and no personal data.
class OutboxEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// `check_out`.
  TextColumn get action => text()();
  TextColumn get taskId => text().nullable()();

  /// Local row id (the backend has no idempotency keys).
  TextColumn get idempotencyKey => text()();
  DateTimeColumn get clientTimestamp => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get notBefore => dateTime().nullable()();

  /// Entries older than the shift end are dropped.
  DateTimeColumn get expiresAt => dateTime().nullable()();
}

/// Small non-secret cache (soft prompt bookkeeping, clock offset).
class KeyValues extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    WorkOrderRecords,
    ActiveTasks,
    PendingResults,
    OutboxEntries,
    KeyValues,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  /// Opens the on-device database. Safe to call from the FCM background
  /// isolate: both isolates share one instance (`shareAcrossIsolates`).
  factory AppDatabase.open() => AppDatabase(
    driftDatabase(
      name: 'mattel_tasks',
      native: const DriftNativeOptions(shareAcrossIsolates: true),
    ),
  );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        // v1 targeted the proposed FCM contract (task versions, Selesai
        // queue). Nothing in it is valid against the real backend, and it
        // only held short-lived session data, so start over.
        await customStatement('DROP TABLE IF EXISTS task_versions');
        for (final table in allTables) {
          await m.deleteTable(table.actualTableName);
        }
        await m.createAll();
      }
    },
  );

  /// Clears everything tied to the signed-in user (logout, shift end, revoke).
  Future<void> wipeSessionData() => transaction(() async {
    await delete(workOrderRecords).go();
    await delete(activeTasks).go();
    await delete(pendingResults).go();
    await delete(outboxEntries).go();
    await (delete(keyValues)..where((t) => t.key.like('session.%'))).go();
  });
}
