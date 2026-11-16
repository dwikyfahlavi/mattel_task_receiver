import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pub_semver/pub_semver.dart';

import '../helpers.dart';

InstalledVersion v(String version, int build) =>
    InstalledVersion(Version.parse(version), build);

RemoteAppConfig cfg(String min, String latest, UpdateMode mode) =>
    RemoteAppConfig(minVersion: min, latestVersion: latest, updateMode: mode);

/// A settings source whose fetch can fail; values survive a failed fetch
/// like the SDK caches do.
class _Source extends StaticSettingsSource {
  _Source() : super({});
  bool offline = false;

  @override
  Future<bool> fetch() async => !offline;
}

void main() {
  setUpAll(() => initializeDateFormatting(JakartaTime.locale));

  group('VersionCompare (doc 13.1)', () {
    test('below min_version forces the update', () {
      expect(
        VersionCompare.verdict(
          v('1.3.9', 50),
          cfg('1.4.0', '1.5.0', UpdateMode.soft),
        ),
        VersionVerdict.forceUpdate,
      );
    });

    test('below latest with soft mode prompts', () {
      expect(
        VersionCompare.verdict(
          v('1.4.2', 57),
          cfg('1.4.0', '1.5.0', UpdateMode.soft),
        ),
        VersionVerdict.softUpdate,
      );
    });

    test('mode none or up to date continues', () {
      expect(
        VersionCompare.verdict(
          v('1.4.2', 57),
          cfg('1.4.0', '1.5.0', UpdateMode.none),
        ),
        VersionVerdict.upToDate,
      );
      expect(
        VersionCompare.verdict(
          v('1.5.0', 60),
          cfg('1.4.0', '1.5.0', UpdateMode.force),
        ),
        VersionVerdict.upToDate,
      );
    });

    test('build number decides when a build is pinned', () {
      expect(VersionCompare.compare(v('1.4.0', 49), '1.4.0+50'), lessThan(0));
      expect(VersionCompare.compare(v('1.4.0', 50), '1.4.0+50'), 0);
      expect(VersionCompare.compare(v('1.4.0', 1), '1.4.0'), 0);
    });
  });

  group('RemoteAppConfig from settings', () {
    test('reads the per-app keys', () {
      final s = staticSettings({
        'watch_min_version': '1.4.0',
        'watch_latest_version': '1.5.0',
        'watch_update_mode': 'SOFT',
        'watch_apk_url': 'https://x/app.apk',
        'watch_apk_sha256': 'abc',
        'mobile_min_version': '9.9.9',
      });
      final c = RemoteAppConfig.fromSettings(s, AppKind.watch);
      expect(c.minVersion, '1.4.0');
      expect(c.latestVersion, '1.5.0');
      expect(c.updateMode, UpdateMode.soft);
      expect(c.apk?.url, 'https://x/app.apk');
    });

    test('missing keys mean no requirement', () {
      final c = RemoteAppConfig.fromSettings(staticSettings(), AppKind.mobile);
      expect(c.minVersion, RemoteAppConfig.noVersion);
      expect(c.updateMode, UpdateMode.none);
      expect(c.apk, isNull);
    });
  });

  group('VersionGate', () {
    late AppDatabase db;
    late _Source source;
    late VersionGate gate;

    setUp(() {
      db = memoryDatabase();
      source = _Source();
      final config = AppConfig.fromValues(
        environment: AppEnvironment.dev,
        kind: AppKind.watch,
        rawBaseUrl: 'https://api.test',
        rawPins: '',
        rawFake: '',
        rawKeys: '',
        isReleaseBuild: false,
      );
      gate = VersionGate(
        settings: LayeredRemoteSettings(sources: [source], defaults: const {}),
        config: config,
        cache: KeyValueStore(db),
        clock: FakeAppClock(serverNowUtc: DateTime.utc(2026, 10, 27, 2)),
        installed: () async => v('1.4.2', 57),
      );
    });
    tearDown(() => db.close());

    test('offline with compliant cached values continues', () async {
      source.values = {'watch_min_version': '1.4.0'};
      expect((await gate.check()).verdict, VersionVerdict.upToDate);
      source.offline = true;
      final r = await gate.check();
      expect(r.verdict, VersionVerdict.upToDate);
      expect(r.fromCache, isTrue);
    });

    test('offline with non-compliant cached values stays blocked', () async {
      source.values = {'watch_min_version': '1.5.0'};
      expect((await gate.check()).verdict, VersionVerdict.forceUpdate);
      source.offline = true;
      expect((await gate.check()).verdict, VersionVerdict.forceUpdate);
    });

    test('soft prompt is shown at most once per shift day', () async {
      source.values = {
        'watch_latest_version': '1.5.0',
        'watch_update_mode': 'soft',
      };
      expect((await gate.check()).verdict, VersionVerdict.softUpdate);
      await gate.markSoftPromptShown();
      expect((await gate.check()).verdict, VersionVerdict.upToDate);
    });

    test('a malformed version never locks the fleet out', () async {
      source.values = {'watch_min_version': 'one point five'};
      expect((await gate.check()).verdict, VersionVerdict.upToDate);
    });
  });
}
