import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:feature_task/feature_task.dart';
import 'package:injectable/injectable.dart';

import '../data/availability_repository.dart';

@InjectableInit.microPackage(
  ignoreUnregisteredTypesInPackages: ['core', 'dio', 'feature_task'],
)
void initFeatureAvailabilityMicroPackage() {}

/// The availability and shift-end blocs depend on other app-scoped blocs, so
/// the apps construct them in their root providers.
@module
abstract class FeatureAvailabilityModule {
  @lazySingleton
  AvailabilityApi availabilityApi(Dio dio) => AvailabilityApi(dio);

  @lazySingleton
  AvailabilityRepository availabilityRepository(
    AvailabilityApi api,
    TaskRepository tasks,
    ErrorMapper errors,
    OutboxService outbox,
    AppClock clock,
  ) => AvailabilityRepository(
    api: api,
    tasks: tasks,
    errors: errors,
    outbox: outbox,
    clock: clock,
  );
}
