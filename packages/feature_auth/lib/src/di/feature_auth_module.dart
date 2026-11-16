import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/auth_api.dart';
import '../data/auth_repository.dart';
import '../presentation/session/cubit/session_cubit.dart';

@InjectableInit.microPackage(ignoreUnregisteredTypesInPackages: ['core', 'dio'])
void initFeatureAuthMicroPackage() {}

@module
abstract class FeatureAuthModule {
  @lazySingleton
  AuthApi authApi(Dio dio) => AuthApi(dio);

  @lazySingleton
  AuthRepository authRepository(
    AuthApi api,
    ErrorMapper errors,
    TokenStore tokens,
    SecureStore secure,
    PushService push,
    LocalSessionWiper wiper,
    AppConfig config,
    AppClock clock,
    RemoteSettings settings,
    DeviceIdentity identity,
    RequestSigner signer,
  ) => AuthRepository(
    api: api,
    errors: errors,
    tokens: tokens,
    secure: secure,
    push: push,
    wiper: wiper,
    config: config,
    clock: clock,
    settings: settings,
    identity: identity,
    signer: signer,
  );

  /// App-scoped: created once by the app root `BlocProvider`.
  @injectable
  SessionCubit sessionCubit(
    AuthRepository repository,
    SessionEventBus events,
    AppClock clock,
    AppConfig config,
    FeatureFlags flags,
    TaskEventStore taskStore,
    KeyValueStore keyValues,
    RealtimeService realtime,
    PushService push,
  ) => SessionCubit(
    repository: repository,
    events: events,
    clock: clock,
    config: config,
    flags: flags,
    taskStore: taskStore,
    keyValues: keyValues,
    realtime: realtime,
    push: push,
  );
}
