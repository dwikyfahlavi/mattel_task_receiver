import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_availability/feature_availability.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permission_handler/permission_handler.dart';

class _MockRepo extends Mock implements AvailabilityRepository {}

class _MockTasks extends MockBloc<TaskSessionEvent, TaskSessionState>
    implements TaskSessionBloc {}

class _MockSession extends MockCubit<SessionState> implements SessionCubit {}

class _MockPatches extends Mock implements PatchUpdater {}

class _Probe implements ReadinessProbe {
  bool online = true;
  bool battery = true;
  bool notifications = true;
  @override
  bool isOnline() => online;
  @override
  bool isClockSkewed() => false;
  @override
  Future<PermissionStatus> notificationPermission() async =>
      notifications ? PermissionStatus.granted : PermissionStatus.denied;
  @override
  Future<bool> alertChannelEnabled() async => true;
  @override
  Future<bool> canUseFullScreenIntent() async => true;
  @override
  Future<bool> playServicesAvailable() async => true;
  @override
  bool isRealtimeConnected() => true;
  @override
  Future<bool> batteryOptimizationExempt() async => battery;
}

class _Online implements ConnectivityService {
  bool online = true;
  @override
  bool get isOnline => online;
  @override
  Stream<bool> get onlineChanges => const Stream.empty();
  @override
  Future<void> start() async {}
  @override
  void reportReachable() {}
  @override
  void reportUnreachable() {}
  @override
  Future<void> dispose() async {}
}

class _Clock extends AppClock {
  _Clock(this.now);
  DateTime now;
  @override
  DateTime serverNowUtc() => now;
  @override
  DateTime deviceNowUtc() => now;
  @override
  Duration get serverOffset => Duration.zero;
  @override
  bool get hasServerTime => true;
  @override
  void updateServerTime(DateTime serverUtc) => now = serverUtc;
}

final _now = DateTime.utc(2026, 10, 27, 3);

TaskAssignment _task() => TaskAssignment(
  taskId: 't',
  machineCode: 'FAR012',
  location: 'B-12',
  issue: 'Changeover',
  assignedAt: _now,
  expiresAt: _now.add(const Duration(seconds: 60)),
);

AppConfig _config(AppKind kind) => AppConfig.fromValues(
  environment: AppEnvironment.dev,
  kind: kind,
  rawBaseUrl: '',
  rawPins: '',
  rawFake: '',
  rawKeys: '',
  isReleaseBuild: false,
);

