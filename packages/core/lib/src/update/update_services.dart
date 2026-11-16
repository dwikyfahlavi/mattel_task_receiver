import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_bridge/device_bridge.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

import '../config/app_config.dart';
import '../error/failure.dart';
import '../error/result.dart';
import '../logging/app_logger.dart';
import '../version/version_models.dart';

/// Shorebird Dart patches (doc 13.2). Patches are downloaded in the
/// background and applied on the next process start. [restartIfReady] is
/// only called at a safe point (after shift-end logout, nothing Assigned or
/// In Progress). Never restart during an assignment.
class PatchUpdater {
  PatchUpdater({
    required AppConfig config,
    ShorebirdUpdater? updater,
    DeviceBridge bridge = const DeviceBridge(),
  }) : _config = config,
       _updater = updater ?? ShorebirdUpdater(),
       _bridge = bridge;

  final AppConfig _config;
  final ShorebirdUpdater _updater;
  final DeviceBridge _bridge;
  bool _restartRequired = false;

  /// Staging builds follow the `staging` track so patches can be verified on
  /// a small group before `stable` (doc 19.4).
  UpdateTrack get _track =>
      _config.isProd ? UpdateTrack.stable : UpdateTrack.staging;

  bool get isAvailable => _updater.isAvailable;
  bool get restartRequired => _restartRequired;

  Future<void> checkAndDownload() async {
    if (!_updater.isAvailable) return; // not a Shorebird release build
    try {
      final status = await _updater.checkForUpdate(track: _track);
      if (status == UpdateStatus.outdated) {
        await _updater.update(track: _track);
        _restartRequired = true;
      } else if (status == UpdateStatus.restartRequired) {
        _restartRequired = true;
      }
    } on UpdateException catch (e) {
      AppLogger.warn('Shorebird update failed: ${e.reason}', error: e);
    } on Object catch (e) {
      AppLogger.warn('Shorebird check failed', error: e);
    }
  }

  /// Restarts only if a patch is waiting. Caller guarantees a safe point.
  Future<void> restartIfReady() async {
    if (!_restartRequired) return;
    AppLogger.info('Restarting to apply a downloaded patch');
    await _bridge.restartApp();
  }
}

/// In-app APK fallback (doc 13.2, flag `in_app_apk_update`): download,
/// verify SHA-256, then hand over to the system installer.
class ApkUpdater {
  ApkUpdater({Dio? dio, DeviceBridge bridge = const DeviceBridge()})
    : _dio = dio ?? Dio(),
      _bridge = bridge;

  final Dio _dio;
  final DeviceBridge _bridge;

  Future<Result<File>> download(
    ApkInfo apk, {
    void Function(double progress)? onProgress,
  }) async {
    final uri = Uri.tryParse(apk.url);
    if (uri == null || uri.scheme != 'https') {
      return const Result.err(UnexpectedFailure('APK url must be https'));
    }
    final dir = Directory(
      '${(await getTemporaryDirectory()).path}/apk_updates',
    );
    await dir.create(recursive: true);
    final file = File('${dir.path}/update.apk');
    try {
      await _dio.downloadUri(
        uri,
        file.path,
        onReceiveProgress: (received, total) {
          if (total > 0) onProgress?.call(received / total);
        },
      );
      final digest = await sha256.bind(file.openRead()).first;
      if (digest.toString().toLowerCase() != apk.sha256.toLowerCase()) {
        await file.delete();
        return const Result.err(UnexpectedFailure('APK checksum mismatch'));
      }
      return Result.ok(file);
    } on DioException {
      return const Result.err(NoConnectionFailure());
    } on FileSystemException catch (e) {
      return Result.err(UnexpectedFailure(e));
    }
  }

  Future<bool> canInstall() => _bridge.canRequestPackageInstalls();
  Future<void> openInstallPermissionSettings() =>
      _bridge.openInstallUnknownAppsSettings();
  Future<void> install(File apk) => _bridge.installApk(apk.path);
}
