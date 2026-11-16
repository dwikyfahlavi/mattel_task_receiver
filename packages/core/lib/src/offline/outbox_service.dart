import 'dart:async';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:meta/meta.dart';

import '../connectivity/connectivity_service.dart';
import '../db/app_database.dart';
import '../logging/app_logger.dart';
import '../time/app_clock.dart';

/// Queueable actions (doc 16). Everything else requires network.
enum OutboxAction {
  checkOut('check_out');

  const OutboxAction(this.dbValue);
  final String dbValue;

  static OutboxAction? parse(String raw) {
    for (final a in values) {
      if (a.dbValue == raw) return a;
    }
    return null;
  }
}

@immutable
class OutboxItem {
  const OutboxItem({
    required this.id,
    required this.action,
    required this.idempotencyKey,
    required this.clientTimestamp,
    required this.attempts,
    this.taskId,
  });

  final int id;
  final OutboxAction action;
  final String? taskId;
  final String idempotencyKey;
  final DateTime clientTimestamp;
  final int attempts;
}

enum OutboxOutcome {
  /// Sent and accepted.
  done,

  /// Transient failure (offline, 5xx). Retried with backoff.
  retry,

  /// The server rejected it for good (task already closed or reassigned).
  /// Dropped; the UI shows a message and reconciles from the server.
  conflict,
}

typedef OutboxHandler = Future<OutboxOutcome> Function(OutboxItem item);

@immutable
class OutboxConflict {
  const OutboxConflict(this.action, this.taskId);
  final OutboxAction action;
  final String? taskId;
}

/// Durable offline queue in Drift (doc 16). Only Check Out is queueable
/// (the technician has no Selesai action, D-22). Contains only the action,
/// task id, a local row key and the client timestamp. No tokens, no
/// personal data.
class OutboxService {
  OutboxService({
    required AppDatabase db,
    required AppClock clock,
    required ConnectivityService connectivity,
  }) : _db = db,
       _clock = clock,
       _connectivity = connectivity;

  final AppDatabase _db;
  final AppClock _clock;
  final ConnectivityService _connectivity;

  static const maxEntries = 50;
  static const maxBackoff = Duration(minutes: 5);
  static const baseBackoff = Duration(seconds: 2);

  final _handlers = <OutboxAction, OutboxHandler>{};
  final _conflicts = StreamController<OutboxConflict>.broadcast();
  StreamSubscription<bool>? _onlineSub;
  Timer? _retryTimer;
  Future<void>? _flushing;

  Stream<OutboxConflict> get conflicts => _conflicts.stream;

  void register(OutboxAction action, OutboxHandler handler) =>
      _handlers[action] = handler;

  void start() {
    _onlineSub ??= _connectivity.onlineChanges.listen((online) {
      if (online) unawaited(flush());
    });
    unawaited(flush());
  }

  Future<void> enqueue(
    OutboxAction action, {
    required String idempotencyKey,
    String? taskId,
    DateTime? expiresAt,
  }) async {
    await _db.transaction(() async {
      final existing = await _countAll();
      if (existing >= maxEntries) {
        final oldest =
            await (_db.select(_db.outboxEntries)
                  ..orderBy([(t) => OrderingTerm.asc(t.id)])
                  ..limit(existing - maxEntries + 1))
                .get();
        for (final row in oldest) {
          AppLogger.warn('Outbox full, dropping ${row.action}');
          await (_db.delete(
            _db.outboxEntries,
          )..where((t) => t.id.equals(row.id))).go();
        }
      }
      await _db
          .into(_db.outboxEntries)
          .insert(
            OutboxEntriesCompanion.insert(
              action: action.dbValue,
              taskId: Value(taskId),
              idempotencyKey: idempotencyKey,
              clientTimestamp: _clock.serverNowUtc(),
              expiresAt: Value(expiresAt),
            ),
          );
    });
    unawaited(flush());
  }

  Future<bool> hasPending(OutboxAction action, {String? taskId}) async {
    final query = _db.select(_db.outboxEntries)
      ..where((t) => t.action.equals(action.dbValue));
    if (taskId != null) query.where((t) => t.taskId.equals(taskId));
    return (await query.get()).isNotEmpty;
  }

