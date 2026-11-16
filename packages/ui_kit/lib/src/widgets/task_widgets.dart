import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../l10n/generated/app_localizations.dart';
import '../layout/device_profile.dart';

/// Black pill with a timer and `00:59`; red in the last 10 seconds (A.2).
/// Stateless: the countdown cubit wraps it so only this widget rebuilds.
class CountdownChip extends StatelessWidget {
  const CountdownChip({required this.seconds, super.key});

  final int seconds;

  static const urgentThreshold = 10;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final urgent = seconds <= urgentThreshold;
    final s = seconds.clamp(0, 99);
    final label = '00:${s.toString().padLeft(2, '0')}';
    return Semantics(
      label: AppLocalizations.of(context).taskCountdownLabel(s),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: urgent ? c.danger : c.text,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.timer, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bordered card with a blue icon tile and the machine code (A.2).
class MachineCard extends StatelessWidget {
  const MachineCard({required this.machineCode, this.trailing, super.key});

  final String machineCode;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(AppShape.cardRadius),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: c.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.cpu, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          // Never truncate critical text (doc 15 watch rule 4).
          Expanded(
            child: Text(
              machineCode,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            // Wraps instead of overflowing on narrow screens.
            Flexible(child: trailing!),
          ],
        ],
      ),
    );
  }
}

/// Problem tag shown at the right of the machine row on result screens.
class ProblemTag extends StatelessWidget {
  const ProblemTag({required this.label, super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.dangerSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: c.danger),
      ),
    );
  }
}

enum InfoRowKind { location, problem, time }

/// Icon + label: location (blue), problem (red), time (black) (A.2).
class InfoRow extends StatelessWidget {
  const InfoRow({
    required this.kind,
    required this.label,
    this.detail,
    super.key,
  });

  final InfoRowKind kind;
  final String label;
  final String? detail;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final (icon, color) = switch (kind) {
      InfoRowKind.location => (LucideIcons.mapPin, c.primary),
      InfoRowKind.problem => (LucideIcons.circleAlert, c.danger),
      InfoRowKind.time => (LucideIcons.clock, c.text),
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (detail != null) Text(detail!, style: theme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}

/// Blue instruction box (A.2).
class InfoBox extends StatelessWidget {
  const InfoBox({required this.text, this.showIcon = true, super.key});

  final String text;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.infoSurface,
        borderRadius: BorderRadius.circular(AppShape.buttonRadius),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Icon(LucideIcons.info, color: c.primary, size: 16),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: c.primary),
            ),
          ),
        ],
      ),
    );
  }
}

enum ResultIconKind { success, reassigned, timeout, cancelled, offline }

/// Large circle icon used on result screens (A.2).
class ResultIcon extends StatelessWidget {
  const ResultIcon({required this.kind, super.key});

  final ResultIconKind kind;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final watch = context.isWatch;
    final (icon, fg, bg) = switch (kind) {
      ResultIconKind.success => (
        LucideIcons.check,
        c.success,
        c.successSurface,
      ),
      ResultIconKind.reassigned => (
        LucideIcons.refreshCw,
        c.danger,
        c.dangerSurface,
      ),
      ResultIconKind.timeout => (LucideIcons.timer, c.danger, c.dangerSurface),
      ResultIconKind.cancelled => (
        LucideIcons.circleX,
        c.danger,
        c.dangerSurface,
      ),
      ResultIconKind.offline => (
        LucideIcons.wifiOff,
        c.danger,
        c.dangerSurface,
      ),
    };
    final size = watch ? 56.0 : 72.0;
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, color: fg, size: size * 0.5),
      ),
    );
  }
}

