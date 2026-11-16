import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show appFlavor;

/// Build environment. Selected by the entry point (`main_<env>.dart`) and the
/// Android flavor of the same name.
enum AppEnvironment {
  dev,
  staging,
  prod;

  /// Resolves the environment from the Android flavor. Works in any isolate,
  /// including the FCM background isolate that has no access to `main_<env>.dart`.
  static AppEnvironment fromFlavor(String? flavor) => switch (flavor) {
    'prod' => AppEnvironment.prod,
    'staging' => AppEnvironment.staging,
    _ => AppEnvironment.dev,
  };

  static AppEnvironment get current => fromFlavor(appFlavor);
}

/// Which app is running. The watch and mobile apps share packages but differ
/// in session policy (watch always logs out at shift end) and screens.
enum AppKind {
  watch('watch'),
  mobile('mobile');

  const AppKind(this.apiName);

  /// Prefix of the per-app Remote Config / Firestore keys (`watch_min_version`).
  final String apiName;
}

/// Immutable runtime configuration. Values come from compile-time
/// `--dart-define`s so no secrets or URLs are hard-coded per developer.
///
/// | define            | meaning                                                         |
/// | ----------------- | --------------------------------------------------------------- |
/// | API_BASE_URL      | Backend base URL. Required for staging and prod; dev defaults to the dev backend. |
/// | CERT_PINS         | Comma-separated base64 SHA-256 SPKI pins. At least 2 in prod.   |
/// | USE_FAKE_BACKEND  | `true` runs the in-memory fake backend (dev only).              |
/// | WATCH_ACCEPT_KEYCODES | Android key codes of the WD1 II side button (watch only).   |
@immutable
class AppConfig {
  const AppConfig({
    required this.environment,
    required this.kind,
    required this.apiBaseUrl,
    required this.certificatePins,
    required this.useFakeBackend,
    required this.watchAcceptKeyCodes,
  });

  /// Builds the config from `--dart-define` values and validates it.
  ///
  /// Throws [StateError] for unsafe combinations (fake backend outside dev,
  /// missing base URL outside dev, fewer than two pins in a prod release).
  factory AppConfig.resolve({
    required AppEnvironment environment,
    required AppKind kind,
    bool isReleaseBuild = kReleaseMode,
  }) {
    const rawBaseUrl = String.fromEnvironment('API_BASE_URL');
    const rawPins = String.fromEnvironment('CERT_PINS');
    const rawFake = String.fromEnvironment('USE_FAKE_BACKEND');
    const rawKeys = String.fromEnvironment(
      'WATCH_ACCEPT_KEYCODES',
      defaultValue: defaultWatchAcceptKeyCodes,
    );
    return AppConfig.fromValues(
      environment: environment,
      kind: kind,
      rawBaseUrl: rawBaseUrl,
      rawPins: rawPins,
      rawFake: rawFake,
      rawKeys: rawKeys,
      isReleaseBuild: isReleaseBuild,
    );
  }

  /// Testable core of [AppConfig.resolve].
  @visibleForTesting
  factory AppConfig.fromValues({
    required AppEnvironment environment,
    required AppKind kind,
    required String rawBaseUrl,
    required String rawPins,
    required String rawFake,
    required String rawKeys,
    required bool isReleaseBuild,
  }) {
    // Dev talks to the dev backend unless told otherwise; the in-memory fake
    // backend is opt-in. Other environments must name their server.
    final useFake = rawFake == 'true';
    if (useFake && environment != AppEnvironment.dev) {
      throw StateError('USE_FAKE_BACKEND is only allowed in the dev flavor.');
    }
    final effectiveUrl = rawBaseUrl.isEmpty && environment == AppEnvironment.dev
        ? devBaseUrl
        : rawBaseUrl;
    if (!useFake && effectiveUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL is required for ${environment.name}. '
        'Pass --dart-define=API_BASE_URL=https://... (see docs/SETUP.md).',
      );
    }
    final baseUrl = useFake ? Uri.parse(fakeBaseUrl) : Uri.parse(effectiveUrl);
    if (!useFake && baseUrl.scheme != 'https') {
      throw StateError('API_BASE_URL must use https.');
    }
    final pins = rawPins
        .split(',')
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList(growable: false);
    if (environment == AppEnvironment.prod &&
        isReleaseBuild &&
        pins.length < 2) {
      throw StateError(
        'Prod release builds need at least two CERT_PINS (current and backup).',
      );
    }
    final keys = rawKeys
        .split(',')
        .map((k) => int.tryParse(k.trim()))
        .whereType<int>()
        .toSet();
    return AppConfig(
      environment: environment,
      kind: kind,
      apiBaseUrl: baseUrl,
      certificatePins: pins,
      useFakeBackend: useFake,
      watchAcceptKeyCodes: keys,
    );
  }

  /// Base URL used when the in-memory fake backend is active.
  static const fakeBaseUrl = 'https://fake.backend.local/';

  /// Dev backend (Swagger: `<devBaseUrl>api/docs`). Used by the dev flavor
  /// when no `API_BASE_URL` is given.
  static const devBaseUrl = 'https://api.mattel-dev.altimeda.com/';

  /// Socket.IO namespace that delivers work orders and status events.
  static const realtimeNamespace = '/technician';

  /// Default side-button key codes. `KEYCODE_F1..F4` and the common
  /// scanner trigger codes (280, 293, 294). Verify on the WD1 II and override
  /// with `--dart-define=WATCH_ACCEPT_KEYCODES=...`.
  static const defaultWatchAcceptKeyCodes = '131,132,133,134,280,293,294';

  final AppEnvironment environment;
  final AppKind kind;
  final Uri apiBaseUrl;
  final List<String> certificatePins;
  final bool useFakeBackend;
  final Set<int> watchAcceptKeyCodes;

  bool get isWatch => kind == AppKind.watch;
  bool get isProd => environment == AppEnvironment.prod;

  /// `<origin>/technician` on the API host (Socket.IO v4, websocket only).
  Uri get realtimeUrl =>
      apiBaseUrl.replace(path: realtimeNamespace, query: null, fragment: null);
}
