import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:device_bridge/device_bridge.dart';

import '../storage/secure_store.dart';
import '../time/app_clock.dart';

/// The watch's Keystore key pair (backend guide, part 2 step 1).
abstract class DeviceKeyStore {
  /// Creates the key pair if missing (never on each launch: alias check).
  Future<DeviceKeyInfo> ensure();

  /// The existing key or null.
  Future<DeviceKeyInfo?> describe();

  /// Base64 SHA256withECDSA signature of [text].
  Future<String> sign(String text);

  Future<void> delete();
}

class PlatformDeviceKeyStore implements DeviceKeyStore {
  const PlatformDeviceKeyStore([this._bridge = const DeviceBridge()]);

  final DeviceBridge _bridge;

  @override
  Future<DeviceKeyInfo> ensure() => _bridge.ensureDeviceKey();

  @override
  Future<DeviceKeyInfo?> describe() => _bridge.describeDeviceKey();

  @override
  Future<String> sign(String text) => _bridge.signWithDeviceKey(text);

  @override
  Future<void> delete() => _bridge.deleteDeviceKey();
}

/// Dev fake backend and tests: a fixed "public key" and a digest instead of
/// a real signature. The fake backend does not verify signatures.
class FakeDeviceKeyStore implements DeviceKeyStore {
  FakeDeviceKeyStore();

  static final _publicKey = base64Encode(utf8.encode('fake-device-public-key'));
  bool _exists = false;

  @override
  Future<DeviceKeyInfo> ensure() async {
    _exists = true;
    return DeviceKeyInfo(publicKey: _publicKey, hardwareBacked: false);
  }

  @override
  Future<DeviceKeyInfo?> describe() async => _exists
      ? DeviceKeyInfo(publicKey: _publicKey, hardwareBacked: false)
      : null;

  @override
  Future<String> sign(String text) async =>
      base64Encode(sha256.convert(utf8.encode(text)).bytes);

  @override
  Future<void> delete() async => _exists = false;
}

/// The enrolled watch: its backend `device.id` plus the key pair.
///
/// The device id survives every session wipe (it identifies the device, not
/// the technician) and is only forgotten when the watch must enroll again.
class DeviceIdentity {
  DeviceIdentity({required SecureStore secure, required DeviceKeyStore keys})
    : _secure = secure,
      _keys = keys;

  final SecureStore _secure;
  final DeviceKeyStore _keys;

  String? _deviceId;
  bool _loaded = false;

  DeviceKeyStore get keys => _keys;

  /// Cached after the first [load].
  String? get deviceId => _deviceId;

  Future<String?> load() async {
    if (_loaded) return _deviceId;
    final stored = await _secure.read(SecureKeys.enrolledDeviceId);
    // A device id without a key (app data cleared, reinstall) is useless.
    final key = stored == null ? null : await _keys.describe();
    _deviceId = key == null ? null : stored;
    if (stored != null && key == null) {
      await _secure.write(SecureKeys.enrolledDeviceId, null);
    }
    _loaded = true;
    return _deviceId;
  }

  Future<bool> isEnrolled() async => await load() != null;

  Future<void> saveEnrollment(String deviceId) async {
    _deviceId = deviceId;
    _loaded = true;
    await _secure.write(SecureKeys.enrolledDeviceId, deviceId);
  }

  /// The admin reset or disabled the watch for good: enroll again with a new
  /// key pair.
  Future<void> forget() async {
    _deviceId = null;
    _loaded = true;
    await _secure.write(SecureKeys.enrolledDeviceId, null);
    await _keys.delete();
  }
}

/// Builds the signed texts and headers of the watch protocol
/// (backend guide, part 2 steps 2, 3 and 5). The text layouts are exact:
/// one changed character gives a 401.
class RequestSigner {
  RequestSigner({
    required DeviceIdentity identity,
    required AppClock clock,
    Random? random,
  }) : _identity = identity,
       _clock = clock,
       _random = random ?? Random.secure();

