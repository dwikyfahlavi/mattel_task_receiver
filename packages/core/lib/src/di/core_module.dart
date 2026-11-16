import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';

import '../alerts/alert_service.dart';
import '../config/app_config.dart';
import '../config/remote_settings.dart';
import '../config/task_delivery.dart';
import '../connectivity/connectivity_service.dart';
import '../db/app_database.dart';
import '../db/key_value_store.dart';
import '../device/device_identity.dart';
import '../flags/feature_flags.dart';
import '../network/dio_factory.dart';
import '../network/error_mapper.dart';
import '../network/fake/fake_backend.dart';
import '../offline/outbox_service.dart';
import '../permissions/readiness.dart';
import '../push/push_service.dart';
import '../realtime/keep_alive.dart';
import '../realtime/realtime_models.dart';
import '../realtime/realtime_service.dart';
import '../session/local_session_wiper.dart';
import '../session/session_events.dart';
import '../session/shift_schedule.dart';
import '../storage/secure_store.dart';
import '../storage/token_store.dart';
import '../tasks/task_event_processor.dart';
import '../tasks/task_event_store.dart';
import '../tasks/task_notifications.dart';
import '../time/app_clock.dart';
import '../update/update_services.dart';
import '../version/version_gate.dart';

/// Registered by the app before `configureDependencies()`: whether
/// `Firebase.initializeApp()` succeeded (a missing google-services.json in a
/// fresh checkout must not crash the app).
class FirebaseStatus {
  const FirebaseStatus({required this.configured});
  final bool configured;
}

/// Holds the fake backend when `USE_FAKE_BACKEND=true`; `backend` is null
/// otherwise.
class FakeBackendHolder {
  const FakeBackendHolder(this.backend);
  final FakeBackend? backend;
}

/// [AppConfig] and [FirebaseStatus] are registered by each app before init.
@InjectableInit.microPackage(
  ignoreUnregisteredTypes: [AppConfig, FirebaseStatus],
)
void initCoreMicroPackage() {}

/// Core registrations. Everything is a lazy singleton (doc 18): nothing is
/// created before it is first used.
@module
abstract class CoreModule {
  @lazySingleton
  SessionEventBus get sessionEvents => SessionEventBus();

  @lazySingleton
  SystemAppClock get systemClock => SystemAppClock();

  @lazySingleton
  AppClock clock(SystemAppClock clock) => clock;

  @lazySingleton
  SecureStore get secureStore => SecureStore();

  @lazySingleton
  TokenStore tokenStore(SecureStore secure) => TokenStore(secure);

  @LazySingleton(dispose: closeDatabase)
  AppDatabase get database => AppDatabase.open();

  @lazySingleton
  KeyValueStore keyValueStore(AppDatabase db) => KeyValueStore(db);

  @lazySingleton
  TaskEventStore taskEventStore(AppDatabase db) => TaskEventStore(db);

  @lazySingleton
  ConnectivityService get connectivity => PlatformConnectivityService();

  @lazySingleton
  FakeBackendHolder fakeBackend(AppConfig config) =>
      FakeBackendHolder(config.useFakeBackend ? FakeBackend() : null);

  // ------------------------------------------------------- watch identity

  @lazySingleton
  DeviceKeyStore deviceKeys(AppConfig config) => config.useFakeBackend
      ? FakeDeviceKeyStore()
      : const PlatformDeviceKeyStore();

  @lazySingleton
  DeviceIdentity deviceIdentity(SecureStore secure, DeviceKeyStore keys) =>
      DeviceIdentity(secure: secure, keys: keys);

  @lazySingleton
  RequestSigner requestSigner(DeviceIdentity identity, AppClock clock) =>
      RequestSigner(identity: identity, clock: clock);

  // ------------------------------------------------------------- network

  @lazySingleton
  Dio dio(
    AppConfig config,
    AppClock clock,
    TokenStore tokens,
    SessionEventBus events,
    ConnectivityService connectivity,
    FakeBackendHolder fake,
    RequestSigner signer,
  ) => DioFactory.create(
    config: config,
    clock: clock,
    tokens: tokens,
    sessionEvents: events,
    connectivity: connectivity,
    // Only the watch signs its requests (the phone sends no X- headers).
    signer: config.isWatch ? signer : null,
    adapter: fake.backend?.adapter,
  );

  @lazySingleton
  ErrorMapper errorMapper(AppClock clock) => ErrorMapper(clock);

