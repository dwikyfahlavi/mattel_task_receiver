import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';

import '../config/app_config.dart';
import '../config/remote_settings.dart';
import '../db/key_value_store.dart';
import '../logging/app_logger.dart';
import '../time/app_clock.dart';
import 'version_models.dart';

/// Result of the version check (doc 13.1).
enum VersionVerdict {
  /// Current >= latest, or soft update already prompted this shift.
  upToDate,

  /// Dismissible prompt.
  softUpdate,

  /// Blocking "Perbarui Aplikasi".
  forceUpdate,
}

class VersionCheckResult {
  const VersionCheckResult(this.verdict, {this.config, this.fromCache = false});

  final VersionVerdict verdict;
  final RemoteAppConfig? config;
  final bool fromCache;
}

/// Installed app version, e.g. `1.4.2+57`.
class InstalledVersion {
  const InstalledVersion(this.version, this.build);

  final Version version;
  final int build;

  static Future<InstalledVersion> read() async {
    final info = await PackageInfo.fromPlatform();
    return InstalledVersion(
      Version.parse(info.version),
      int.tryParse(info.buildNumber) ?? 0,
    );
  }
}

/// Pure comparison: semver first, then the build number when the backend
/// pins one (`1.4.0+50`). Pre-releases sort before their release.
abstract final class VersionCompare {
  static int compare(InstalledVersion installed, String required) {
    final target = Version.parse(required);
    final base = Version(
      installed.version.major,
      installed.version.minor,
      installed.version.patch,
      pre: installed.version.preRelease.isEmpty
          ? null
          : installed.version.preRelease.join('.'),
    );
    final targetBase = Version(
      target.major,
      target.minor,
      target.patch,
      pre: target.preRelease.isEmpty ? null : target.preRelease.join('.'),
    );
    final bySemver = base.compareTo(targetBase);
    if (bySemver != 0) return bySemver;
    final targetBuild = target.build.isEmpty
        ? null
        : int.tryParse(target.build.join('.'));
    if (targetBuild == null) return 0;
    return installed.build.compareTo(targetBuild);
  }

  static VersionVerdict verdict(
    InstalledVersion installed,
    RemoteAppConfig config,
  ) {
    if (compare(installed, config.minVersion) < 0) {
      return VersionVerdict.forceUpdate;
    }
    if (config.updateMode == UpdateMode.force &&
        compare(installed, config.latestVersion) < 0) {
      return VersionVerdict.forceUpdate;
    }
    if (config.updateMode == UpdateMode.soft &&
        compare(installed, config.latestVersion) < 0) {
      return VersionVerdict.softUpdate;
    }
    return VersionVerdict.upToDate;
  }
}

/// Reads the version policy from [RemoteSettings] (Remote Config, then the
/// Firestore backup, doc 13.1) and applies the offline rule: when nothing
/// could be fetched, the last applied values (cached by both SDKs) decide,
/// so a device whose last known state was non-compliant stays blocked.
class VersionGate {
  VersionGate({
    required RemoteSettings settings,
    required AppConfig config,
    required KeyValueStore cache,
    required AppClock clock,
    Future<InstalledVersion> Function()? installed,
  }) : _settings = settings,
       _config = config,
       _cache = cache,
       _clock = clock,
       _installed = installed ?? InstalledVersion.read;

  final RemoteSettings _settings;
  final AppConfig _config;
  final KeyValueStore _cache;
  final AppClock _clock;
  final Future<InstalledVersion> Function() _installed;

  static const _softShownKey = 'version.soft_prompt_day';

  DateTime? _lastCheck;

  /// Re-check on resume only after this long (doc 13.1).
  static const resumeInterval = Duration(hours: 3);

  bool get isStale =>
      _lastCheck == null ||
      _clock.serverNowUtc().difference(_lastCheck!) > resumeInterval;

  /// Fetches the settings, applies them when [applySettings] (a safe point:
  /// startup, shift end, no popup visible), then decides.
  Future<VersionCheckResult> check({bool applySettings = true}) async {
    final installed = await _installed();
    var fetched = false;
    try {
      fetched = await _settings.fetch();
      if (applySettings) await _settings.applyPending();
    } on Object catch (e) {
      AppLogger.warn('Version settings fetch failed, using cache', error: e);
    }
    if (fetched) _lastCheck = _clock.serverNowUtc();
    final remote = RemoteAppConfig.fromSettings(_settings, _config.kind);
    VersionVerdict verdict;
    try {
      verdict = VersionCompare.verdict(installed, remote);
    } on FormatException catch (e) {
      // A typo in the console must never lock the fleet out.
      AppLogger.warn('Version settings are not valid semver', error: e);
      verdict = VersionVerdict.upToDate;
    }
    if (verdict == VersionVerdict.softUpdate &&
        await _cache.read(_softShownKey) == _shiftDay()) {
      verdict = VersionVerdict.upToDate;
    }
    return VersionCheckResult(verdict, config: remote, fromCache: !fetched);
  }

  /// The soft prompt is shown at most once per shift. Shifts are day shifts at
  /// the plant, so the Jakarta calendar day identifies the shift.
  Future<void> markSoftPromptShown() =>
      _cache.write(_softShownKey, _shiftDay());

  String _shiftDay() {
    final d = _clock.jakartaNow();
    return '${d.year}-${d.month}-${d.day}';
  }
}
