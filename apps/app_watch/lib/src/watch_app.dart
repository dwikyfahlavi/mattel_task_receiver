import 'dart:async';

import 'package:app_shell/app_shell.dart';
import 'package:camera_scanner/camera_scanner.dart';
import 'package:core/core.dart';
import 'package:device_bridge/device_bridge.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ui_kit/ui_kit.dart';

abstract final class WatchPaths {
  static const welcome = '/welcome';
  static const enroll = '/enroll';
  static const qr = '/qr';
}

/// Newland WD1 II app (doc 3.2): a shared watch. Enrolled once with the
/// admin's code, then a technician pairs it from their phone each shift.
Future<void> runWatchApp(AppEnvironment environment) => bootstrapApp(
  environment: environment,
  kind: AppKind.watch,
  routes: watchRoutes(),
  formFactor: FormFactor.watch,
);

ShellRoutes watchRoutes() => ShellRoutes(
  signedOutLocation: WatchPaths.welcome,
  signedOutRoutes: [
    GoRoute(
      path: WatchPaths.welcome,
      builder: (context, _) => WatchWelcomeScreen(
        year: context.read<AppClock>().jakartaNow().year,
        sessionEndMessage: sessionEndMessage(context),
        // Not enrolled yet (or the key was lost): enroll first.
        onLoginWithQr: () => unawaited(() async {
          final enrolled = await context.read<AuthRepository>().isEnrolled();
          if (context.mounted) {
            context.go(enrolled ? WatchPaths.qr : WatchPaths.enroll);
          }
        }()),
      ),
    ),
    GoRoute(
      path: WatchPaths.enroll,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);
        return WatchEnrollScreen(
          repository: context.read<AuthRepository>(),
          onEnrolled: (device) {
            ScaffoldMessenger.maybeOf(context)?.showSnackBar(
              SnackBar(content: Text(l10n.enrollSuccess(device.name ?? '-'))),
            );
            context.go(WatchPaths.qr);
          },
          scanWithCamera: () => scanQrWithCamera(
            context,
            title: l10n.scannerEnrollTitle,
            hint: l10n.scannerEnrollHint,
          ),
          hardwareScans: const DeviceBridge().hardwareScans(),
        );
      },
    ),
    GoRoute(
      path: WatchPaths.qr,
      builder: (context, _) => WatchQrScreen(
        repository: context.read<AuthRepository>(),
        year: context.read<AppClock>().jakartaNow().year,
        onSignedIn: context.read<SessionCubit>().signedIn,
        onReenroll: () => unawaited(() async {
          await context.read<AuthRepository>().forgetEnrollment();
          if (context.mounted) context.go(WatchPaths.enroll);
        }()),
        qrBuilder: (data, size) => QrImageView(
          data: data,
          size: size,
          backgroundColor: Colors.white,
          errorCorrectionLevel: QrErrorCorrectLevel.M,
          semanticsLabel: AppLocalizations.of(context).watchScanTitle,
        ),
      ),
    ),
  ],
);