  // ------------------------------------------------------------ delivery

  @lazySingleton
  RealtimeService realtime(
    AppConfig config,
    TokenStore tokens,
    RequestSigner signer,
    FakeBackendHolder fake,
  ) {
    final backend = fake.backend;
    if (backend != null) return backend.realtime;
    return SocketIoRealtimeService(
      url: config.realtimeUrl,
      auth: RealtimeAuth(
        tokens: tokens,
        signer: config.isWatch ? signer : null,
      ),
      certificatePins: config.certificatePins,
    );
  }

  @lazySingleton
  PushService push(FakeBackendHolder fake, FirebaseStatus firebase) {
    final backend = fake.backend;
    if (backend != null) return StreamPushService(backend.pushMessages);
    return firebase.configured ? FirebasePushService() : NoopPushService();
  }

  @lazySingleton
  ForegroundKeepAlive get keepAlive => ForegroundKeepAlive();

  @lazySingleton
  ThisDevice thisDevice(AppConfig config, DeviceIdentity identity) =>
      ThisDevice(
        kind: config.isWatch ? SessionKind.shared : SessionKind.personal,
        deviceId: () => identity.deviceId,
      );

  @lazySingleton
  TaskEventProcessor taskEventProcessor(
    TaskEventStore store,
    ThisDevice self,
  ) => TaskEventProcessor(store, self: self);

  // ------------------------------------------------------ remote settings

  /// Remote Config first, the Firestore document `app_config/<env>` as the
  /// backup, compiled-in defaults last (DECISIONS D-23).
  @lazySingleton
  RemoteSettings remoteSettings(FirebaseStatus firebase, AppConfig config) =>
      LayeredRemoteSettings(
        sources: firebase.configured
            ? [
                RemoteConfigSource(
                  FirebaseRemoteConfig.instance,
                  minimumFetchInterval: config.environment == AppEnvironment.dev
                      ? Duration.zero
                      : const Duration(hours: 12),
                ),
                FirestoreSettingsSource(
                  FirebaseFirestore.instance,
                  environment: config.environment,
                ),
              ]
            : const [],
        defaults: {
          ...FeatureFlag.defaults,
          RemoteKeys.shiftSchedule: ShiftSchedule.defaultJson,
          RemoteKeys.shiftEndGraceMinutes:
              SessionPolicyFactory.defaultGraceMinutes,
          RemoteKeys.taskDelivery: TaskDelivery.defaultValue.wireName,
        },
      );

  @lazySingleton
  FeatureFlags featureFlags(RemoteSettings settings) =>
      RemoteFeatureFlags(settings);

  // ------------------------------------------------------------- devices

  @lazySingleton
  TaskNotifications get notifications => TaskNotifications();

  @lazySingleton
  AlertService get alerts => VibrationAlertService();

  @lazySingleton
  ReadinessService readiness(
    ConnectivityService connectivity,
    AppClock clock,
    AppConfig config,
    RealtimeService realtime,
    RemoteSettings settings,
  ) => ReadinessService(
    PlatformReadinessProbe(
      connectivity: connectivity,
      clock: clock,
      realtimeConnected: () => realtime.isConnected,
    ),
    config.kind,
    delivery: () => TaskDelivery.fromSettings(settings),
  );

  @lazySingleton
  ReadinessActions readinessActions(TaskNotifications notifications) =>
      ReadinessActions(notifications: notifications);

  @lazySingleton
  VersionGate versionGate(
    RemoteSettings settings,
    AppConfig config,
    KeyValueStore cache,
    AppClock clock,
  ) => VersionGate(
    settings: settings,
    config: config,
    cache: cache,
    clock: clock,
  );

  @lazySingleton
  OutboxService outbox(
    AppDatabase db,
    AppClock clock,
    ConnectivityService connectivity,
  ) => OutboxService(db: db, clock: clock, connectivity: connectivity);

  @lazySingleton
  PatchUpdater patchUpdater(AppConfig config) => PatchUpdater(config: config);

  @lazySingleton
  ApkUpdater get apkUpdater => ApkUpdater();

  @lazySingleton
  LocalSessionWiper wiper(
    TokenStore tokens,
    SecureStore secure,
    AppDatabase db,
    PushService push,
    TaskNotifications notifications,
  ) => LocalSessionWiper(
    tokens: tokens,
    secure: secure,
    db: db,
    push: push,
    notifications: notifications,
  );
}

Future<void> closeDatabase(AppDatabase db) => db.close();
