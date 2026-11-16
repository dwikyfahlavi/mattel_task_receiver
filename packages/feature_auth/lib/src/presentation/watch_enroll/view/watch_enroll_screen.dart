import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../data/auth_dtos.dart';
import '../../../data/auth_repository.dart';
import '../../watch_pairing/widgets/watch_layout.dart';
import '../cubit/watch_enroll_cubit.dart';

/// One-time watch setup: the admin's enrollment code, typed, scanned with
/// the camera ([scanWithCamera], the camera package lives in the app) or
/// read by the built-in scanner ([hardwareScans]).
class WatchEnrollScreen extends StatelessWidget {
  const WatchEnrollScreen({
    required this.repository,
    required this.onEnrolled,
    this.scanWithCamera,
    this.hardwareScans = const Stream.empty(),
    super.key,
  });

  final AuthRepository repository;
  final ValueChanged<DeviceDto> onEnrolled;

  /// Opens the camera scanner and returns the raw QR text (null = cancelled).
  final Future<String?> Function()? scanWithCamera;
  final Stream<String> hardwareScans;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => WatchEnrollCubit(
      repository: repository,
      connectivity: context.read<ConnectivityService>(),
      hardwareScans: hardwareScans,
    ),
    child: BlocListener<WatchEnrollCubit, WatchEnrollState>(
      listenWhen: (a, b) => a.device == null && b.device != null,
      listener: (_, s) => onEnrolled(s.device!),
      child: _EnrollView(scanWithCamera: scanWithCamera),
    ),
  );
}

class _EnrollView extends StatefulWidget {
  const _EnrollView({this.scanWithCamera});

  final Future<String?> Function()? scanWithCamera;

  @override
  State<_EnrollView> createState() => _EnrollViewState();
}

class _EnrollViewState extends State<_EnrollView> {
  final _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _scan() async {
    final cubit = context.read<WatchEnrollCubit>();
    final raw = await widget.scanWithCamera?.call();
    if (raw == null || !mounted) return;
    await cubit.scanned(raw);
    if (mounted) _code.text = cubit.state.code;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final c = AppColors.of(context);
    final cubit = context.read<WatchEnrollCubit>();
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            final compact = box.maxHeight < compactWatchHeight;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: BlocConsumer<WatchEnrollCubit, WatchEnrollState>(
                listenWhen: (a, b) => a.code != b.code,
                listener: (_, s) {
                  // A hardware scan fills the field too.
                  if (_code.text != s.code) _code.text = s.code;
                },
                builder: (context, state) {
                  final failure = state.failure;
                  final error = state.invalidCode
                      ? l10n.enrollInvalid
                      : failure == null
                      ? null
                      : failure is UnexpectedFailure
                      ? l10n.enrollKeyFailed
                      : failureText(l10n, failure);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!compact) ...[
                        const AppLogoHeader(size: 24, centered: true),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        l10n.enrollTitle,
                        style: theme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        l10n.enrollSubtitle,
                        style: theme.bodySmall?.copyWith(color: c.textMuted),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      AppTextField(
                        label: l10n.enrollCodeLabel,
                        hint: l10n.enrollCodeHint,
                        icon: LucideIcons.keyRound,
                        controller: _code,
                        enabled: !state.submitting,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp('[A-Za-z0-9]'),
                          ),
                          LengthLimitingTextInputFormatter(32),
                        ],
                        textInputAction: TextInputAction.done,
                        errorText: error,
                        onChanged: cubit.codeChanged,
                        onSubmitted: (_) => cubit.submit(),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (widget.scanWithCamera != null) ...[
                            Expanded(
                              child: AppButton(
                                label: l10n.enrollScanButton,
                                icon: LucideIcons.scanLine,
                                variant: AppButtonVariant.secondary,
                                onPressed: state.submitting ? null : _scan,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: AppButton(
                              label: l10n.enrollButton,
                              variant: AppButtonVariant.brand,
                              loading: state.submitting,
                              onPressed: state.canSubmit ? cubit.submit : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.enrollHardwareHint,
                        style: theme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
