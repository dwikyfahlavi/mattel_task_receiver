// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:dio/dio.dart' as _i361;
import 'package:feature_task/src/data/task_api.dart' as _i159;
import 'package:feature_task/src/data/task_repository.dart' as _i366;
import 'package:feature_task/src/di/feature_task_module.dart' as _i492;
import 'package:feature_task/src/presentation/task_session/bloc/task_session_bloc.dart'
    as _i570;
import 'package:injectable/injectable.dart' as _i526;

class FeatureTaskPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final featureTaskModule = _$FeatureTaskModule();
    gh.lazySingleton<_i159.TaskApi>(
        () => featureTaskModule.taskApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i366.TaskRepository>(
        () => featureTaskModule.taskRepository(
              gh<_i159.TaskApi>(),
              gh<_i494.ErrorMapper>(),
              gh<_i494.TaskEventStore>(),
              gh<_i494.RealtimeService>(),
              gh<_i494.AppClock>(),
            ));
    gh.factory<_i570.TaskSessionBloc>(() => featureTaskModule.taskSessionBloc(
          gh<_i366.TaskRepository>(),
          gh<_i494.TaskEventProcessor>(),
          gh<_i494.RealtimeService>(),
          gh<_i494.PushService>(),
          gh<_i494.TaskNotifications>(),
          gh<_i494.AlertService>(),
          gh<_i494.AppClock>(),
          gh<_i494.ConnectivityService>(),
        ));
  }
}

class _$FeatureTaskModule extends _i492.FeatureTaskModule {}
