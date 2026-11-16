import 'package:core/core.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:ui_kit/ui_kit.dart';

import 'app/shell_app.dart';
import 'di.dart';
import 'routing/shell_routes.dart';

/// Entry point used by `main_<env>.dart` of both apps (doc 6 / 19.1).
///
/// Before the first frame: binding, Firebase (optional), DI registration
/// (lazy, nothing is constructed yet). Session restore, version check,
/// Drift and Remote Config run while the splash is visible (doc 18).
Future<void> bootstrapApp({
  required AppEnvironment environment,
  required AppKind kind,
  required ShellRoutes routes,
  FormFactor? formFactor,
}) async {
  final firebase = await AppStartup.initialize(environment);
  final config = AppConfig.resolve(environment: environment, kind: kind);
  await configureDependencies(
    GetIt.instance,
    config: config,
    firebase: firebase,
  );
  runApp(ShellApp(routes: routes, formFactor: formFactor));
}
