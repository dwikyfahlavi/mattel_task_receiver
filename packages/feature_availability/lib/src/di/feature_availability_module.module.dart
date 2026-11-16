// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'dart:async' as _i687;

import 'package:core/core.dart' as _i494;
import 'package:dio/dio.dart' as _i361;
import 'package:feature_availability/src/data/availability_repository.dart'
    as _i258;
import 'package:feature_availability/src/di/feature_availability_module.dart'
    as _i348;
import 'package:feature_task/feature_task.dart' as _i917;
import 'package:injectable/injectable.dart' as _i526;

class FeatureAvailabilityPackageModule extends _i526.MicroPackageModule {
// initializes the registration of main-scope dependencies inside of GetIt
  @override
  _i687.FutureOr<void> init(_i526.GetItHelper gh) {
    final featureAvailabilityModule = _$FeatureAvailabilityModule();
    gh.lazySingleton<_i258.AvailabilityApi>(
        () => featureAvailabilityModule.availabilityApi(gh<_i361.Dio>()));
    gh.lazySingleton<_i258.AvailabilityRepository>(
        () => featureAvailabilityModule.availabilityRepository(
              gh<_i258.AvailabilityApi>(),
              gh<_i917.TaskRepository>(),
              gh<_i494.ErrorMapper>(),
              gh<_i494.OutboxService>(),
              gh<_i494.AppClock>(),
            ));
  }
}

class _$FeatureAvailabilityModule extends _i348.FeatureAvailabilityModule {}
