import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Android checks and actions not covered by the regular plugins.
///
/// On other platforms every check returns the "nothing to fix" value and every
/// action is a no-op, so callers do not need platform checks of their own.
class DeviceBridge {
  const DeviceBridge();

  @visibleForTesting
  static const MethodChannel channel = MethodChannel(
    'com.mattel/device_bridge',
  );

  bool get _isAndroid => !kIsWeb && Platform.isAndroid;

  /// Android 14+ restricts full-screen intents for non-calling apps.
  Future<bool> canUseFullScreenIntent() async {
    if (!_isAndroid) return true;
    return await channel.invokeMethod<bool>('canUseFullScreenIntent') ?? true;
  }

  Future<bool> openFullScreenIntentSettings() async {
    if (!_isAndroid) return false;
    return await channel.invokeMethod<bool>('openFullScreenIntentSettings') ??
        false;
  }

  /// True when app notifications are on and [channelId] exists and is not muted.
  Future<bool> isNotificationChannelEnabled(String channelId) async {
    if (!_isAndroid) return true;
    return await channel.invokeMethod<bool>('isNotificationChannelEnabled', {
          'channelId': channelId,
        }) ??
        false;
  }

  Future<bool> canRequestPackageInstalls() async {
    if (!_isAndroid) return false;
    return await channel.invokeMethod<bool>('canRequestPackageInstalls') ??
        false;
  }

  Future<bool> openInstallUnknownAppsSettings() async {
    if (!_isAndroid) return false;
    return await channel.invokeMethod<bool>('openInstallUnknownAppsSettings') ??
        false;
  }

  /// Opens the system installer for an APK stored under `<cache>/apk_updates/`.
  Future<void> installApk(String path) async {
    if (!_isAndroid) return;
    await channel.invokeMethod<bool>('installApk', {'path': path});
  }

  /// Restarts the process. Call only at a safe point (no task Assigned or In Progress).
  Future<void> restartApp() async {
    if (!_isAndroid) return;
    await channel.invokeMethod<bool>('restartApp');
  }

  // ------------------------------------------------------ device key (watch)

  /// Creates the EC P-256 Keystore key pair if missing and returns its public
  /// key. Throws [UnsupportedError] off Android.
  Future<DeviceKeyInfo> ensureDeviceKey() async {
    _requireAndroid();
    final raw = await channel.invokeMapMethod<String, Object?>(
      'deviceKeyEnsure',
    );
    return DeviceKeyInfo.fromMap(raw!);
  }

  /// The existing key, or null when no key pair was created yet.
  Future<DeviceKeyInfo?> describeDeviceKey() async {
    if (!_isAndroid) return null;
    final raw = await channel.invokeMapMethod<String, Object?>(
      'deviceKeyDescribe',
    );
    if (raw == null || raw.isEmpty) return null;
    return DeviceKeyInfo.fromMap(raw);
  }

  /// SHA256withECDSA signature of [text] (UTF-8), base64 without line breaks.
  Future<String> signWithDeviceKey(String text) async {
    _requireAndroid();
    final signature = await channel.invokeMethod<String>('deviceKeySign', {
      'text': text,
    });
    return signature!;
  }

  Future<void> deleteDeviceKey() async {
    if (!_isAndroid) return;
    await channel.invokeMethod<bool>('deviceKeyDelete');
  }

  // --------------------------------------------------------- keep-alive

  /// Starts the foreground service that keeps the work-order socket alive.
  Future<void> startKeepAlive({
    required String title,
    required String body,
  }) async {
    if (!_isAndroid) return;
    await channel.invokeMethod<bool>('keepAliveStart', {
      'title': title,
      'body': body,
    });
  }

  Future<void> stopKeepAlive() async {
    if (!_isAndroid) return;
    await channel.invokeMethod<bool>('keepAliveStop');
  }

  // ------------------------------------------------------ hardware scanner

  @visibleForTesting
  static const EventChannel scannerChannel = EventChannel(
    'com.mattel/device_bridge/scanner',
  );

  /// Codes read by the built-in scanner of Newland devices (broadcast mode).
  /// Empty on other platforms.
  Stream<String> hardwareScans() {
    if (!_isAndroid) return const Stream.empty();
    return scannerChannel.receiveBroadcastStream().map((e) => '$e');
  }

  void _requireAndroid() {
    if (!_isAndroid) {
      throw UnsupportedError('The device key is only available on Android.');
    }
  }
}

/// Public part of the device key pair.
@immutable
class DeviceKeyInfo {
  const DeviceKeyInfo({required this.publicKey, required this.hardwareBacked});

  factory DeviceKeyInfo.fromMap(Map<String, Object?> map) => DeviceKeyInfo(
    publicKey: map['publicKey']! as String,
    hardwareBacked: map['hardwareBacked'] == true,
  );

  /// Base64 of the X.509 SubjectPublicKeyInfo DER bytes, no line breaks.
  final String publicKey;

  /// Key material inside a TEE or StrongBox.
  final bool hardwareBacked;
}
