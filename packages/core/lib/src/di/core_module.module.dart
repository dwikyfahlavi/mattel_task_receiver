// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:core/src/alerts/alert_service.dart' as _i168;
import 'package:core/src/config/app_config.dart' as _i920;
import 'package:core/src/config/remote_settings.dart' as _i173;
import 'package:core/src/connectivity/connectivity_service.dart' as _i213;
import 'package:core/src/db/app_database.dart' as _i110;
import 'package:core/src/db/key_value_store.dart' as _i616;
import 'package:core/src/device/device_identity.dart' as _i334;
import 'package:core/src/di/core_module.dart' as _i748;
import 'package:core/src/flags/feature_flags.dart' as _i715;
import 'package:core/src/network/error_mapper.dart' as _i217;
import 'package:core/src/offline/outbox_service.dart' as _i561;
import 'package:core/src/permissions/readiness.dart' as _i446;
import 'package:core/src/push/push_service.dart' as _i906;
import 'package:core/src/realtime/keep_alive.dart' as _i867;
import 'package:core/src/realtime/realtime_service.dart' as _i384;
import 'package:core/src/session/local_session_wiper.dart' as _i435;
import 'package:core/src/session/session_events.dart' as _i1041;
import 'package:core/src/storage/secure_store.dart' as _i229;
import 'package:core/src/storage/token_store.dart' as _i291;
import 'package:core/src/tasks/task_event_processor.dart' as _i517;
import 'package:core/src/tasks/task_event_store.dart' as _i353;
import 'package:core/src/tasks/task_notifications.dart' as _i423;
import 'package:core/src/time/app_clock.dart' as _i188;
import 'package:core/src/update/update_services.dart' as _i310;
import 'package:core/src/version/version_gate.dart' as _i635;
import 'package:dio/dio.dart' as _i361;
import 'package:injectable/injectable.dart' as _i526;

class CorePackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final coreModule = _$CoreModule();
    gh.lazySingleton<_i1041.SessionEventBus>(() => coreModule.sessionEvents);
    gh.lazySingleton<_i188.SystemAppClock>(() => coreModule.systemClock);
    gh.lazySingleton<_i229.SecureStore>(() => coreModule.secureStore);
    gh.lazySingleton<_i110.AppDatabase>(
      () => coreModule.database,
      dispose: _i748.closeDatabase,
    );
    gh.lazySingleton<_i213.ConnectivityService>(() => coreModule.connectivity);
    gh.lazySingleton<_i867.ForegroundKeepAlive>(() => coreModule.keepAlive);
    gh.lazySingleton<_i423.TaskNotifications>(() => coreModule.notifications);
    gh.lazySingleton<_i168.AlertService>(() => coreModule.alerts);
    gh.lazySingleton<_i310.ApkUpdater>(() => coreModule.apkUpdater);
    gh.lazySingleton<_i748.FakeBackendHolder>(
        () => coreModule.fakeBackend(gh<_i920.AppConfig>()));
    gh.lazySingleton<_i334.DeviceKeyStore>(
        () => coreModule.deviceKeys(gh<_i920.AppConfig>()));
    gh.lazySingleton<_i310.PatchUpdater>(
        () => coreModule.patchUpdater(gh<_i920.AppConfig>()));
    gh.lazySingleton<_i446.ReadinessActions>(
        () => coreModule.readinessActions(gh<_i423.TaskNotifications>()));
    gh.lazySingleton<_i291.TokenStore>(
        () => coreModule.tokenStore(gh<_i229.SecureStore>()));
    gh.lazySingleton<_i616.KeyValueStore>(
        () => coreModule.keyValueStore(gh<_i110.AppDatabase>()));
    gh.lazySingleton<_i353.TaskEventStore>(
        () => coreModule.taskEventStore(gh<_i110.AppDatabase>()));
    gh.lazySingleton<_i188.AppClock>(
        () => coreModule.clock(gh<_i188.SystemAppClock>()));
    gh.lazySingleton<_i334.DeviceIdentity>(() => coreModule.deviceIdentity(
          gh<_i229.SecureStore>(),
          gh<_i334.DeviceKeyStore>(),
        ));
    gh.lazySingleton<_i173.RemoteSettings>(() => coreModule.remoteSettings(
          gh<_i748.FirebaseStatus>(),
          gh<_i920.AppConfig>(),
        ));
    gh.lazySingleton<_i517.ThisDevice>(() => coreModule.thisDevice(
          gh<_i920.AppConfig>(),
          gh<_i334.DeviceIdentity>(),
        ));
    gh.lazySingleton<_i906.PushService>(() => coreModule.push(
          gh<_i748.FakeBackendHolder>(),
          gh<_i748.FirebaseStatus>(),
        ));
    gh.lazySingleton<_i217.ErrorMapper>(
        () => coreModule.errorMapper(gh<_i188.AppClock>()));
    gh.lazySingleton<_i561.OutboxService>(() => coreModule.outbox(
          gh<_i110.AppDatabase>(),
          gh<_i188.AppClock>(),
          gh<_i213.ConnectivityService>(),
        ));
    gh.lazySingleton<_i715.FeatureFlags>(
        () => coreModule.featureFlags(gh<_i173.RemoteSettings>()));
    gh.lazySingleton<_i334.RequestSigner>(() => coreModule.requestSigner(
          gh<_i334.DeviceIdentity>(),
          gh<_i188.AppClock>(),
        ));
    gh.lazySingleton<_i361.Dio>(() => coreModule.dio(
          gh<_i920.AppConfig>(),
          gh<_i188.AppClock>(),
          gh<_i291.TokenStore>(),
          gh<_i1041.SessionEventBus>(),
          gh<_i213.ConnectivityService>(),
          gh<_i748.FakeBackendHolder>(),
          gh<_i334.RequestSigner>(),
        ));
    gh.lazySingleton<_i517.TaskEventProcessor>(
        () => coreModule.taskEventProcessor(
              gh<_i353.TaskEventStore>(),
              gh<_i517.ThisDevice>(),
            ));
    gh.lazySingleton<_i635.VersionGate>(() => coreModule.versionGate(
          gh<_i173.RemoteSettings>(),
          gh<_i920.AppConfig>(),
          gh<_i616.KeyValueStore>(),
          gh<_i188.AppClock>(),
        ));
    gh.lazySingleton<_i435.LocalSessionWiper>(() => coreModule.wiper(
          gh<_i291.TokenStore>(),
          gh<_i229.SecureStore>(),
          gh<_i110.AppDatabase>(),
          gh<_i906.PushService>(),
          gh<_i423.TaskNotifications>(),
        ));
    gh.lazySingleton<_i384.RealtimeService>(() => coreModule.realtime(
          gh<_i920.AppConfig>(),
          gh<_i291.TokenStore>(),
          gh<_i334.RequestSigner>(),
          gh<_i748.FakeBackendHolder>(),
        ));
    gh.lazySingleton<_i446.ReadinessService>(() => coreModule.readiness(
          gh<_i213.ConnectivityService>(),
          gh<_i188.AppClock>(),
          gh<_i920.AppConfig>(),
          gh<_i384.RealtimeService>(),
          gh<_i173.RemoteSettings>(),
        ));
  }
}

class _$CoreModule extends _i748.CoreModule {}
