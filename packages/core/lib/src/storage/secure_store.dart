import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../logging/app_logger.dart';
import '../session/session_models.dart';

/// Keys in secure storage: the token, the session info and the watch's
/// enrolled device id (doc 5: "Secure storage: tokens only").
abstract final class SecureKeys {
  /// JSON of [AuthTokens].
  static const accessToken = 'auth.access_token';
  static const remember = 'auth.remember';
  static const session = 'auth.session';

  /// Watch only: `device.id` returned by `POST /shared-devices/enroll`.
  /// Survives every session wipe; it belongs to the device, not the user.
  static const enrolledDeviceId = 'device.enrolled_id';
}

/// Thin wrapper over `flutter_secure_storage` that never throws.
///
/// If the Keystore was reset and values cannot be decrypted, everything is
/// wiped and `null` is returned so the app shows the login screen instead of
/// looping on errors (doc 8.1).
class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(),
            iOptions: IOSOptions(
              accessibility: KeychainAccessibility.first_unlock_this_device,
            ),
          );

  final FlutterSecureStorage _storage;

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException catch (e) {
      AppLogger.warn('Secure storage unreadable, wiping', error: e);
      await _wipeAllUnsafe();
      return null;
    }
  }

  Future<void> write(String key, String? value) async {
    try {
      if (value == null) {
        await _storage.delete(key: key);
      } else {
        await _storage.write(key: key, value: value);
      }
    } on PlatformException catch (e) {
      AppLogger.warn('Secure storage write failed', error: e);
    }
  }

  /// Deletes everything except the enrolled device id.
  Future<void> wipeSession() async {
    for (final key in const [
      SecureKeys.accessToken,
      SecureKeys.remember,
      SecureKeys.session,
    ]) {
      await write(key, null);
    }
  }

  Future<void> _wipeAllUnsafe() async {
    try {
      await _storage.deleteAll();
    } on PlatformException catch (e) {
      AppLogger.warn('Secure storage wipe failed', error: e);
    }
  }

  Future<SessionInfo?> readSession() async {
    final raw = await read(SecureKeys.session);
    if (raw == null) return null;
    try {
      return SessionInfo.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object catch (e) {
      AppLogger.warn('Stored session is corrupt, dropping it', error: e);
      await write(SecureKeys.session, null);
      return null;
    }
  }

  Future<void> writeSession(SessionInfo? session) => write(
    SecureKeys.session,
    session == null ? null : jsonEncode(session.toJson()),
  );
}