void main() {
  late _MockRepo repo;
  late _MockTasks tasks;
  late _Probe probe;
  late _Online online;
  late StreamController<ResolutionReason> lost;
  late StreamController<OutboxConflict> conflicts;

  setUp(() {
    repo = _MockRepo();
    tasks = _MockTasks();
    probe = _Probe();
    online = _Online();
    lost = StreamController<ResolutionReason>.broadcast();
    conflicts = StreamController<OutboxConflict>.broadcast();
    when(() => tasks.state).thenReturn(const TaskSessionState.idle());
    when(() => tasks.availabilityLost).thenAnswer((_) => lost.stream);
    when(() => repo.checkOutConflicts).thenAnswer((_) => conflicts.stream);
    when(repo.checkIn).thenAnswer(
      (_) async =>
          Result.ok(TechnicianStatus(checkedIn: true, checkedInAt: _now)),
    );
    when(() => repo.checkOut(sessionExpiresAt: any(named: 'sessionExpiresAt')))
        .thenAnswer((_) async {});
    when(repo.checkOutNow).thenAnswer((_) async {});
  });
  tearDown(() async {
    await lost.close();
    await conflicts.close();
  });

  AvailabilityBloc build() => AvailabilityBloc(
    repository: repo,
    readiness: ReadinessService(probe, AppKind.mobile),
    tasks: tasks,
    connectivity: online,
    clock: _Clock(_now),
  );

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 20));

  group('AvailabilityBloc', () {
    test('status:changed and snapshots drive the status (socket)', () async {
      final events = StreamController<RealtimeEvent>.broadcast();
      final realtime = _Realtime(events.stream);
      final bloc = AvailabilityBloc(
        repository: repo,
        readiness: ReadinessService(probe, AppKind.mobile),
        tasks: tasks,
        connectivity: online,
        clock: _Clock(_now),
        realtime: realtime,
      );
      // Checked in on the other device.
      events.add(
        RealtimeEvent.parse('status:changed', {
          'status': {
            'checked_in': true,
            'checked_in_at': _now.toIso8601String(),
            'is_available': true,
          },
          'reason': 'CHECK_IN',
        }),
      );
      await settle();
      expect(bloc.state.available, isTrue);
      expect(bloc.state.checkedInAt, _now);
      // The reconnect snapshot says checked out (auto-decline meanwhile).
      events.add(
        RealtimeEvent.parse('state:snapshot', {
          'self': {'kind': 'PERSONAL'},
          'status': {'checked_in': false},
        }),
      );
      await settle();
      expect(bloc.state.available, isFalse);
      await bloc.close();
      await events.close();
    });

    test('Check In succeeds when the device is ready', () async {
      final bloc = build()..add(const CheckInPressed());
      await settle();
      expect(bloc.state.available, isTrue);
      expect(bloc.state.checkedInAt, _now);
      await bloc.close();
    });

    test(
      'readiness failure blocks Check In without calling the server',
      () async {
        probe.online = false;
        final bloc = build()..add(const CheckInPressed());
        await settle();
        expect(bloc.state.available, isFalse);
        expect(bloc.state.readiness?.canCheckIn, isFalse);
        expect(bloc.state.readinessForCheckIn, isTrue);
        verifyNever(repo.checkIn);
        await bloc.close();
      },
    );

    test(
      'background recheck raises a blocking problem without checking in',
      () async {
        probe.notifications = false;
        final bloc = build()..add(const ReadinessRecheckRequested());
        await settle();
        expect(bloc.state.readiness?.canCheckIn, isFalse);
        expect(bloc.state.readinessForCheckIn, isFalse);
        verifyNever(repo.checkIn);
        await bloc.close();
      },
    );

    test(
      'background recheck stays quiet when only the network is down',
      () async {
        probe.online = false;
        final bloc = build()..add(const ReadinessRecheckRequested());
        await settle();
        expect(bloc.state.readiness, isNull);
        await bloc.close();
      },
    );

    test('background recheck stays quiet for warnings only', () async {
      probe.battery = false;
      final bloc = build()..add(const ReadinessRecheckRequested());
      await settle();
      expect(bloc.state.readiness, isNull);
      await bloc.close();
    });

    test(
      'a refused queued Check Out notifies and reloads from the server',
      () async {
        when(repo.current).thenAnswer(
          (_) async =>
              Result.ok(TechnicianStatus(checkedIn: true, checkedInAt: _now)),
        );
        final bloc = build()..add(const CheckInPressed());
        await settle();
        bloc.add(const CheckOutPressed());
        await settle();
        expect(bloc.state.available, isFalse);
        conflicts.add(const OutboxConflict(OutboxAction.checkOut, null));
        await settle();
        expect(bloc.state.checkOutConflictCount, 1);
        expect(bloc.state.available, isTrue);
        await bloc.close();
      },
    );

    test(
      'warnings show the checklist once, then continue on request',
      () async {
        probe.battery = false;
        final bloc = build()..add(const CheckInPressed());
        await settle();
        expect(bloc.state.readiness, isNotNull);
        verifyNever(repo.checkIn);
        bloc
          ..add(const ReadinessDismissed())
          ..add(const CheckInPressed(skipWarnings: true));
        await settle();
        expect(bloc.state.available, isTrue);
        await bloc.close();
      },
    );

    test(
      'Check Out is blocked while a task is In Progress (doc 4.2 rule 6)',
      () async {
        final bloc = build()..add(const CheckInPressed());
        await settle();
        when(() => tasks.state).thenReturn(
          TaskSessionState.inProgress(task: _task(), acceptedAt: _now),
        );
        bloc.add(const CheckOutPressed());
        await settle();
        expect(bloc.state.available, isTrue);
        expect(bloc.state.checkOutBlockedCount, 1);
        verifyNever(
          () => repo.checkOut(sessionExpiresAt: any(named: 'sessionExpiresAt')),
        );
        await bloc.close();
      },
    );

    test(
      'Check Out offline is queued and the UI switches immediately',
      () async {
        final bloc = build()..add(const CheckInPressed());
        await settle();
        online.online = false;
        bloc.add(const CheckOutPressed());
        await settle();
        expect(bloc.state.available, isFalse);
        expect(bloc.state.checkOutQueuedCount, 1);
        await bloc.close();
      },
    );

    test('reject or timeout makes the technician Unavailable', () async {
      final bloc = build()..add(const CheckInPressed());
      await settle();
      lost.add(ResolutionReason.timeout);
      await settle();
      expect(bloc.state.available, isFalse);
      await bloc.close();
    });

    test('a double tap on Check In sends one request', () async {
      final gate = Completer<Result<TechnicianStatus>>();
      when(repo.checkIn).thenAnswer((_) => gate.future);
      final bloc = build()
        ..add(const CheckInPressed())
        ..add(const CheckInPressed());
      await settle();
      gate.complete(const Result.ok(TechnicianStatus(checkedIn: true)));
      await settle();
      verify(repo.checkIn).called(1);
      await bloc.close();
    });
  });

  group('ShiftEndCubit (doc 4.3)', () {
    late _MockSession session;
    late _MockPatches patches;
    late _Clock clock;
    final cutoff = _now.add(const Duration(minutes: 10));
    final info = SessionInfo(
      user: const UserProfile(kpk: 31, name: 'Budi'),
      policy: SessionPolicy(sessionExpiresAt: cutoff, graceSeconds: 600),
    );

    setUp(() {
      session = _MockSession();
      patches = _MockPatches();
      clock = _Clock(_now);
      when(() => session.state).thenReturn(SessionState.authenticated(info));
      when(() => session.end(any())).thenAnswer((_) async {});
      when(patches.restartIfReady).thenAnswer((_) async {});
    });

    setUpAll(() => registerFallbackValue(SessionEndReason.logout));

    ShiftEndCubit shift(
      AppKind kind,
      AvailabilityBloc availability, {
      bool logout = true,
      void Function()? onShiftEnd,
    }) {
      when(() => session.logsOutAtShiftEnd).thenReturn(logout);
      return ShiftEndCubit(
        session: session,
        tasks: tasks,
        availability: availability,
        clock: clock,
        patches: patches,
        config: _config(kind),
        onShiftEnd: onShiftEnd,
      );
    }

    test('runs the shift-end hook (version check) once per cutoff', () async {
      var calls = 0;
      final cubit = shift(
        AppKind.mobile,
        build(),
        logout: false,
        onShiftEnd: () => calls++,
      );
      clock.now = cutoff;
      cubit
        ..evaluate()
        ..evaluate();
      await settle();
      expect(calls, 1);
      await cubit.close();
    });

    test('watch: the shift-end hook runs after the logout', () async {
      final order = <String>[];
      when(() => session.end(any())).thenAnswer((_) async => order.add('end'));
      final cubit = shift(
        AppKind.watch,
        build(),
        onShiftEnd: () => order.add('hook'),
      );
      clock.now = cutoff;
      cubit.evaluate();
      await settle();
      expect(order, ['end', 'hook']);
      await cubit.close();
    });

    test('warning banner in the last 15 minutes', () async {
      final cubit = shift(AppKind.watch, build())..evaluate();
      expect(cubit.state, ShiftEndingBanner(cutoff));
      await cubit.close();
    });

    test('watch: logs out at the cutoff and applies a pending patch', () async {
      final cubit = shift(AppKind.watch, build());
      clock.now = cutoff;
      cubit.evaluate();
      await settle();
      verify(() => session.end(SessionEndReason.shiftEnd)).called(1);
      verify(patches.restartIfReady).called(1);
      await cubit.close();
    });

    test('never logs out mid-job; forces it after the grace period', () async {
      when(() => tasks.state).thenReturn(
        TaskSessionState.inProgress(task: _task(), acceptedAt: _now),
      );
      final cubit = shift(AppKind.watch, build());
      clock.now = cutoff.add(const Duration(minutes: 1));
      cubit.evaluate();
      await settle();
      expect(cubit.state, isA<ShiftBlockedBanner>());
      verifyNever(() => session.end(any()));

      clock.now = cutoff.add(const Duration(minutes: 11));
      cubit.evaluate();
      await settle();
      verify(() => session.end(SessionEndReason.shiftEnd)).called(1);
      await cubit.close();
    });

    test(
      'mobile without auto_logout_mobile checks out once and stays signed in',
      () async {
        final availability = build();
        availability.add(const CheckInPressed());
        await settle();
        final cubit = shift(AppKind.mobile, availability, logout: false);
        clock.now = cutoff;
        cubit
          ..evaluate()
          ..evaluate();
        await settle();
        verify(repo.checkOutNow).called(1);
        verifyNever(() => session.end(any()));
        expect(availability.state.available, isFalse);
        await cubit.close();
      },
    );
  });
}

class _Realtime implements RealtimeService {
  _Realtime(this.events);

  @override
  final Stream<RealtimeEvent> events;
  @override
  Stream<bool> get connectionChanges => const Stream.empty();
  @override
  bool get isConnected => true;
  @override
  RealtimeMode? get mode => RealtimeMode.paired;
  @override
  void start(RealtimeMode mode) {}
  @override
  Future<void> stop() async {}
  @override
  void reconnectNow() {}
  @override
  Future<bool> ack(String workOrderId) async => true;
}
