import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

WorkOrderUpdated updated(
  TaskAssignment task,
  String reason, {
  Map<String, Object?> by = systemActor,
}) => RealtimeEvent.parse('work-order:updated', {
  'work_order': workOrderJson(task),
  'reason': reason,
  'by': by,
  'at': task.assignedAt.add(const Duration(seconds: 20)).toIso8601String(),
}) as WorkOrderUpdated;

void main() {
  late AppDatabase db;
  late TaskEventStore store;
  late TaskEventProcessor phone;
  final task = sampleTask();
  final now = task.assignedAt.add(const Duration(seconds: 2));

  setUp(() {
    db = memoryDatabase();
    store = TaskEventStore(db);
    phone = TaskEventProcessor(
      store,
      self: const ThisDevice(kind: SessionKind.personal),
    );
  });
  tearDown(() => db.close());

  test('an assignment is presented once; duplicates are ignored', () async {
    expect(
      await phone.assigned(task, serverNowUtc: now),
      isA<PresentAssignment>(),
    );
    // Same work order from the socket and from push (doc 20 case 2).
    expect(await phone.assigned(task, serverNowUtc: now), isA<IgnoreEvent>());
    expect((await store.activeTask())?.task.taskId, task.taskId);
  });

  test('an assignment after respond_by is a late-delivery result', () async {
    final late = task.expiresAt.add(const Duration(seconds: 1));
    final d = await phone.assigned(task, serverNowUtc: late);
    expect((d as ShowMissed).outcome.reason, ResolutionReason.lateDelivery);
    expect(await store.activeTask(), isNull);
    expect((await store.nextPendingResult())?.task.taskId, task.taskId);
  });

  test('updated before assigned: the late assignment is explained', () async {
    expect(
      await phone.updated(updated(task, 'AUTO_DECLINED'), serverNowUtc: now),
      isA<IgnoreEvent>(),
    );
    final d = await phone.assigned(task, serverNowUtc: now);
    expect((d as ShowMissed).outcome.reason, ResolutionReason.timeout);
  });

  test('a decline on the other device needs no explanation here', () async {
    await phone.updated(
      updated(task, 'DECLINED', by: watchActor('w1')),
      serverNowUtc: now,
    );
    expect(await phone.assigned(task, serverNowUtc: now), isA<IgnoreEvent>());
  });

  test('timeout of the visible popup shows Waktu Habis', () async {
    await phone.assigned(task, serverNowUtc: now);
    final d = await phone.updated(
      updated(task, 'AUTO_DECLINED'),
      serverNowUtc: now,
    );
    expect(d, isA<DismissActive>());
    final dismiss = d as DismissActive;
    expect(dismiss.silent, isFalse);
    expect(dismiss.outcome.reason, ResolutionReason.timeout);
    expect(await store.activeTask(), isNull);
  });

  test('accepted on the watch moves the phone to In Progress', () async {
    await phone.assigned(task, serverNowUtc: now);
    final d = await phone.updated(
      updated(task, 'ACCEPTED', by: watchActor('w1')),
      serverNowUtc: now,
    );
    expect(d, isA<MoveToInProgress>());
    expect((await store.activeTask())?.isInProgress, isTrue);
  });

  test('our own accept is completed by the HTTP answer', () async {
    await phone.assigned(task, serverNowUtc: now);
    expect(
      await phone.updated(
        updated(task, 'ACCEPTED', by: phoneActor),
        serverNowUtc: now,
      ),
      isA<IgnoreEvent>(),
    );
  });

  test('the watch tells its own actions apart by device id', () {
    final watch = ThisDevice(kind: SessionKind.shared, deviceId: () => 'w1');
    expect(watch.isActor(ActorRef.parse(watchActor('w1'))), isTrue);
    expect(watch.isActor(ActorRef.parse(watchActor('w2'))), isFalse);
    expect(watch.isActor(ActorRef.parse(phoneActor)), isFalse);
    expect(watch.isActor(ActorRef.parse(systemActor)), isFalse);
  });

  test('declined on the other device closes the popup quietly', () async {
    await phone.assigned(task, serverNowUtc: now);
    final d = await phone.updated(
      updated(task, 'DECLINED', by: watchActor('w1')),
      serverNowUtc: now,
    );
    expect((d as DismissActive).silent, isTrue);
    expect(await store.nextPendingResult(), isNull);
  });

  test('COMPLETED ends the job In Progress', () async {
    await store.saveActiveTask(
      ActiveTask(task: task, phase: ActiveTaskPhase.inProgress),
    );
    final d = await phone.updated(
      updated(task, 'COMPLETED'),
      serverNowUtc: now,
    );
    expect(d, isA<CompleteActive>());
    expect(await store.activeTask(), isNull);
  });

  test('a second assignment while a job is open is not shown', () async {
    await store.saveActiveTask(
      ActiveTask(task: task, phase: ActiveTaskPhase.inProgress),
    );
    final other = sampleTask(id: 't-2');
    expect(await phone.assigned(other, serverNowUtc: now), isA<IgnoreEvent>());
  });

  test('records are purged after an hour', () async {
    await phone.updated(updated(task, 'AUTO_DECLINED'), serverNowUtc: now);
    final later = now.add(const Duration(hours: 2));
    // The resolution is forgotten: the work order would be shown again.
    expect(
      await phone.assigned(sampleTask(assignedAt: later), serverNowUtc: later),
      isA<PresentAssignment>(),
    );
  });
}
