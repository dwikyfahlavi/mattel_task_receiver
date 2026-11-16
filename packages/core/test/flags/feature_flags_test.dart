import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// Activation is explicit, like Remote Config.
class _PendingSource implements RemoteSettingsSource {
  Map<String, Object?> active = {};
  Map<String, Object?> fetched = {};
  bool fails = false;
  int activations = 0;

  @override
  String get name => 'pending';

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> fetch() async {
    if (fails) throw Exception('offline');
    return true;
  }

  @override
  Future<void> activate() async {
    activations++;
    active = fetched;
  }

  @override
  Object? valueOf(String key) => active[key];
}

void main() {
  test('compiled-in defaults are all off (doc 14)', () {
    final flags = DefaultFeatureFlags();
    for (final flag in FeatureFlag.values) {
      expect(flags.isEnabled(flag), isFalse, reason: flag.key);
    }
  });

  test('remote value is used when available', () {
    final flags = RemoteFeatureFlags(
      staticSettings({'vendor_technician_login': 'true'}),
    );
    expect(flags.isEnabled(FeatureFlag.vendorTechnicianLogin), isTrue);
  });

  test('falls back to the default when no source has a value', () {
    final flags = RemoteFeatureFlags(staticSettings());
    expect(flags.isEnabled(FeatureFlag.vendorTechnicianLogin), isFalse);
  });

  group('LayeredRemoteSettings (D-23)', () {
    test('Remote Config first, then the Firestore backup, then defaults', () {
      final s = LayeredRemoteSettings(
        sources: [
          StaticSettingsSource({'a': 'rc'}, name: 'rc'),
          StaticSettingsSource({'a': 'fs', 'b': 'fs'}, name: 'fs'),
        ],
        defaults: const {'a': 'def', 'b': 'def', 'c': 'def'},
      );
      expect(s.string('a'), 'rc');
      expect(s.string('b'), 'fs');
      expect(s.string('c'), 'def');
      expect(s.string('missing'), isNull);
    });

    test('typed reads accept strings, numbers and booleans', () {
      final s = staticSettings({
        'flag': true,
        'flag_s': 'FALSE',
        'n': 12.6,
        'n_s': ' 7 ',
        'json': {'k': 1},
      });
      expect(s.boolean('flag', fallback: false), isTrue);
      expect(s.boolean('flag_s', fallback: true), isFalse);
      expect(s.integer('n', fallback: 0), 13);
      expect(s.integer('n_s', fallback: 0), 7);
      expect(s.integer('missing', fallback: 5), 5);
      expect(s.string('json'), '{"k":1}');
    });

    test('fetched values are applied only at a safe point', () async {
      final source = _PendingSource()..fetched = {'auto_logout_mobile': true};
      final flags = RemoteFeatureFlags(
        LayeredRemoteSettings(sources: [source], defaults: const {}),
      );
      await flags.fetch();
      expect(flags.isEnabled(FeatureFlag.autoLogoutMobile), isFalse);
      await flags.applyPending();
      expect(flags.isEnabled(FeatureFlag.autoLogoutMobile), isTrue);
    });

    test('one failing source does not stop the others', () async {
      final failing = _PendingSource()..fails = true;
      final s = LayeredRemoteSettings(
        sources: [failing, StaticSettingsSource({})],
        defaults: const {},
      );
      expect(await s.fetch(), isTrue);
    });
  });

  test('task delivery defaults to the socket', () {
    expect(TaskDelivery.fromSettings(staticSettings()), TaskDelivery.socket);
    expect(
      TaskDelivery.fromSettings(staticSettings({'task_delivery': 'BOTH'})),
      TaskDelivery.both,
    );
    expect(TaskDelivery.parse('nonsense'), TaskDelivery.socket);
  });
}
