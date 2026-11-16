import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../data/auth_repository.dart';
import '../cubit/watch_pairing_cubit.dart';
import '../widgets/watch_layout.dart';

/// Watch QR screen (A.3). [qrBuilder] renders the backend's `qr_payload`
/// (qr_flutter lives in the watch app only, doc 5).
class WatchQrScreen extends StatelessWidget {
  const WatchQrScreen({
    required this.repository,
    required this.qrBuilder,
    required this.onSignedIn,
    required this.year,
    this.onReenroll,
    super.key,
  });

  final AuthRepository repository;
  final Widget Function(String data, double size) qrBuilder;
  final ValueChanged<SessionInfo> onSignedIn;
  final int year;

  /// The device signature was refused: forget the enrollment and enroll
  /// again (admin reset the watch).
  final VoidCallback? onReenroll;

  @override
  Widget build(BuildContext context) => KeepScreenOn(
    child: BlocProvider(
      create: (context) => WatchPairingCubit(
        repository: repository,
        realtime: context.read<RealtimeService>(),
        clock: context.read<AppClock>(),
      )..start(),
      child: BlocListener<WatchPairingCubit, WatchPairingState>(
        listenWhen: (_, b) => b is PairingDone,
        listener: (_, s) => onSignedIn((s as PairingDone).info),
        child: _WatchQrView(
          qrBuilder: qrBuilder,
          year: year,
          onReenroll: onReenroll,
        ),
      ),
    ),
  );
}

class _WatchQrView extends StatelessWidget {
  const _WatchQrView({
    required this.qrBuilder,
    required this.year,
    this.onReenroll,
  });

  final Widget Function(String data, double size) qrBuilder;
  final int year;
  final VoidCallback? onReenroll;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: BlocBuilder<WatchPairingCubit, WatchPairingState>(
            builder: (context, state) {
              final cubit = context.read<WatchPairingCubit>();
              return LayoutBuilder(
                builder: (context, box) {
                  final compact = box.maxHeight < compactWatchHeight;
                  // Landscape 4:3: QR on the left (as large as possible while
                  // leaving ~55% of the width for text and the button).
                  final qrSize = box.maxHeight < box.maxWidth * 0.45
                      ? box.maxHeight
                      : box.maxWidth * 0.45;
                  final qrArea = Container(
                    width: qrSize,
                    height: qrSize,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: c.border),
                      borderRadius: BorderRadius.circular(AppShape.cardRadius),
                    ),
                    alignment: Alignment.center,
                    child: switch (state) {
                      PairingShowing(:final qrData) => Semantics(
                        label: l10n.watchScanTitle,
                        image: true,
                        child: qrBuilder(qrData, qrSize - 12),
                      ),
                      PairingExpired(:final offline) => Text(
                        offline ? l10n.watchQrOffline : l10n.watchQrExpired,
                        textAlign: TextAlign.center,
                        style: theme.bodySmall?.copyWith(color: c.danger),
                      ),
                      PairingClaiming() || PairingDone() => Semantics(
                        label: l10n.watchPairing,
                        child: const CircularProgressIndicator(),
                      ),
                      PairingCreating() => const CircularProgressIndicator(),
                      PairingDeviceRejected() => Text(
                        l10n.errorDeviceSignature,
                        textAlign: TextAlign.center,
                        style: theme.bodySmall?.copyWith(color: c.danger),
                      ),
                    },
                  );
                  final busy =
                      state is PairingClaiming || state is PairingCreating;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      qrArea,
                      const SizedBox(width: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (!compact) ...[
                                const AppLogoHeader(size: 24),
                                const SizedBox(height: 8),
                              ],
                              Text(
                                l10n.watchScanTitle,
                                style: theme.titleMedium,
                              ),
                              const SizedBox(height: 2),
                              Text(l10n.watchScanHint, style: theme.bodySmall),
                              const SizedBox(height: 8),
                              if (state is PairingDeviceRejected &&
                                  onReenroll != null)
                                AppButton(
                                  label: l10n.enrollTitle,
                                  variant: AppButtonVariant.brand,
                                  onPressed: onReenroll,
                                )
                              else
                                AppButton(
                                  label: l10n.watchRegenerateQr,
                                  variant: AppButtonVariant.brand,
                                  onPressed: busy ? null : cubit.regenerate,
                                ),
                              if (!compact) ...[
                                const SizedBox(height: 4),
                                CopyrightText(year: year),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
