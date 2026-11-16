import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

class _Connectivity implements ConnectivityService {
  final _c = StreamController<bool>.broadcast();
  bool online = true;

  void set(bool value) {
    online = value;
    _c.add(value);
  }

  @override
  bool get isOnline => online;
  @override
  Stream<bool> get onlineChanges => _c.stream;
  @override
  Future<void> start() async {}
  @override
  void reportReachable() {}
  @override
  void reportUnreachable() {}
  @override
  Future<void> dispose() => _c.close();
}

void main() {
  late AppDatabase db;
  late FakeAppClock clock;
  late _Connectivity connectivity;
  late OutboxService outbox;
  final sent = <OutboxItem>[];

  setUp(() {
    db = memoryDatabase();
    clock = FakeAppClock(serverNowUtc: DateTime.utc(2026, 10, 27, 3));
    connectivity = _Connectivity();
    outbox = OutboxService(db: db, clock: clock, connectivity: connectivity);
    sent.clear();
  });
  tearDown(() async {
    await outbox.dispose();
    await db.close();
  });

  test('offline entries are kept and sent when connectivity returns', () async {
    outbox.register(OutboxAction.checkOut, (item) async {
      sent.add(item);
      return OutboxOutcome.done;
    });
    outbox.start();
    connectivity.online = false;
    await outbox.enqueue(
      OutboxAction.checkOut,
      idempotencyKey: 'k1',
      taskId: 't-1',
    );
    await outbox.flush();
    expect(sent, isEmpty);
    expect(
      await outbox.hasPending(OutboxAction.checkOut, taskId: 't-1'),
      isTrue,
    );

    connectivity.set(true);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    await outbox.flush();
    expect(sent.single.idempotencyKey, 'k1');
    expect(await outbox.pendingCount(), 0);
  });

  test('a conflict drops the entry and is reported', () async {
    outbox.register(OutboxAction.checkOut, (_) async => OutboxOutcome.conflict);
    final conflict = outbox.conflicts.first;
    await outbox.enqueue(OutboxAction.checkOut, idempotencyKey: 'k');
    await outbox.flush();
    expect((await conflict).action, OutboxAction.checkOut);
    expect(await outbox.pendingCount(), 0);
  });

  test('retry keeps the entry with backoff and preserves order', () async {
    var calls = 0;
    outbox.register(OutboxAction.checkOut, (item) async {
      calls++;
      return OutboxOutcome.retry;
    });
    await outbox.enqueue(
      OutboxAction.checkOut,
      idempotencyKey: 'a',
      taskId: 't-1',
    );
    await outbox.enqueue(
      OutboxAction.checkOut,
      idempotencyKey: 'b',
      taskId: 't-2',
    );
    await outbox.flush();
    // Only the first entry was attempted; the second waits behind it.
    expect(calls, 1);
    expect(await outbox.pendingCount(), 2);
  });

  test('entries past the shift end are dropped', () async {
    outbox.register(OutboxAction.checkOut, (item) async {
      sent.add(item);
      return OutboxOutcome.done;
    });
    connectivity.online = false;
    await outbox.enqueue(
      OutboxAction.checkOut,
      idempotencyKey: 'old',
      expiresAt: clock.serverNowUtc().add(const Duration(minutes: 1)),
    );
    clock.advance(const Duration(minutes: 2));
    connectivity.online = true;
    await outbox.flush();
    expect(sent, isEmpty);
    expect(await outbox.pendingCount(), 0);
  });

  test('queue size is capped', () async {
    connectivity.online = false;
    for (var i = 0; i < OutboxService.maxEntries + 5; i++) {
      await outbox.enqueue(OutboxAction.checkOut, idempotencyKey: 'k$i');
    }
    expect(await outbox.pendingCount(), OutboxService.maxEntries);
  });

  test('backoff grows and is capped', () {
    expect(OutboxService.backoffFor(1), const Duration(seconds: 2));
    expect(OutboxService.backoffFor(2), const Duration(seconds: 4));
    expect(OutboxService.backoffFor(20), OutboxService.maxBackoff);
  });
}
