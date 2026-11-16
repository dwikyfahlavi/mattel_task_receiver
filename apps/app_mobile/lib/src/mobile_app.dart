import 'package:app_shell/app_shell.dart';
import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'pair_watch/view/scan_watch_screen.dart';

abstract final class MobilePaths {
  static const login = '/login';
  static const scan = '/scan';
}

/// Phone and tablet app (doc 3.1 / 3.3). Layout adapts by `shortestSide`.
Future<void> runMobileApp(AppEnvironment environment) => bootstrapApp(
  environment: environment,
  kind: AppKind.mobile,
  routes: mobileRoutes(),
);

ShellRoutes mobileRoutes() => ShellRoutes(
  signedOutLocation: MobilePaths.login,
  scanLocation: MobilePaths.scan,
  signedOutRoutes: [
    GoRoute(
      path: MobilePaths.login,
      builder: (context, _) => LoginScreen(
        repository: context.read<AuthRepository>(),
        year: context.read<AppClock>().jakartaNow().year,
        sessionEndMessage: sessionEndMessage(context),
        onSignedIn: context.read<SessionCubit>().signedIn,
        // Vendor Technician is not built yet (doc 14): no route, so the
        // button stays hidden even if the flag is switched on.
      ),
    ),
  ],
  signedInRoutes: [
    GoRoute(
      path: MobilePaths.scan,
      builder: (context, _) => ScanWatchScreen(onDone: () => context.pop()),
    ),
  ],
);
