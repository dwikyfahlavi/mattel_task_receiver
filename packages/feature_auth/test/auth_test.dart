import 'dart:async';

import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:fake_async/fake_async.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements AuthRepository {}

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

class _Realtime implements RealtimeService {
  // ignore: close_sinks, lives for one test only
  final c = StreamController<RealtimeEvent>.broadcast();
  RealtimeMode? started;

  void send(String name, Object? payload) =>
      c.add(RealtimeEvent.parse(name, payload));

  @override
  Stream<RealtimeEvent> get events => c.stream;
  @override
  Stream<bool> get connectionChanges => const Stream.empty();
  @override
  bool get isConnected => started != null;
  @override
  RealtimeMode? get mode => started;
  @override
  void start(RealtimeMode mode) => started = mode;
  @override
  Future<void> stop() async => started = null;
  @override
  void reconnectNow() {}
  @override
  Future<bool> ack(String workOrderId) async => true;
}

const _user = UserProfile(kpk: 31, name: 'Budi Andika', shift: 'S1');

SessionInfo _info(DateTime cutoff) => SessionInfo(
  user: _user,
  policy: SessionPolicy(sessionExpiresAt: cutoff, graceSeconds: 900),
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
  final now = DateTime.utc(2026, 10, 27, 3);
  late _MockRepo repo;

  setUp(() {
    repo = _MockRepo();
    when(() => repo.endSession(callServer: any(named: 'callServer')))
        .thenAnswer((_) async {});
    when(repo.verifySession).thenAnswer((_) async => const Result.ok(null));
  });

  group('UserProfile', () {
    test('initials and KPK', () {
      expect(_user.initials, 'BA');
      expect(_user.firstName, 'Budi');
      expect(_user.id, '31');
    });

    test('parses the login technician', () {
      final u = UserProfile.fromJson({
        'kpk': 31,
        'name': 'Mulyadi',
        'shift': 'S1',
      });
      expect(u.kpk, 31);
      expect(u.role, UserRole.technician);
    });
  });

  group('LoginCubit (KPK + phone number)', () {
    test('Masuk is disabled until both fields are filled', () {
      final cubit = LoginCubit(repo);
      expect(cubit.state.canSubmit, isFalse);
      cubit.kpkChanged('31');
      expect(cubit.state.canSubmit, isFalse);
      cubit.passwordChanged('081234567890');
      expect(cubit.state.canSubmit, isTrue);
    });

    test('a non-numeric or too long KPK never reaches the server', () async {
      for (final kpk in ['abc', '1234567890']) {
        final cubit = LoginCubit(repo)
          ..kpkChanged(kpk)
          ..passwordChanged('0812');
        await cubit.submit();
        expect(cubit.state.kpkError, LoginFieldError.invalidKpk);
      }
      verifyNever(
        () => repo.login(
          kpk: any(named: 'kpk'),
          password: any(named: 'password'),
          remember: any(named: 'remember'),
        ),
      );
    });

    test('401 shows "KPK atau password salah!" (never which one)', () async {
      when(
        () => repo.login(
          kpk: any(named: 'kpk'),
          password: any(named: 'password'),
          remember: any(named: 'remember'),
        ),
      ).thenAnswer(
        (_) async => const Result.err(
          ApiFailure(statusCode: 401, code: ApiErrorCode.invalidCredentials),
        ),
      );
      final cubit = LoginCubit(repo)
        ..kpkChanged('31')
        ..passwordChanged('0000');
      await cubit.submit();
      expect(cubit.state.invalidCredentials, isTrue);
      expect(cubit.state.failure, isNull);
    });

    test('429 lockout is a non-field error with the wait time', () async {
      const lock = ApiFailure(
        statusCode: 429,
        code: ApiErrorCode.rateLimited,
        retryAfter: Duration(minutes: 15),
      );
      when(
        () => repo.login(
          kpk: any(named: 'kpk'),
          password: any(named: 'password'),
          remember: any(named: 'remember'),
        ),
      ).thenAnswer((_) async => const Result.err(lock));
      final cubit = LoginCubit(repo)
        ..kpkChanged('31')
        ..passwordChanged('0812');
      await cubit.submit();
      expect(cubit.state.failure, lock);
    });
  });

  group('SessionCubit (doc 4.3 / 8.1)', () {
    late AppDatabase db;
    late SessionEventBus bus;
    late _Realtime realtime;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      bus = SessionEventBus();
      realtime = _Realtime();
    });
    tearDown(() => db.close());

    SessionCubit build(AppKind kind, {bool autoLogoutMobile = false}) =>
        SessionCubit(
          repository: repo,
          events: bus,
          clock: _Clock(now),
          config: _config(kind),
          flags: DefaultFeatureFlags({
            FeatureFlag.autoLogoutMobile: autoLogoutMobile,
          }),
          taskStore: TaskEventStore(db),
          keyValues: KeyValueStore(db),
          realtime: realtime,
        );

    test('watch: an expired session is dropped at cold start', () async {
      when(
        repo.restore,
      ).thenAnswer((_) async => _info(now.subtract(const Duration(hours: 1))));
      final cubit = build(AppKind.watch);
      await cubit.restore();
      expect(
        (cubit.state as SessionUnauthenticated).reason,
        SessionEndReason.shiftEnd,
      );
      // Best effort unpair so the next worker starts clean.
      verify(() => repo.endSession(callServer: true)).called(1);
    });

    test(
      'mobile keeps the session at shift end unless auto_logout_mobile is on',
      () async {
        when(repo.restore).thenAnswer(
          (_) async => _info(now.subtract(const Duration(hours: 1))),
        );
        final keep = build(AppKind.mobile);
        await keep.restore();
        expect(keep.state, isA<SessionAuthenticated>());

        final drop = build(AppKind.mobile, autoLogoutMobile: true);
        await drop.restore();
        expect(drop.state, isA<SessionUnauthenticated>());
      },
    );

    test('a session ended by a background push is wiped at start', () async {
      when(repo.restore)
          .thenAnswer((_) async => _info(now.add(const Duration(hours: 4))));
      await KeyValueStore(db).write(sessionEndedKey, 'REPLACED');
      final cubit = build(AppKind.mobile);
      await cubit.restore();
      expect(
        (cubit.state as SessionUnauthenticated).reason,
        SessionEndReason.replaced,
      );
      verify(() => repo.endSession(callServer: false)).called(1);
    });

    test(
      'session:ended on the socket ends the session without logout',
      () async {
        final cubit = build(AppKind.mobile)
          ..signedIn(_info(now.add(const Duration(hours: 4))));
        realtime.send('session:ended', {'reason': 'REPLACED'});
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(
          (cubit.state as SessionUnauthenticated).reason,
          SessionEndReason.replaced,
        );
        verify(() => repo.endSession(callServer: false)).called(1);
      },
    );

    test(
      'a refused socket token is verified over HTTP, once at a time',
      () async {
        final gate = Completer<Result<void>>();
        when(repo.verifySession).thenAnswer((_) => gate.future);
        build(AppKind.mobile)
            .signedIn(_info(now.add(const Duration(hours: 4))));
        realtime
          ..c.add(const RealtimeAuthRejected())
          ..c.add(const RealtimeAuthRejected());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        verify(repo.verifySession).called(1);
        gate.complete(const Result.ok(null));
      },
    );

    test('server reasons map to session end reasons', () {
      expect(
        SessionCubit.reasonFromServer('EXPIRED'),
        SessionEndReason.expired,
      );
      expect(
        SessionCubit.reasonFromServer('DEVICE_DISABLED'),
        SessionEndReason.deviceDisabled,
      );
      expect(
        SessionCubit.reasonFromServer('CHECK_OUT'),
        SessionEndReason.unpaired,
      );
      expect(SessionCubit.reasonFromServer('???'), SessionEndReason.revoked);
    });

    test('Keluar calls the server; concurrent requests wipe once', () async {
      final gate = Completer<void>();
      when(() => repo.endSession(callServer: any(named: 'callServer')))
          .thenAnswer((_) => gate.future);
      final cubit = build(AppKind.watch)
        ..signedIn(_info(now.add(const Duration(hours: 4))));
      bus
        ..requestEnd(SessionEndReason.expired)
        ..requestEnd(SessionEndReason.revoked);
      unawaited(cubit.end(SessionEndReason.logout));
      await Future<void>.delayed(Duration.zero);
      gate.complete();
      await Future<void>.delayed(const Duration(milliseconds: 10));
      verify(() => repo.endSession(callServer: any(named: 'callServer')))
          .called(1);
      expect(cubit.state, isA<SessionUnauthenticated>());
    });
  });

  group('PairQrPayload', () {
    test('the watch QR carries a pairing code', () {
      expect(
        PairQrPayload.pairingCode('{"v":1,"t":"pair","code":"AbC123"}'),
        'AbC123',
      );
      expect(
        PairQrPayload.pairingCode('{"v":2,"t":"pair","code":"x"}'),
        isNull,
      );
      expect(PairQrPayload.pairingCode('hello'), isNull);
    });

    test('the admin enrollment QR is "not a watch pairing code"', () {
      const enroll = '{"v":1,"code":"K7M2Q9XD4B"}';
      expect(PairQrPayload.pairingCode(enroll), isNull);
      expect(PairQrPayload.isOtherKind(enroll), isTrue);
      expect(PairQrPayload.enrollmentCode(enroll), 'K7M2Q9XD4B');
    });

    test('typed enrollment codes are normalised', () {
      expect(PairQrPayload.enrollmentCode(' k7m2-q9xd 4b '), 'K7M2Q9XD4B');
      expect(
        PairQrPayload.enrollmentCode('{"v":1,"t":"pair","code":"x"}'),
        isNull,
      );
      expect(PairQrPayload.normalizeEnrollmentCode('ab'), isNull);
    });
  });

  group('PairWatchCubit (phone approves, part 1 step 8)', () {
    const qr = '{"v":1,"t":"pair","code":"C0DE"}';
    const watch = DeviceDto(name: 'Watch 1', location: 'Line B');

    test('scan -> preview -> confirm -> approve', () async {
      when(() => repo.previewPairing('C0DE')).thenAnswer(
        (_) async => const Result.ok(PairingPreviewDto(device: watch)),
      );
      when(() => repo.approvePairing('C0DE'))
          .thenAnswer((_) async => const Result.ok(watch));
      final cubit = PairWatchCubit(repository: repo, connectivity: _Online());
      await cubit.scanned(qr);
      expect((cubit.state as PairConfirming).device.name, 'Watch 1');
      await cubit.confirm();
      expect(cubit.state, isA<PairSuccess>());
    });

    test('an expired QR (404) is a failure with the right code', () async {
      const expired = ApiFailure(
        statusCode: 404,
        code: ApiErrorCode.pairCodeInvalid,
      );
      when(() => repo.previewPairing(any()))
          .thenAnswer((_) async => const Result.err(expired));
      final cubit = PairWatchCubit(repository: repo, connectivity: _Online());
      await cubit.scanned(qr);
      expect((cubit.state as PairFailure).failure, expired);
    });

    test('the enrollment QR is rejected as not a watch code', () async {
      final cubit = PairWatchCubit(repository: repo, connectivity: _Online());
      await cubit.scanned('{"v":1,"code":"K7M2Q9XD4B"}');
      expect(
        (cubit.state as PairScanning).rejection,
        ScanRejection.notWatchCode,
      );
      await cubit.scanned('garbage');
      expect(cubit.state, isA<PairScanning>());
    });

    test('pairing requires network', () async {
      final online = _Online()..online = false;
      final cubit = PairWatchCubit(repository: repo, connectivity: online);
      await cubit.scanned(qr);
      expect((cubit.state as PairFailure).failure, isA<NoConnectionFailure>());
      verifyNever(() => repo.previewPairing(any()));
    });
  });

  group('WatchEnrollCubit (part 2 step 2)', () {
    test('a hardware scan of the admin QR enrolls at once', () async {
      when(() => repo.enroll('K7M2Q9XD4B')).thenAnswer(
        (_) async => const Result.ok(DeviceDto(id: 'd1', name: 'Watch 1')),
      );
      final scans = StreamController<String>();
      final cubit = WatchEnrollCubit(
        repository: repo,
        connectivity: _Online(),
        hardwareScans: scans.stream,
      );
      scans.add('{"v":1,"code":"K7M2Q9XD4B"}');
      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(cubit.state.device?.id, 'd1');
      await cubit.close();
      await scans.close();
    });

    test('an invalid code is refused locally', () async {
      final cubit = WatchEnrollCubit(repository: repo, connectivity: _Online())
        ..codeChanged('x!');
      await cubit.submit();
      expect(cubit.state.invalidCode, isTrue);
      verifyNever(() => repo.enroll(any()));
    });

    test('a 401 from the server is shown', () async {
      const bad = ApiFailure(
        statusCode: 401,
        code: ApiErrorCode.enrollmentCodeInvalid,
      );
      when(() => repo.enroll(any()))
          .thenAnswer((_) async => const Result.err(bad));
      final cubit = WatchEnrollCubit(repository: repo, connectivity: _Online())
        ..codeChanged('K7M2Q9XD4B');
      await cubit.submit();
      expect(cubit.state.failure, bad);
    });
  });

  group('WatchPairingCubit (part 2 step 4)', () {
    PairingDto pairing(String id, DateTime expires) => PairingDto(
      pairingId: id,
      expiresAt: expires,
      qrPayload: '{"v":1,"t":"pair","code":"$id"}',
    );

    test('pairing:approved on the socket exchanges at once', () {
      fakeAsync((async) {
        final realtime = _Realtime();
        when(repo.createPairing).thenAnswer(
          (_) async =>
              Result.ok(pairing('p1', now.add(const Duration(seconds: 60)))),
        );
        when(() => repo.pairingStatus(any()))
            .thenAnswer((_) async => const Result.ok(PairingStatus.pending));
        when(() => repo.exchangePairing('p1'))
            .thenAnswer((_) async => Result.ok(_info(now)));
        final cubit = WatchPairingCubit(
          repository: repo,
          realtime: realtime,
          clock: _Clock(now),
        );
        unawaited(cubit.start());
        async.flushMicrotasks();
        expect(realtime.started, RealtimeMode.unpaired);
        expect(cubit.state, isA<PairingShowing>());
        realtime.send('pairing:approved', {'pairing_id': 'p1'});
        async.flushMicrotasks();
        expect(cubit.state, isA<PairingDone>());
        expect(realtime.started, isNull, reason: 'paired socket replaces it');
        unawaited(cubit.close());
        async.flushMicrotasks();
      });
    });

    test('the status poll is the fallback when the socket is down', () {
      fakeAsync((async) {
        when(repo.createPairing).thenAnswer(
          (_) async =>
              Result.ok(pairing('p1', now.add(const Duration(seconds: 60)))),
        );
        when(() => repo.pairingStatus('p1'))
            .thenAnswer((_) async => const Result.ok(PairingStatus.approved));
        when(() => repo.exchangePairing('p1'))
            .thenAnswer((_) async => Result.ok(_info(now)));
        final cubit = WatchPairingCubit(repository: repo, clock: _Clock(now));
        unawaited(cubit.start());
        async
          ..flushMicrotasks()
          ..elapse(const Duration(seconds: 2));
        expect(cubit.state, isA<PairingDone>());
        verify(() => repo.exchangePairing('p1')).called(1);
        unawaited(cubit.close());
        async.flushMicrotasks();
      });
    });

    test('a new QR about every 55 s while visible', () {
      fakeAsync((async) {
        var n = 0;
        when(repo.createPairing).thenAnswer((_) async {
          n++;
          return Result.ok(
            pairing('p$n', now.add(const Duration(seconds: 60))),
          );
        });
        when(() => repo.pairingStatus(any()))
            .thenAnswer((_) async => const Result.ok(PairingStatus.pending));
        final cubit = WatchPairingCubit(repository: repo, clock: _Clock(now));
        unawaited(cubit.start());
        async
          ..flushMicrotasks()
          ..elapse(const Duration(seconds: 54));
        expect(n, 1);
        async.elapse(const Duration(seconds: 2));
        expect(n, 2);
        unawaited(cubit.close());
        async.flushMicrotasks();
      });
    });

    test('a refused device signature asks to enroll again', () {
      fakeAsync((async) {
        when(repo.createPairing).thenAnswer(
          (_) async => const Result.err(
            ApiFailure(statusCode: 401, code: ApiErrorCode.invalidSignature),
          ),
        );
        final cubit = WatchPairingCubit(repository: repo, clock: _Clock(now));
        unawaited(cubit.start());
        async.flushMicrotasks();
        expect(cubit.state, isA<PairingDeviceRejected>());
        unawaited(cubit.close());
        async.flushMicrotasks();
      });
    });

    test('offline shows "Buat Ulang QR Code"', () {
      fakeAsync((async) {
        when(repo.createPairing)
            .thenAnswer((_) async => const Result.err(NoConnectionFailure()));
        final cubit = WatchPairingCubit(repository: repo, clock: _Clock(now));
        unawaited(cubit.start());
        async.flushMicrotasks();
        expect((cubit.state as PairingExpired).offline, isTrue);
        unawaited(cubit.close());
        async.flushMicrotasks();
      });
    });
  });
}
