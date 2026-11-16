import '../config/remote_settings.dart';

/// Feature flags with compiled-in defaults (doc 14). Flags are not security
/// controls; the backend enforces permissions.
enum FeatureFlag {
  vendorTechnicianLogin('vendor_technician_login', false),
  autoLogoutMobile('auto_logout_mobile', false),
  inAppApkUpdate('in_app_apk_update', false);

  const FeatureFlag(this.key, this.defaultValue);
  final String key;
  final bool defaultValue;

  static Map<String, Object> get defaults => {
    for (final f in values) f.key: f.defaultValue,
  };
}

abstract interface class FeatureFlags {
  bool isEnabled(FeatureFlag flag);

  /// Fetches without activating (doc 14: apply at a safe point).
  Future<void> fetch();

  /// Activates fetched values. Call at a safe point, e.g. app start or the
  /// next Home build, never while a popup is visible.
  Future<void> applyPending();
}

/// Compiled-in defaults only (tests).
class DefaultFeatureFlags implements FeatureFlags {
  DefaultFeatureFlags([Map<FeatureFlag, bool> overrides = const {}])
    : _overrides = Map.of(overrides);

  final Map<FeatureFlag, bool> _overrides;

  @override
  bool isEnabled(FeatureFlag flag) => _overrides[flag] ?? flag.defaultValue;

  @override
  Future<void> fetch() async {}

  @override
  Future<void> applyPending() async {}
}

/// Flags read from [RemoteSettings] (Remote Config, then the Firestore
/// backup, then the compiled-in default).
class RemoteFeatureFlags implements FeatureFlags {
  RemoteFeatureFlags(this._settings);

  final RemoteSettings _settings;

  @override
  bool isEnabled(FeatureFlag flag) =>
      _settings.boolean(flag.key, fallback: flag.defaultValue);

  @override
  Future<void> fetch() => _settings.fetch();

  @override
  Future<void> applyPending() => _settings.applyPending();
}