/// Centered card used for popups and result dialogs. Max width on tablets
/// (A.6), full width on phones, edge-to-edge on the watch.
class ModalCard extends StatelessWidget {
  const ModalCard({required this.child, this.padding, super.key});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final ff = context.formFactor;
    final card = Material(
      color: c.surface,
      elevation: ff == FormFactor.watch ? 0 : 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(
        ff == FormFactor.watch ? 0 : AppShape.dialogRadius,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.all(ff == FormFactor.watch ? 12 : 20),
        child: child,
      ),
    );
    if (ff == FormFactor.watch) return card;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: ff == FormFactor.tablet
                ? AppShape.tabletDialogMaxWidth
                : 560,
          ),
          child: card,
        ),
      ),
    );
  }
}

/// "Tolak Penugasan?" style confirmation (A.2). Returns true on confirm.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  String? cancelLabel,
}) async {
  final l10n = AppLocalizations.of(context);
  final c = AppColors.of(context);
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    barrierColor: c.scrim,
    builder: (dialogContext) {
      final watch = dialogContext.isWatch;
      final confirm = _DialogButton(
        label: confirmLabel,
        color: c.danger,
        foreground: Colors.white,
        onTap: () => Navigator.of(dialogContext).pop(true),
      );
      final cancel = _DialogButton(
        label: cancelLabel ?? l10n.actionCancel,
        color: c.surfaceMuted,
        foreground: c.text,
        onTap: () => Navigator.of(dialogContext).pop(false),
      );
      return Dialog(
        insetPadding: EdgeInsets.all(watch ? 12 : 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: Theme.of(dialogContext).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: Theme.of(dialogContext).textTheme.bodyMedium
                      ?.copyWith(color: c.textMuted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: cancel),
                    const SizedBox(width: 12),
                    Expanded(child: confirm),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
  return result ?? false;
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.color,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: context.isWatch ? AppShape.watchMinTarget : 48,
    ),
    child: TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        backgroundColor: color,
        foregroundColor: foreground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppShape.buttonRadius),
        ),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelLarge),
    ),
  );
}

enum HistoryStatus { waiting, inProgress, done, missed, cancelled }

/// Color and label of a history status (list items, detail pill).
(Color, String) historyStatusStyle(BuildContext context, HistoryStatus s) {
  final c = AppColors.of(context);
  final l10n = AppLocalizations.of(context);
  return switch (s) {
    HistoryStatus.waiting => (c.textMuted, l10n.historyWaiting),
    HistoryStatus.inProgress => (c.primary, l10n.historyInProgress),
    HistoryStatus.done => (c.success, l10n.historyDone),
    HistoryStatus.missed => (c.danger, l10n.historyMissed),
    HistoryStatus.cancelled => (c.textMuted, l10n.historyCancelled),
  };
}

/// One row of "Riwayat Penugasan" (A.2).
class HistoryItem extends StatelessWidget {
  const HistoryItem({
    required this.status,
    required this.title,
    required this.subtitle,
    required this.date,
    this.reason,
    this.onTap,
    super.key,
  });

  final HistoryStatus status;
  final String title;
  final String subtitle;
  final String date;
  final String? reason;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final (color, label) = historyStatusStyle(context, status);
    final icon = switch (status) {
      HistoryStatus.waiting => LucideIcons.clock,
      HistoryStatus.inProgress => LucideIcons.hourglass,
      HistoryStatus.done => LucideIcons.circleCheck,
      HistoryStatus.missed || HistoryStatus.cancelled => LucideIcons.circleX,
    };
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: c.border),
        borderRadius: BorderRadius.circular(AppShape.cardRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppShape.cardRadius),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            // The status column may take at most ~38% so long labels and
            // dates wrap instead of overflowing on the watch.
            builder: (context, box) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.titleMedium),
                      Text(subtitle, style: theme.bodySmall),
                      if (reason != null)
                        Text(
                          reason!,
                          style: theme.bodySmall?.copyWith(color: c.danger),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: box.maxWidth * 0.38),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        label,
                        textAlign: TextAlign.end,
                        style: theme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        textAlign: TextAlign.end,
                        style: theme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
