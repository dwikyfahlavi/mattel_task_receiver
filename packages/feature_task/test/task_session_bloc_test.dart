import 'dart:async';

import 'package:core/core.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers.dart';

class _MockRepo extends Mock implements TaskRepository {}

class _MockNotifications extends Mock implements TaskNotifications {}

ApiFailure conflict(String code) => ApiFailure(statusCode: 409, code: code);

void main() {
  late AppDatabase db;
  late TaskEventStore store;
  late _MockRepo repo;
  late _MockNotifications notifications;
  late FakePush push;
  late FakeRealtime realtime;
  late FakeAppClock clock;
  late FakeConnectivity connectivity;
  late SilentAlertService alerts;
  late TaskSessionBloc bloc;
  late bool foreground;
  final now = DateTime.utc(2026, 10, 27, 2, 38);
  final task = sampleTask(now);

  setUpAll(() {
    registerFallbackValue(task);
    registerFallbackValue(Duration.zero);
  });

  setUp(() {
    db = memoryDatabase();
    store = TaskEventStore(db);
    repo = _MockRepo();
    push = FakePush();
    realtime = FakeRealtime();
    clock = FakeAppClock(now.add(const Duration(seconds: 1)));
    connectivity = FakeConnectivity();
    alerts = SilentAlertService();
    foreground = true;
    notifications = _MockNotifications();
    when(notifications.cancelTaskAlert).thenAnswer((_) async {});
    when(notifications.launchTaskId).thenAnswer((_) async => null);
    when(
      () => notifications.showTaskAlert(
        any(),
        remaining: any(named: 'remaining'),
      ),
    ).thenAnswer((_) async {});
    when(() => repo.store).thenReturn(store);
    when(() => repo.acknowledge(any())).thenAnswer((_) async {});
    when(repo.fetchState).thenAnswer(
      (_) async => Result.ok(StateSnapshot.parse(snapshotPayload())),
    );
    bloc = TaskSessionBloc(
      repository: repo,
      processor: TaskEventProcessor(
        store,
        self: const ThisDevice(kind: SessionKind.personal),
      ),
      realtime: realtime,
      push: push,
      notifications: notifications,
      alerts: alerts,
      clock: clock,
      connectivity: connectivity,
      isInForeground: () => foreground,
      expiryRecheck: const Duration(milliseconds: 20),
    );
  });

  tearDown(() async {
    await bloc.close();
    await realtime.close();
    await db.close();
  });

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 30));

  Future<void> start() async {
    bloc.add(const TaskSessionStarted());
    await settle();
  }

  Future<void> startWithAssignment() async {
    await start();
    realtime.send('work-order:assigned', {'work_order': workOrderJson(task)});
    await settle();
  }

  test(
    'an assignment presents the popup, starts the alert and acks it',
    () async {
      await startWithAssignment();
      expect(bloc.state, isA<TaskAssigned>());
      expect(alerts.starts, 1);
      verify(() => repo.acknowledge(task.taskId)).called(1);
    },
  );

  test('the same work order from socket and push is shown once', () async {
    await startWithAssignment();
    push.send('work-order:assigned', {'work_order': workOrderJson(task)});
    await settle();
    expect(alerts.starts, 1);
    verify(() => repo.acknowledge(task.taskId)).called(1);
  });

  test('in the background the full-screen alert is shown', () async {
    foreground = false;
    await startWithAssignment();
    verify(
      () => notifications.showTaskAlert(
        any(),
        remaining: any(named: 'remaining'),
      ),
    ).called(1);
  });

  test('a double tap on Terima sends one request (doc 20 case 4)', () async {
    final gate = Completer<Result<AcceptResult>>();
    when(() => repo.accept(any())).thenAnswer((_) => gate.future);
    await startWithAssignment();

    bloc
      ..add(const TaskAcceptPressed())
      ..add(const TaskAcceptPressed());
    await settle();
    gate.complete(Result.ok(AcceptResult(task, now)));
    await settle();

    verify(() => repo.accept(any())).called(1);
    final s = bloc.state;
    expect(s, isA<TaskInProgress>());
    expect((s as TaskInProgress).showAcceptedScreen, isTrue);
    expect(alerts.stops, greaterThanOrEqualTo(1));
  });

  test('409 already answered closes the popup quietly', () async {
    when(() => repo.accept(any())).thenAnswer(
      (_) async => Result.err(conflict(ApiErrorCode.workOrderAlreadyAnswered)),
    );
    await startWithAssignment();
    final notice = bloc.notices.first;
    bloc.add(const TaskAcceptPressed());
    await settle();
    expect(bloc.state, isA<TaskIdle>());
    expect(await notice, TaskNotice.alreadyResolved);
  });

  test('409 not checked in means the timer already declined it', () async {
    when(
      () => repo.accept(any()),
    ).thenAnswer((_) async => Result.err(conflict(ApiErrorCode.notCheckedIn)));
    await startWithAssignment();
    final lost = bloc.availabilityLost.first;
    bloc.add(const TaskAcceptPressed());
    await settle();
    expect((bloc.state as TaskResult).outcome.reason, ResolutionReason.timeout);
    expect(await lost, ResolutionReason.timeout);
  });

  test('Terima offline is refused without a request (doc 16)', () async {
    await startWithAssignment();
    connectivity.online = false;
    bloc.add(const TaskAcceptPressed());
    await settle();
    verifyNever(() => repo.accept(any()));
    expect((bloc.state as TaskAssigned).error, isA<NoConnectionFailure>());
  });

  test(
    'Tolak shows Penugasan Dialihkan and makes the user Unavailable',
    () async {
      when(() => repo.decline(any()))
          .thenAnswer((_) async => const Result.ok(null));
      await startWithAssignment();
      final lost = bloc.availabilityLost.first;
      bloc.add(const TaskRejectConfirmed());
      await settle();
      expect(
        (bloc.state as TaskResult).outcome.reason,
        ResolutionReason.rejected,
      );
      expect(await lost, ResolutionReason.rejected);
    },
  );

  test('accepted on the watch: In Progress here, alerts stop', () async {
    await startWithAssignment();
    realtime.send(
      'work-order:updated',
      updatedPayload(task, 'ACCEPTED', by: watchActor),
    );
    await settle();
    expect(bloc.state, isA<TaskInProgress>());
    expect(alerts.running, isFalse);
  });

  test('auto-decline shows Waktu Habis', () async {
    await startWithAssignment();
    realtime.send('work-order:updated', updatedPayload(task, 'AUTO_DECLINED'));
    await settle();
    expect((bloc.state as TaskResult).outcome.reason, ResolutionReason.timeout);
  });

  test('COMPLETED ends the job; there is no Selesai (D-22)', () async {
    when(() => repo.accept(any()))
        .thenAnswer((_) async => Result.ok(AcceptResult(task, now)));
    await startWithAssignment();
    bloc
      ..add(const TaskAcceptPressed())
      ..add(const TaskAcceptedScreenClosed());
    await settle();
    final notice = bloc.notices.first;
    realtime.send('work-order:updated', updatedPayload(task, 'COMPLETED'));
    await settle();
    expect(bloc.state, isA<TaskIdle>());
    expect(await notice, TaskNotice.completed);
  });

  test('Batalkan Penugasan cancels and asks for a new Check In', () async {
    when(() => repo.cancel(any()))
        .thenAnswer((_) async => const Result.ok(null));
    await store.saveActiveTask(
      ActiveTask(
        task: task,
        phase: ActiveTaskPhase.inProgress,
        acceptedAt: now,
      ),
    );
    connectivity.online = false; // no snapshot overwrite at start
    await start();
    connectivity.online = true;
    bloc.add(const TaskCancelConfirmed());
    await settle();
    final s = bloc.state as TaskResult;
    expect(s.outcome.reason, ResolutionReason.cancelled);
    expect(s.outcome.reason.makesUnavailable, isTrue);
  });

  test('no new popup while a job is In Progress (doc 4.2 rule 6)', () async {
    when(() => repo.accept(any()))
        .thenAnswer((_) async => Result.ok(AcceptResult(task, now)));
    await startWithAssignment();
    bloc.add(const TaskAcceptPressed());
    await settle();
    await store.saveActiveTask(
      ActiveTask(
        task: task,
        phase: ActiveTaskPhase.inProgress,
        acceptedAt: now,
      ),
    );
    realtime.send('work-order:assigned', {
      'work_order': workOrderJson(sampleTask(now, id: 't-2')),
    });
    await settle();
    expect(bloc.state, isA<TaskInProgress>());
  });

  group('snapshot is the truth (backend guide part 4 rule 1)', () {
    test('a pending work order in the snapshot opens the popup', () async {
      await start();
      realtime.send('state:snapshot', snapshotPayload(pending: task));
      await settle();
      expect((bloc.state as TaskAssigned).task.taskId, task.taskId);
    });

    test('an active work order restores In Progress after a restart', () async {
      await start();
      realtime.send('state:snapshot', snapshotPayload(active: task));
      await settle();
      expect(bloc.state, isA<TaskInProgress>());
      expect((await store.activeTask())?.isInProgress, isTrue);
    });

    test(
      'a popup missing from the snapshot after expiry is explained',
      () async {
        await startWithAssignment();
        clock.advance(const Duration(minutes: 2));
        realtime.send('state:snapshot', snapshotPayload());
        await settle();
        expect(
          (bloc.state as TaskResult).outcome.reason,
          ResolutionReason.offlineMissed,
        );
      },
    );

    test('a job missing from the snapshot was finished meanwhile', () async {
      await store.saveActiveTask(
        ActiveTask(
          task: task,
          phase: ActiveTaskPhase.inProgress,
          acceptedAt: now,
        ),
      );
      await start(); // HTTP snapshot: no work order
      expect(bloc.state, isA<TaskIdle>());
      expect(await store.activeTask(), isNull);
    });

    test('without the socket the state is fetched over HTTP', () async {
      await start();
      verify(repo.fetchState).called(1);
    });

    test(
      'with the socket connected, it waits for the socket snapshot',
      () async {
        realtime.connected = true;
        await start();
        verifyNever(repo.fetchState);
      },
    );
  });

  test('local expiry waits for the server, then shows Waktu Habis', () async {
    when(repo.fetchState).thenAnswer(
      (_) async =>
          Result.ok(StateSnapshot.parse(snapshotPayload(pending: task))),
    );
    await startWithAssignment();
    clock.advance(const Duration(seconds: 61));
    bloc.add(const TaskCountdownExpired());
    await settle();
    expect((bloc.state as TaskAssigned).action, TaskAction.checkingExpiry);
    // The server auto-declines a few seconds later.
    realtime.send('work-order:updated', updatedPayload(task, 'AUTO_DECLINED'));
    await settle();
    expect((bloc.state as TaskResult).outcome.reason, ResolutionReason.timeout);
  });

  test('local expiry when the job was accepted elsewhere', () async {
    await startWithAssignment();
    when(repo.fetchState).thenAnswer(
      (_) async =>
          Result.ok(StateSnapshot.parse(snapshotPayload(active: task))),
    );
    clock.advance(const Duration(seconds: 61));
    bloc.add(const TaskCountdownExpired());
    await settle();
    expect(bloc.state, isA<TaskInProgress>());
  });

  test('closing a result shows the next unseen result, then idle', () async {
    await store.addPendingResult(
      TaskOutcome(task: task, reason: ResolutionReason.timeout),
      nowUtc: now,
    );
    await store.addPendingResult(
      TaskOutcome(
        task: sampleTask(now, id: 't-2'),
        reason: ResolutionReason.lateDelivery,
      ),
      nowUtc: now.add(const Duration(seconds: 1)),
    );
    await start();
    expect((bloc.state as TaskResult).outcome.task.taskId, 't-1');
    bloc.add(const TaskResultClosed());
    await settle();
    expect((bloc.state as TaskResult).outcome.task.taskId, 't-2');
    bloc.add(const TaskResultClosed());
    await settle();
    expect(bloc.state, isA<TaskIdle>());
  });

  test('nothing is processed after the session stopped', () async {
    await start();
    bloc.add(const TaskSessionStopped());
    await settle();
    realtime.send('work-order:assigned', {'work_order': workOrderJson(task)});
    await settle();
    expect(bloc.state, isA<TaskIdle>());
  });
}