  final DeviceIdentity _identity;
  final AppClock _clock;
  final Random _random;

  static const version = 'v1';
  static const socketMethod = 'SOCKET';
  static const socketPath = '/technician';

  /// SHA-256 of the empty string, for requests without a body.
  static final emptyBodyHash = sha256Hex(const []);

  static String sha256Hex(List<int> bytes) => sha256.convert(bytes).toString();

  /// Lowercase hex SHA-256 of the DER public key bytes.
  static String fingerprint(String publicKeyBase64) =>
      sha256Hex(base64Decode(publicKeyBase64));

  /// `enroll\nv1\n<code>\n<fingerprint>`
  static String enrollText({
    required String code,
    required String fingerprint,
  }) => ['enroll', version, code, fingerprint].join('\n');

  /// `request\nv1\nMETHOD\npath?query\ntimestamp\nnonce\nbodyHash\nsessionId`
  static String requestText({
    required String method,
    required String pathAndQuery,
    required String timestamp,
    required String nonce,
    required String bodySha256,
    String? sessionId,
  }) => [
    'request',
    version,
    method.toUpperCase(),
    pathAndQuery,
    timestamp,
    nonce,
    bodySha256,
    sessionId ?? '',
  ].join('\n');

  /// Path and query exactly as sent (`/technicians/me/work-orders?page=2`).
  static String pathAndQueryOf(Uri uri) {
    final path = uri.path.isEmpty ? '/' : uri.path;
    return uri.hasQuery && uri.query.isNotEmpty ? '$path?${uri.query}' : path;
  }

  /// 16 random bytes, base64url without padding (22 chars of A-Za-z0-9_-).
  String newNonce() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Unix seconds on the corrected server clock.
  String timestamp() =>
      '${_clock.serverNowUtc().millisecondsSinceEpoch ~/ 1000}';

  /// The four `X-` headers for one request. Fresh nonce and timestamp every
  /// call, retries included (a signature works once).
  Future<Map<String, String>> headersFor({
    required String method,
    required Uri uri,
    required List<int> body,
    String? sessionId,
  }) async {
    final deviceId = await _identity.load();
    if (deviceId == null) {
      throw StateError('The watch is not enrolled.');
    }
    final ts = timestamp();
    final nonce = newNonce();
    final text = requestText(
      method: method,
      pathAndQuery: pathAndQueryOf(uri),
      timestamp: ts,
      nonce: nonce,
      bodySha256: body.isEmpty ? emptyBodyHash : sha256Hex(body),
      sessionId: sessionId,
    );
    return {
      'X-Device-Id': deviceId,
      'X-Timestamp': ts,
      'X-Nonce': nonce,
      'X-Signature': await _identity.keys.sign(text),
    };
  }

  /// Signed Socket.IO handshake `auth` (single use: one per connection).
  Future<Map<String, String>> socketAuth({
    String? sessionId,
    String? token,
  }) async {
    final deviceId = await _identity.load();
    if (deviceId == null) {
      throw StateError('The watch is not enrolled.');
    }
    final ts = timestamp();
    final nonce = newNonce();
    final text = requestText(
      method: socketMethod,
      pathAndQuery: socketPath,
      timestamp: ts,
      nonce: nonce,
      bodySha256: emptyBodyHash,
      sessionId: sessionId,
    );
    return {
      'device_id': deviceId,
      'timestamp': ts,
      'nonce': nonce,
      'signature': await _identity.keys.sign(text),
      'token': ?token,
    };
  }

  /// Enrollment body: public key and the proof of possession.
  Future<({String publicKey, String signature})> enrollmentProof(
    String code,
  ) async {
    final key = await _identity.keys.ensure();
    final text = enrollText(
      code: code,
      fingerprint: fingerprint(key.publicKey),
    );
    return (
      publicKey: key.publicKey,
      signature: await _identity.keys.sign(text),
    );
  }
}
