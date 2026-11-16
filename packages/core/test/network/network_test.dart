import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers.dart';

class _MockStorage extends Mock implements FlutterSecureStorage {}

/// Programmable server: [reply] decides each answer.
class _Server implements HttpClientAdapter {
  _Server(this.reply);

  ({int status, Object? body, Map<String, String> headers}) Function(
    RequestOptions o,
    List<int> body,
  )
  reply;
  final requests = <RequestOptions>[];
  final bodies = <List<int>>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final bytes = <int>[];
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        bytes.addAll(chunk);
      }
    }
    requests.add(options);
    bodies.add(bytes);
    final r = reply(options, bytes);
    return ResponseBody.fromString(
      jsonEncode(r.body),
      r.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final h in r.headers.entries) h.key: [h.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

({int status, Object? body, Map<String, String> headers}) ok(Object? data) => (
  status: 200,
  body: {'status_code': 200, 'message': 'OK', 'data': data},
  headers: {},
);

({int status, Object? body, Map<String, String> headers}) err(
  int status,
  String message, {
  Map<String, String> headers = const {},
}) => (
  status: status,
  body: {'message': message, 'statusCode': status},
  headers: headers,
);

String jwt(String sessionId) {
  String b64(Map<String, Object?> m) =>
      base64Url.encode(utf8.encode(jsonEncode(m))).replaceAll('=', '');
  return '${b64({'alg': 'none'})}.${b64({'session_id': sessionId})}.sig';
}

Future<TokenStore> tokenStore() async {
  final storage = _MockStorage();
  when(() => storage.read(key: any(named: 'key')))
      .thenAnswer((_) async => null);
  when(
    () => storage.write(
      key: any(named: 'key'),
      value: any(named: 'value'),
    ),
  ).thenAnswer((_) async {});
  when(() => storage.delete(key: any(named: 'key'))).thenAnswer((_) async {});
  return TokenStore(SecureStore(storage));
}

void main() {
  group('ErrorMapper.classify (backend messages)', () {
    final cases = <(int, String, String?)>[
      (401, 'Invalid KPK or password', ApiErrorCode.invalidCredentials),
      (
        401,
        'Invalid or expired enrollment code',
        ApiErrorCode.enrollmentCodeInvalid,
      ),
      (401, 'Invalid device signature', ApiErrorCode.invalidSignature),
      (401, 'Unauthorized', ApiErrorCode.unauthorized),
      (403, 'Not a personal phone session', ApiErrorCode.wrongDevice),
      (404, 'Pairing code is invalid or expired', ApiErrorCode.pairCodeInvalid),
      (404, 'Work order not found', ApiErrorCode.workOrderNotFound),
      (
        409,
        'This work order was already answered',
        ApiErrorCode.workOrderAlreadyAnswered,
      ),
      (409, 'You are not checked in', ApiErrorCode.notCheckedIn),
      (
        409,
        'You are currently marked as unavailable',
        ApiErrorCode.technicianUnavailable,
      ),
      (
        409,
        'You have not accepted this work order',
        ApiErrorCode.workOrderNotAccepted,
      ),
      (
        409,
        'Pairing is EXPIRED, not approved',
        ApiErrorCode.pairingNotApproved,
      ),
      (429, 'Too many failed login attempts', ApiErrorCode.rateLimited),
      (400, 'kpk must be numeric', ApiErrorCode.badRequest),
      (500, 'boom', null),
    ];
    for (final (status, message, code) in cases) {
      test('$status "$message"', () {
        expect(ErrorMapper.classify(status, message), code);
      });
    }

    test('NestJS validation lists are joined', () {
      expect(
        ErrorMapper.messageOf({
          'message': ['kpk must be numeric', 'password is required'],
        }),
        'kpk must be numeric; password is required',
      );
    });
  });

  group('envelope, errors and the 401 rule', () {
    late TokenStore tokens;
    late RecordingSessionBus bus;
    late _Server server;
    late Dio dio;

    setUp(() async {
      tokens = await tokenStore();
      await tokens.save(const AuthTokens(accessToken: 't1'), persist: false);
      bus = RecordingSessionBus()..listen();
      server = _Server((o, _) => ok({'x': 1}));
      dio = Dio(BaseOptions(baseUrl: 'https://api.test/'))
        ..httpClientAdapter = server
        ..interceptors.addAll([
          ApiEnvelopeInterceptor(),
          AuthInterceptor(tokens: tokens, sessionEvents: bus),
        ]);
    });
    tearDown(() => bus.dispose());

    test('unwraps data and attaches the bearer token', () async {
      final r = await dio.get<dynamic>('technicians/me/state');
      expect(r.data, {'x': 1});
      expect(server.requests.single.headers['Authorization'], 'Bearer t1');
    });

    test('paged lists keep the pagination next to the items', () async {
      server.reply = (o, _) => (
        status: 200,
        body: {
          'status_code': 200,
          'message': 'OK',
          'data': [1, 2],
          'pagination': {
            'page': 1,
            'per_page': 20,
            'total_data': 2,
            'total_pages': 1,
          },
        },
        headers: const {},
      );
      final r = await dio.get<dynamic>('technicians/me/work-orders');
      expect(r.data, {
        'items': [1, 2],
        'pagination': {
          'page': 1,
          'per_page': 20,
          'total_data': 2,
          'total_pages': 1,
        },
      });
    });

    test('a 401 on a technician call ends the session (no refresh)', () async {
      server.reply = (o, _) => err(401, 'Unauthorized');
      final mapper = ErrorMapper(
        FakeAppClock(serverNowUtc: DateTime.utc(2026)),
      );
      final r = await mapper.guard(() => dio.get<dynamic>('x'));
      await Future<void>.delayed(Duration.zero);
      expect(r.failureOrNull, isA<SessionExpiredFailure>());
      expect(bus.ended, [SessionEndReason.expired]);
    });

    test('a 401 on login does not end anything', () async {
      server.reply = (o, _) => err(401, 'Invalid KPK or password');
      final mapper = ErrorMapper(
        FakeAppClock(serverNowUtc: DateTime.utc(2026)),
      );
      final r = await mapper.guard(
        () => dio.post<dynamic>(
          'technician-auth/login',
          options: RequestFlags.noAuth,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(
        (r.failureOrNull! as ApiFailure).code,
        ApiErrorCode.invalidCredentials,
      );
      expect(bus.ended, isEmpty);
    });

    test('a 401 for an old token after a new login is ignored', () async {
      server.reply = (o, _) {
        // The new token arrives while the old request is answered.
        unawaited(
          tokens.save(const AuthTokens(accessToken: 't2'), persist: false),
        );
        return err(401, 'Unauthorized');
      };
      await expectLater(dio.get<dynamic>('x'), throwsA(isA<DioException>()));
      await Future<void>.delayed(Duration.zero);
      expect(bus.ended, isEmpty);
    });

    test('429 carries retryAfter', () async {
      server.reply = (o, _) => (
        status: 429,
        body: {'message': 'Too many failed login attempts', 'retryAfter': 840},
        headers: const {},
      );
      final mapper = ErrorMapper(
        FakeAppClock(serverNowUtc: DateTime.utc(2026)),
      );
      final r = await mapper.guard(
        () => dio.post<dynamic>(
          'technician-auth/login',
          options: RequestFlags.noAuth,
        ),
      );
      expect(
        (r.failureOrNull! as ApiFailure).retryAfter,
        const Duration(seconds: 840),
      );
    });
  });

  group('watch request signing (backend guide part 2 step 3)', () {
    late TokenStore tokens;
    late DeviceIdentity identity;
    late FakeAppClock clock;
    late RequestSigner signer;
    late RecordingSessionBus bus;
    late _Server server;
    late Dio dio;
    final keys = FakeDeviceKeyStore();

    setUp(() async {
      tokens = await tokenStore();
      clock = FakeAppClock(serverNowUtc: DateTime.utc(2026, 11, 12, 4));
      final secure = SecureStore(
        memoryStorage({'device.enrolled_id': 'dev-1'}),
      );
      await keys.ensure();
      identity = DeviceIdentity(secure: secure, keys: keys);
      signer = RequestSigner(identity: identity, clock: clock);
      bus = RecordingSessionBus()..listen();
      server = _Server((o, _) => ok(null));
      dio = DioFactory.create(
        config: AppConfig.fromValues(
          environment: AppEnvironment.dev,
          kind: AppKind.watch,
          rawBaseUrl: 'https://api.test',
          rawPins: '',
          rawFake: '',
          rawKeys: '',
          isReleaseBuild: false,
        ),
        clock: clock,
        tokens: tokens,
        sessionEvents: bus,
        connectivity: _Online(),
        signer: signer,
        adapter: server,
      );
    });
    tearDown(() => bus.dispose());

    test('the signed text layout is exact', () {
      expect(
        RequestSigner.requestText(
          method: 'post',
          pathAndQuery: '/technicians/me/check-in',
          timestamp: '1700000000',
          nonce: 'abcdefghijklmnop',
          bodySha256: RequestSigner.emptyBodyHash,
        ),
        'request\nv1\nPOST\n/technicians/me/check-in\n1700000000\n'
        'abcdefghijklmnop\n'
        'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855\n',
      );
      expect(
        RequestSigner.enrollText(code: 'K7M2Q9XD4B', fingerprint: 'ff'),
        'enroll\nv1\nK7M2Q9XD4B\nff',
      );
    });

    test('path and query are signed exactly as sent', () {
      expect(
        RequestSigner.pathAndQueryOf(
          Uri.parse(
            'https://api.test/technicians/me/work-orders?page=2&perPage=20',
          ),
        ),
        '/technicians/me/work-orders?page=2&perPage=20',
      );
    });

    test('nonces are fresh, 16-64 chars of A-Za-z0-9_-', () {
      final a = signer.newNonce();
      final b = signer.newNonce();
      expect(a, isNot(b));
      expect(RegExp(r'^[A-Za-z0-9_-]{16,64}$').hasMatch(a), isTrue);
    });

    test('unpaired calls are signed with an empty session id', () async {
      await dio.post<dynamic>(
        'shared-devices/pairings',
        options: RequestFlags.noAuth,
      );
      final h = server.requests.single.headers;
      expect(h['X-Device-Id'], 'dev-1');
      expect(h.containsKey('Authorization'), isFalse);
      final text = RequestSigner.requestText(
        method: 'POST',
        pathAndQuery: '/shared-devices/pairings',
        timestamp: h['X-Timestamp'] as String,
        nonce: h['X-Nonce'] as String,
        bodySha256: RequestSigner.emptyBodyHash,
      );
      expect(h['X-Signature'], await keys.sign(text));
      expect(
        h['X-Timestamp'],
        '${clock.serverNowUtc().millisecondsSinceEpoch ~/ 1000}',
      );
    });

    test('paired calls sign the body bytes and the session id', () async {
      await tokens.save(AuthTokens(accessToken: jwt('sess-9')), persist: true);
      await dio.post<dynamic>('technicians/me/x', data: {'b': 1});
      final o = server.requests.single;
      final body = server.bodies.single;
      expect(utf8.decode(body), '{"b":1}');
      final text = RequestSigner.requestText(
        method: 'POST',
        pathAndQuery: '/technicians/me/x',
        timestamp: o.headers['X-Timestamp'] as String,
        nonce: o.headers['X-Nonce'] as String,
        bodySha256: RequestSigner.sha256Hex(body),
        sessionId: 'sess-9',
      );
      expect(o.headers['X-Signature'], await keys.sign(text));
    });

    test('a 401 with X-Server-Time fixes the clock and retries once', () async {
      await tokens.save(AuthTokens(accessToken: jwt('s')), persist: true);
      final serverSeconds =
          clock
              .serverNowUtc()
              .add(const Duration(minutes: 3))
              .millisecondsSinceEpoch ~/
          1000;
      var calls = 0;
      server.reply = (o, _) => ++calls == 1
          ? err(
              401,
              'Invalid device signature',
              headers: {'x-server-time': '$serverSeconds'},
            )
          : ok({'done': true});
      final r = await dio.post<dynamic>('technicians/me/check-in');
      expect(r.data, {'done': true});
      expect(server.requests, hasLength(2));
      final first = server.requests[0].headers;
      final second = server.requests[1].headers;
      expect(second['X-Nonce'], isNot(first['X-Nonce']));
      expect(second['X-Timestamp'], '$serverSeconds');
      await Future<void>.delayed(Duration.zero);
      expect(
        bus.ended,
        isEmpty,
        reason: 'the clock retry is not a dead session',
      );
    });

    test('enrollment and login are never signed', () async {
      await dio.post<dynamic>(
        'shared-devices/enroll',
        data: {'code': 'x'},
        options: Options(
          extra: {RequestFlags.skipAuth: true, RequestFlags.unsigned: true},
        ),
      );
      expect(
        server.requests.single.headers.containsKey('X-Signature'),
        isFalse,
      );
    });
  });
}

/// Secure storage backed by [values].
FlutterSecureStorage memoryStorage(Map<String, String> values) {
  final s = _MockStorage();
  when(() => s.read(key: any(named: 'key')))
      .thenAnswer((i) async => values[i.namedArguments[#key]]);
  when(
    () => s.write(
      key: any(named: 'key'),
      value: any(named: 'value'),
    ),
  ).thenAnswer((i) async {
    final k = i.namedArguments[#key] as String;
    final v = i.namedArguments[#value] as String?;
    if (v == null) {
      values.remove(k);
    } else {
      values[k] = v;
    }
  });
  when(() => s.delete(key: any(named: 'key')))
      .thenAnswer((i) async => values.remove(i.namedArguments[#key]));
  return s;
}

class _Online implements ConnectivityService {
  @override
  bool get isOnline => true;
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
