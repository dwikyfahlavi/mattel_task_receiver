import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../logging/app_logger.dart';
import 'app_config.dart';

/// Keys shared by Firebase Remote Config and the Firestore backup document.
/// Both must use exactly these names (see docs/MAINTENANCE.md "Remote config").
abstract final class RemoteKeys {
  /// JSON, Asia/Jakarta times: `{"S1":{"start":"07:00","end":"15:00"},…}`.
  static const shiftSchedule = 'shift_schedule';

  /// Minutes a job In Progress may delay the shift-end logout (doc 4.3).
  static const shiftEndGraceMinutes = 'shift_end_grace_minutes';

  /// `socket`, `fcm` or `both` (see `TaskDelivery`).
  static const taskDelivery = 'task_delivery';

  static String minVersion(AppKind app) => '${app.apiName}_min_version';
  static String latestVersion(AppKind app) => '${app.apiName}_latest_version';

  /// `force`, `soft` or `none`.
  static String updateMode(AppKind app) => '${app.apiName}_update_mode';
  static String apkUrl(AppKind app) => '${app.apiName}_apk_url';
  static String apkSha256(AppKind app) => '${app.apiName}_apk_sha256';
  static String releaseNotes(AppKind app) => '${app.apiName}_release_notes';
}

/// Remote configuration with compiled-in defaults (doc 14).
///
/// Values are fetched without being applied; [applyPending] activates them
/// at a safe point (app start, Home, never while a popup is visible).
abstract interface class RemoteSettings {
  String? string(String key);
  bool boolean(String key, {required bool fallback});
  int integer(String key, {required int fallback});

  /// Fetches every source; returns true when at least one answered.
  Future<bool> fetch();

  /// Activates fetched values.
  Future<void> applyPending();
}

/// One place values can come from, in priority order.
abstract class RemoteSettingsSource {
  String get name;

  Future<void> initialize();

  /// Fetches without activating. True on success.
  Future<bool> fetch();

  Future<void> activate();

  /// The active remote value, or null when this source has none for [key]
  /// (so the next source, then the default, is used).
  Object? valueOf(String key);
}

/// Remote Config, then the Firestore backup, then the defaults.
///
/// Remote Config is preferred; a key it does not serve (template not
/// published, project without it, fetch never succeeded) falls through to
/// the Firestore document `app_config/<environment>`.
class LayeredRemoteSettings implements RemoteSettings {
  LayeredRemoteSettings({
    required List<RemoteSettingsSource> sources,
    required Map<String, Object> defaults,
  }) : _sources = sources,
       _defaults = defaults;

  final List<RemoteSettingsSource> _sources;
  final Map<String, Object> _defaults;
  Future<void>? _initialized;

  Future<void> initialize() => _initialized ??= Future.wait(
    _sources.map((s) async {
      try {
        await s.initialize();
      } on Object catch (e) {
        AppLogger.warn('${s.name} init failed', error: e);
      }
    }),
  );

  Object? _value(String key) {
    for (final s in _sources) {
      final v = s.valueOf(key);
      if (v != null) return v;
    }
    return _defaults[key];
  }

  @override
  String? string(String key) {
    final v = _value(key);
    return switch (v) {
      null => null,
      String() => v,
      Map() || List() => jsonEncode(v),
      _ => '$v',
    };
  }

  @override
  bool boolean(String key, {required bool fallback}) {
    final v = _value(key);
    if (v is bool) return v;
    if (v is String) {
      final s = v.trim().toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    if (v is num) return v != 0;
    return fallback;
  }

  @override
  int integer(String key, {required int fallback}) {
    final v = _value(key);
    if (v is int) return v;
    if (v is num) return v.round();
    if (v is String) return int.tryParse(v.trim()) ?? fallback;
    return fallback;
  }

  @override
  Future<bool> fetch() async {
    await initialize();
    final results = await Future.wait(
      _sources.map((s) async {
        try {
          return await s.fetch();
        } on Object catch (e) {
          AppLogger.warn('${s.name} fetch failed', error: e);
          return false;
        }
      }),
    );
    return results.any((ok) => ok);
  }

  @override
  Future<void> applyPending() async {
    await initialize();
    for (final s in _sources) {
      try {
        await s.activate();
      } on Object catch (e) {
        AppLogger.warn('${s.name} activate failed', error: e);
      }
    }
  }
}

/// Firebase Remote Config. Only values the server actually sent count
/// (`ValueSource.valueRemote`); defaults live in [LayeredRemoteSettings].
class RemoteConfigSource implements RemoteSettingsSource {
  RemoteConfigSource(this._rc, {required this.minimumFetchInterval});

  final FirebaseRemoteConfig _rc;

  /// 12 h in prod, zero in dev (doc 14).
  final Duration minimumFetchInterval;

  StreamSubscription<RemoteConfigUpdate>? _updates;

  @override
  String get name => 'Remote Config';

  @override
  Future<void> initialize() async {
    await _rc.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: minimumFetchInterval,
      ),
    );
    // Real-time updates are fetched by the SDK; they are applied at the
    // next safe point through [activate].
    _updates = _rc.onConfigUpdated.listen(
      (_) {},
      onError: (Object e) =>
          AppLogger.warn('Remote Config stream error', error: e),
    );
  }

  @override
  Future<bool> fetch() async {
    await _rc.fetch();
    return _rc.lastFetchStatus == RemoteConfigFetchStatus.success;
  }

  @override
  Future<void> activate() => _rc.activate();

  @override
  Object? valueOf(String key) {
    try {
      final v = _rc.getValue(key);
      return v.source == ValueSource.valueRemote ? v.asString() : null;
    } on Object {
      return null;
    }
  }

  Future<void> dispose() async => _updates?.cancel();
}

/// Backup source: Firestore document `app_config/<environment>` whose fields
/// use the same names as Remote Config. Works on the free Spark plan and
/// offline from the Firestore cache.
class FirestoreSettingsSource implements RemoteSettingsSource {
  FirestoreSettingsSource(this._firestore, {required this.environment});

  final FirebaseFirestore _firestore;
  final AppEnvironment environment;

  static const collection = 'app_config';

  Map<String, Object?> _active = const {};
  Map<String, Object?>? _pending;

  DocumentReference<Map<String, dynamic>> get _doc =>
      _firestore.collection(collection).doc(environment.name);

  @override
  String get name => 'Firestore config';

  @override
  Future<void> initialize() async {
    // Last known values from the offline cache, so a cold start without
    // network still uses them.
    try {
      final cached = await _doc.get(const GetOptions(source: Source.cache));
      _active = cached.data() ?? const {};
    } on FirebaseException {
      // Nothing cached yet.
    }
  }

  @override
  Future<bool> fetch() async {
    final snap = await _doc
        .get(const GetOptions(source: Source.server))
        .timeout(const Duration(seconds: 10));
    _pending = snap.data() ?? const {};
    return true;
  }

  @override
  Future<void> activate() async {
    final next = _pending;
    if (next == null) return;
    _active = next;
    _pending = null;
  }

  @override
  Object? valueOf(String key) => _active[key];
}

/// A fixed map (tests, Firebase not configured).
class StaticSettingsSource implements RemoteSettingsSource {
  StaticSettingsSource(this.values, {this.name = 'static'});

  Map<String, Object?> values;

  @override
  final String name;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> fetch() async => true;

  @override
  Future<void> activate() async {}

  @override
  Object? valueOf(String key) => values[key];
}
