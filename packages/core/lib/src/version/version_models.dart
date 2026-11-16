import 'package:meta/meta.dart';

import '../config/app_config.dart';
import '../config/remote_settings.dart';

enum UpdateMode {
  force,
  soft,
  none;

  static UpdateMode parse(String? raw) => switch (raw?.trim().toLowerCase()) {
    'force' => force,
    'soft' => soft,
    _ => none,
  };
}

@immutable
class ApkInfo {
  const ApkInfo({required this.url, required this.sha256, this.releaseNotes});

  final String url;
  final String sha256;
  final String? releaseNotes;
}

/// Version policy of one app (doc 13.1), read from Remote Config with the
/// Firestore backup (`<app>_min_version`, `<app>_latest_version`, …).
@immutable
class RemoteAppConfig {
  const RemoteAppConfig({
    required this.minVersion,
    required this.latestVersion,
    this.updateMode = UpdateMode.none,
    this.apk,
  });

  /// Missing values mean "no requirement" (`0.0.0`).
  factory RemoteAppConfig.fromSettings(RemoteSettings settings, AppKind app) {
    String read(String key) => (settings.string(key) ?? '').trim();
    final url = read(RemoteKeys.apkUrl(app));
    final sha = read(RemoteKeys.apkSha256(app));
    final notes = read(RemoteKeys.releaseNotes(app));
    final min = read(RemoteKeys.minVersion(app));
    final latest = read(RemoteKeys.latestVersion(app));
    return RemoteAppConfig(
      minVersion: min.isEmpty ? noVersion : min,
      latestVersion: latest.isEmpty ? noVersion : latest,
      updateMode: UpdateMode.parse(settings.string(RemoteKeys.updateMode(app))),
      apk: url.isEmpty || sha.isEmpty
          ? null
          : ApkInfo(
              url: url,
              sha256: sha,
              releaseNotes: notes.isEmpty ? null : notes,
            ),
    );
  }

  static const noVersion = '0.0.0';

  final String minVersion;
  final String latestVersion;
  final UpdateMode updateMode;
  final ApkInfo? apk;
}
