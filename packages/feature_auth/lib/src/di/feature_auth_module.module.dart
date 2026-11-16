// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:dio/dio.dart' as _i361;
import 'package:feature_auth/src/data/auth_api.dart' as _i1052;
import 'package:feature_auth/src/data/auth_repository.dart' as _i395;
import 'package:feature_auth/src/di/feature_auth_module.dart' as _i817;
import 'package:feature_auth/src/presentation/session/cubit/session_cubit.dart'
    as _i365;
import 'package:injectable/injectable.dart' as _i526;

class FeatureAuthPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final featureAuthModule = _$FeatureAuthModule();
    gh.lazySingleton<_i1052.AuthApi>(
        () => featureAuthModule.authApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i395.AuthRepository>(
        () => featureAuthModule.authRepository(
              gh<_i1052.AuthApi>(),
              gh<_i494.ErrorMapper>(),
              gh<_i494.TokenStore>(),
              gh<_i494.SecureStore>(),
              gh<_i494.PushService>(),
              gh<_i494.LocalSessionWiper>(),
              gh<_i494.AppConfig>(),
              gh<_i494.AppClock>(),
              gh<_i494.RemoteSettings>(),
              gh<_i494.DeviceIdentity>(),
              gh<_i494.RequestSigner>(),
            ));
    gh.factory<_i365.SessionCubit>(() => featureAuthModule.sessionCubit(
          gh<_i395.AuthRepository>(),
          gh<_i494.SessionEventBus>(),
          gh<_i494.AppClock>(),
          gh<_i494.AppConfig>(),
          gh<_i494.FeatureFlags>(),
          gh<_i494.TaskEventStore>(),
          gh<_i494.KeyValueStore>(),
          gh<_i494.RealtimeService>(),
          gh<_i494.PushService>(),
        ));
  }
}

class _$FeatureAuthModule extends _i817.FeatureAuthModule {}
