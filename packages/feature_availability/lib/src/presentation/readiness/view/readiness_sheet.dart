import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

/// Compact checklist shown when Check In is blocked or warned (doc 12).
/// Returns true when the user chose to continue despite warnings.
///
/// [offerCheckIn] is false for the background check (watch start, resume):
/// the sheet then only explains and fixes, it never offers "Tetap Check In".
Future<bool> showReadinessSheet(
  BuildContext context,
  ReadinessReport report, {
  bool offerCheckIn = true,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: context.read<ReadinessService>()),
        RepositoryProvider.value(value: context.read<ReadinessActions>()),
      ],
      child: _ReadinessSheet(initial: report, offerCheckIn: offerCheckIn),
    ),
  );
  return result ?? false;
}

String readinessLabel(AppLocalizations l10n, ReadinessItem item) =>
    switch (item) {
      ReadinessItem.network => l10n.readinessNetwork,
      ReadinessItem.deviceClock => l10n.readinessDeviceClock,
      ReadinessItem.notificationPermission => l10n.readinessNotification,
      ReadinessItem.alertChannel => l10n.readinessAlertChannel,
      ReadinessItem.fullScreenIntent => l10n.readinessFullScreen,
      ReadinessItem.realtime => l10n.readinessRealtime,
      ReadinessItem.playServices => l10n.readinessPlayServices,
      ReadinessItem.batteryOptimization => l10n.readinessBattery,
    };

class _ReadinessSheet extends StatefulWidget {
  const _ReadinessSheet({required this.initial, required this.offerCheckIn});

  final ReadinessReport initial;
  final bool offerCheckIn;

  @override
  State<_ReadinessSheet> createState() => _ReadinessSheetState();
}

class _ReadinessSheetState extends State<_ReadinessSheet>
    with WidgetsBindingObserver {
  late ReadinessReport _report = widget.initial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Settings screens return via resume: re-check then.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _recheck();
  }

  Future<void> _recheck() async {
    final next = await context.read<ReadinessService>().check();
    if (mounted) setState(() => _report = next);
  }

  Future<void> _fix(ReadinessAction action) async {
    final l10n = AppLocalizations.of(context);
    final actions = context.read<ReadinessActions>();
    if (action == ReadinessAction.requestNotificationPermission) {
      // Short explanation before the system dialog (doc 12).
      final ok = await showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(l10n.notificationExplainTitle),
          content: Text(l10n.notificationExplainBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(c, false),
              child: Text(l10n.actionCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(c, true),
              child: Text(l10n.actionAllow),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    await actions.run(action);
    await _recheck();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final blocked = !_report.canCheckIn;
    final canContinue = widget.offerCheckIn && !blocked;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            blocked ? l10n.readinessTitle : l10n.readinessWarnTitle,
            style: theme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            blocked ? l10n.readinessSubtitle : l10n.readinessWarnSubtitle,
            style: theme.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final r in _report.failures)
            ChecklistTile(
              label: readinessLabel(l10n, r.item),
              passed: r.passed,
              blocking: r.severity == ReadinessSeverity.block,
              onFix: r.action == ReadinessAction.none
                  ? null
                  : () => _fix(r.action),
            ),
          if (_report.allPassed)
            ChecklistTile(
              label: l10n.checkInButton,
              passed: true,
              blocking: false,
            ),
          const SizedBox(height: 16),
          if (canContinue)
            AppButton(
              label: l10n.readinessContinue,
              onPressed: () => Navigator.pop(context, true),
            ),
          if (canContinue) const SizedBox(height: 8),
          AppButton(
            label: l10n.actionClose,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
