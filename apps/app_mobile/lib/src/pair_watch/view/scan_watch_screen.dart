import 'dart:async';

import 'package:camera_scanner/camera_scanner.dart';
import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

/// Watch pairing scanner (backend guide, part 1 step 8; A.5): scan the
/// watch QR, preview the watch, confirm "Masuk ke Watch 1?", approve. The
/// watch then exchanges the pairing and logs in by itself.
class ScanWatchScreen extends StatelessWidget {
  const ScanWatchScreen({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => PairWatchCubit(
      repository: context.read<AuthRepository>(),
      connectivity: context.read<ConnectivityService>(),
    ),
    child: _ScanView(onDone: onDone),
  );
}

class _ScanView extends StatelessWidget {
  const _ScanView({required this.onDone});

  final VoidCallback onDone;

  Future<void> _onState(BuildContext context, PairWatchState state) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<PairWatchCubit>();
    switch (state) {
      case PairConfirming(:final device):
        final ok = await showConfirmDialog(
          context,
          title: l10n.pairConfirmTitle(device.name ?? l10n.watchUnnamed),
          body: l10n.pairConfirmBody(device.location ?? '-'),
          confirmLabel: l10n.pairConfirmButton,
        );
        if (ok) {
          await cubit.confirm();
        } else {
          cubit.cancel();
        }
      case PairSuccess():
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.pairSuccess)));
        onDone();
      case PairFailure(:final failure):
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failureText(l10n, failure))));
        cubit.cancel();
      case PairScanning() || PairChecking() || PairApproving():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<PairWatchCubit>();
    return BlocConsumer<PairWatchCubit, PairWatchState>(
      listenWhen: (a, b) => a.runtimeType != b.runtimeType,
      listener: (context, state) => unawaited(_onState(context, state)),
      builder: (context, state) => QrCameraScanner(
        title: l10n.scannerTitle,
        hint: switch (state) {
          PairScanning(rejection: ScanRejection.notWatchCode) =>
            l10n.pairNotWatchCode,
          PairScanning(rejection: ScanRejection.unreadable) =>
            l10n.pairInvalidQr,
          PairChecking() => l10n.pairChecking,
          PairApproving() => l10n.pairWaiting,
          _ => l10n.scannerHint,
        },
        paused: state is! PairScanning,
        busy: state is PairChecking || state is PairApproving,
        // The QR text is never logged (doc 17.1).
        onDetect: (raw) => unawaited(cubit.scanned(raw)),
        onClose: onDone,
      ),
    );
  }
}
