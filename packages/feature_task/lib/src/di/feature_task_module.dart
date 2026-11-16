import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../data/task_api.dart';
import '../data/task_repository.dart';
import '../presentation/task_session/bloc/task_session_bloc.dart';

/// Core types are registered by `CorePackageModule`, which the apps run first.
@InjectableInit.microPackage(ignoreUnregisteredTypesInPackages: ['core', 'dio'])
void initFeatureTaskMicroPackage() {}

@module
abstract class FeatureTaskModule {
  @lazySingleton
  TaskApi taskApi(Dio dio) => TaskApi(dio);

  @lazySingleton
  TaskRepository taskRepository(
    TaskApi api,
    ErrorMapper errors,
    TaskEventStore store,
    RealtimeService realtime,
    AppClock clock,
  ) => TaskRepository(
    api: api,
    errors: errors,
    store: store,
    realtime: realtime,
    clock: clock,
  );

  /// App-scoped: created once by the app root `BlocProvider`.
  @injectable
  TaskSessionBloc taskSessionBloc(
    TaskRepository repository,
    TaskEventProcessor processor,
    RealtimeService realtime,
    PushService push,
    TaskNotifications notifications,
    AlertService alerts,
    AppClock clock,
    ConnectivityService connectivity,
  ) => TaskSessionBloc(
    repository: repository,
    processor: processor,
    realtime: realtime,
    push: push,
    notifications: notifications,
    alerts: alerts,
    clock: clock,
    connectivity: connectivity,
  );
}
