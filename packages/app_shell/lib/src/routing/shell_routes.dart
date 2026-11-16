import 'package:go_router/go_router.dart';

/// What each app contributes to the router.
class ShellRoutes {
  const ShellRoutes({
    required this.signedOutLocation,
    required this.signedOutRoutes,
    this.signedInRoutes = const [],
    this.scanLocation,
  });

  /// First screen when signed out (`/login` or `/welcome`).
  final String signedOutLocation;
  final List<GoRoute> signedOutRoutes;

  /// Extra routes for signed-in users (mobile: `/scan`).
  final List<GoRoute> signedInRoutes;

  /// Watch pairing scanner route, shown as "Scan QR Code" on Home.
  final String? scanLocation;

  Set<String> get signedOutPaths => {for (final r in signedOutRoutes) r.path};
}
