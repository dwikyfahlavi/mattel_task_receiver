import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_availability/feature_availability.dart';
import 'package:feature_task/feature_task.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

/// Composes the feature micro-packages (doc 6). The app registers
/// [AppConfig] and [FirebaseStatus] first, then calls this.
@InjectableInit(
  initializerName: 'init',
  ignoreUnregisteredTypes: [AppConfig, FirebaseStatus],
  externalPackageModulesBefore: [
    ExternalModule(CorePackageModule),
    ExternalModule(FeatureTaskPackageModule),
    ExternalModule(FeatureAuthPackageModule),
    ExternalModule(FeatureAvailabilityPackageModule),
  ],
)
Future<void> configureDependencies(
  GetIt getIt, {
  required AppConfig config,
  required FirebaseStatus firebase,
}) async {
  getIt
    ..registerSingleton<AppConfig>(config)
    ..registerSingleton<FirebaseStatus>(firebase);
  await getIt.init();
}