  Future<int> pendingCount() => _countAll();

  /// Sends due entries in order. Only one run at a time; a call made while a
  /// run is in progress schedules one more run afterwards, so entries
  /// enqueued (or connectivity regained) mid-run are never missed.
  Future<void> flush() {
    final running = _flushing;
    if (running != null) {
      _rerun = true;
      return running;
    }
    return _flushing = _loop().whenComplete(() => _flushing = null);
  }

  bool _rerun = false;

  Future<void> _loop() async {
    do {
      _rerun = false;
      await _flush();
    } while (_rerun);
  }

  Future<void> _flush() async {
    // Expired entries are dropped even while offline (doc 16).
    await (_db.delete(_db.outboxEntries)
          ..where((t) => t.expiresAt.isSmallerThanValue(_clock.serverNowUtc())))
        .go();
    if (!_connectivity.isOnline) return;

    final rows = await (_db.select(
      _db.outboxEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();
    for (final row in rows) {
      // Re-read state per entry: awaits above may have taken a while.
      if (!_connectivity.isOnline) return; // resumes on the next online event
      final now = _clock.serverNowUtc();
      final expiresAt = row.expiresAt;
      if (expiresAt != null && expiresAt.isBefore(now)) {
        await _remove(row.id);
        continue;
      }
      final notBefore = row.notBefore;
      if (notBefore != null && notBefore.isAfter(now)) {
        // Strict order: later entries wait behind this one.
        _schedule(notBefore, now);
        return;
      }
      final action = OutboxAction.parse(row.action);
      final handler = action == null ? null : _handlers[action];
      if (action == null || handler == null) continue;

      final item = OutboxItem(
        id: row.id,
        action: action,
        taskId: row.taskId,
        idempotencyKey: row.idempotencyKey,
        clientTimestamp: row.clientTimestamp,
        attempts: row.attempts,
      );
      OutboxOutcome outcome;
      try {
        outcome = await handler(item);
      } on Object catch (e, s) {
        AppLogger.error('Outbox handler threw', e, s);
        outcome = OutboxOutcome.retry;
      }
      switch (outcome) {
        case OutboxOutcome.done:
          await _remove(row.id);
        case OutboxOutcome.conflict:
          await _remove(row.id);
          if (!_conflicts.isClosed) {
            _conflicts.add(OutboxConflict(action, row.taskId));
          }
        case OutboxOutcome.retry:
          final due = now.add(backoffFor(row.attempts + 1));
          await (_db.update(
            _db.outboxEntries,
          )..where((t) => t.id.equals(row.id))).write(
            OutboxEntriesCompanion(
              attempts: Value(row.attempts + 1),
              notBefore: Value(due),
            ),
          );
          // Keep order: later entries may depend on this one.
          _schedule(due, now);
          return;
      }
    }
  }

  void _schedule(DateTime due, DateTime now) {
    _retryTimer?.cancel();
    _retryTimer = Timer(due.difference(now), () => unawaited(flush()));
  }

  @visibleForTesting
  static Duration backoffFor(int attempts) {
    final ms = baseBackoff.inMilliseconds * pow(2, max(0, attempts - 1));
    return Duration(milliseconds: min(ms.toInt(), maxBackoff.inMilliseconds));
  }

  Future<void> _remove(int id) =>
      (_db.delete(_db.outboxEntries)..where((t) => t.id.equals(id))).go();

  Future<int> _countAll() async {
    final count = _db.outboxEntries.id.count();
    final row = await (_db.selectOnly(
      _db.outboxEntries,
    )..addColumns([count])).getSingle();
    return row.read(count) ?? 0;
  }

  /// Shift-end logout wipes the queue (doc 16); the server already checked out.
  Future<void> clear() async {
    _retryTimer?.cancel();
    await _db.delete(_db.outboxEntries).go();
  }

  Future<void> dispose() async {
    _retryTimer?.cancel();
    await _onlineSub?.cancel();
    await _conflicts.close();
  }
}
