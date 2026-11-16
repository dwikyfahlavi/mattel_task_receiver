import 'dart:async';

import 'package:core/core.dart';

import 'auth_api.dart';
import 'auth_dtos.dart';

/// Sign-in, watch enrollment and pairing, session restore and end, profile,
/// and the phone's watch list.
class AuthRepository {
  AuthRepository({
    required AuthApi api,
    required ErrorMapper errors,
    required TokenStore tokens,
    required SecureStore secure,
    required PushService push,
    required LocalSessionWiper wiper,
    required AppConfig config,
    required AppClock clock,
    required RemoteSettings settings,
    required DeviceIdentity identity,
    required RequestSigner signer,
  }) : _api = api,
       _errors = errors,
       _tokens = tokens,
       _secure = secure,
       _push = push,
       _wiper = wiper,
       _config = config,
       _clock = clock,
       _settings = settings,
       _identity = identity,
       _signer = signer;

  final AuthApi _api;
  final ErrorMapper _errors;
  final TokenStore _tokens;
  final SecureStore _secure;
  final PushService _push;
  final LocalSessionWiper _wiper;
  final AppConfig _config;
  final AppClock _clock;
  final RemoteSettings _settings;
  final DeviceIdentity _identity;
  final RequestSigner _signer;

  StreamSubscription<String>? _tokenRefreshSub;

  TaskDelivery get _delivery => TaskDelivery.fromSettings(_settings);

  // --------------------------------------------------------------- session

  /// Restores a persisted session (doc 8.1). Returns null when nothing is
  /// stored or the user did not choose "Tetap masuk". The shift cutoff is
  /// recomputed with the current schedule.
  Future<SessionInfo?> restore() async {
    final tokens = await _tokens.restore();
    if (tokens == null) return null;
    final info = await _secure.readSession();
    if (info == null || (_config.isWatch && !await _identity.isEnrolled())) {
      await _tokens.clear();
      return null;
    }
    final refreshed = info.copyWith(
      policy: _policyFor(info.user, info.startedAt, tokens.expiresAt),
    );
    await _secure.writeSession(refreshed);
    return refreshed;
  }

  Future<Result<SessionInfo>> login({
    required String kpk,
    required String password,
    required bool remember,
  }) => _errors.guard(() async {
    final grant = await _api.login(
      LoginRequest(kpk: kpk.trim(), password: password.trim()),
    );
    return _establish(grant, persist: remember);
  });

  /// Confirms the session over HTTP (a `401` ends it via the interceptor).
  Future<Result<void>> verifySession() => _errors.guard(() async => _api.me());

  Future<SessionInfo> _establish(
    SessionGrantDto grant, {
    required bool persist,
  }) async {
    final startedAt = _clock.serverNowUtc();
    final info = SessionInfo(
      user: grant.technician,
      startedAt: startedAt,
      policy: _policyFor(grant.technician, startedAt, grant.expiresAt),
    );
    await _tokens.save(grant.tokens, persist: persist);
    await _secure.writeSession(info);
    unawaited(registerPushToken());
    return info;
  }

  SessionPolicy _policyFor(
    UserProfile user,
    DateTime? startedAt,
    DateTime? tokenExpiresAt,
  ) => SessionPolicyFactory.fromSettings(
    user: user,
    startedAtUtc: startedAt ?? _clock.serverNowUtc(),
    settings: _settings,
    tokenExpiresAtUtc: tokenExpiresAt,
  );

  /// Ends the session: server half best effort, then the local wipe, which
  /// always runs (doc 8.1 "Wipe on session end").
  ///
  /// * Watch: `POST /technicians/me/unpair` (checks out and ends the watch
  ///   session), then back to the pairing QR with the device key.
  /// * Phone: `POST /technician-auth/logout`.
  Future<void> endSession({bool callServer = true}) async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    if (callServer && _tokens.hasSession) {
      if (_delivery.usesPush) await _unregisterPushToken();
      if (_config.isWatch) {
        await _errors.guard(_api.unpairSelf);
      } else {
        await _errors.guard(_api.logout);
      }
    }
    await _wiper.wipe();
  }

  // ------------------------------------------------------------------ push

  /// Registers the FCM token with the backend, only when the delivery mode
  /// uses push (the endpoint is proposed, D-21).
  Future<void> registerPushToken() async {
    if (!_delivery.usesPush || !_tokens.hasSession) return;
    final token = await _push.token();
    if (token != null) await _sendPushToken(token);
    _tokenRefreshSub ??= _push.tokenRefreshes.listen(
      (t) => unawaited(_sendPushToken(t)),
    );
  }

  Future<void> _sendPushToken(String token) async {
    final r = await _errors.guard(
      () => _api.registerFcmToken({
        'fcm_token': token,
        'device_id': ?_identity.deviceId,
      }),
    );
    if (!r.isOk) AppLogger.debug('FCM token not registered');
  }

  Future<void> _unregisterPushToken() async {
    final token = await _push.token();
    if (token == null) return;
    await _errors.guard(() => _api.unregisterFcmToken({'fcm_token': token}));
  }

  // --------------------------------------------------------------- profile

  Future<Result<ProfileDto>> profile() => _errors.guard(_api.profile);

  // ------------------------------------------------------ phone: pairing

  Future<Result<PairingPreviewDto>> previewPairing(String code) =>
      _errors.guard(() => _api.previewPairing(code));

  Future<Result<DeviceDto>> approvePairing(String code) => _errors.guard(
    () async =>
        (await _api.approvePairing(ApprovePairingRequest(code: code))).device,
  );

  Future<Result<List<PairedWatchDto>>> pairedWatches() =>
      _errors.guard(_api.devices);

  Future<Result<bool>> unpairWatch(String sessionId) => _errors.guard(
    () async => (await _api.unpairDevice(sessionId)).checkedOut,
  );

  // ------------------------------------------------------ watch: device

  Future<bool> isEnrolled() => _identity.isEnrolled();

  /// Creates the key pair (once) and enrolls with the admin's code.
  Future<Result<DeviceDto>> enroll(String code) => _errors.guard(() async {
    final proof = await _signer.enrollmentProof(code);
    final r = await _api.enroll(
      EnrollRequest(
        code: code,
        publicKey: proof.publicKey,
        signature: proof.signature,
      ),
    );
    final id = r.device.id;
    if (id == null || id.isEmpty) {
      throw const FormatException('Enrollment answer without device id');
    }
    await _identity.saveEnrollment(id);
    return r.device;
  });

  /// The admin reset or disabled the watch: enroll again later.
  Future<void> forgetEnrollment() => _identity.forget();

  Future<Result<PairingDto>> createPairing() =>
      _errors.guard(_api.createPairing);

  Future<Result<PairingStatus>> pairingStatus(String pairingId) =>
      _errors.guard(() async => (await _api.pairing(pairingId)).status);

  /// Exchanges an approved pairing for the technician token. A watch
  /// session is always persisted until the shift ends.
  Future<Result<SessionInfo>> exchangePairing(String pairingId) =>
      _errors.guard(() async {
        final grant = await _api.exchange(pairingId);
        return _establish(grant, persist: true);
      });
}
