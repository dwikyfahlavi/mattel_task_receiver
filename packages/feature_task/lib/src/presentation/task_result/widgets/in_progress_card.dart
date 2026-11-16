import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

/// Home card while a job is In Progress (A.7 #2).
///
/// There is no Selesai: the job ends when the repair is recorded as
/// finished (D-22). [onCancel] gives the job up after something unforeseen
/// (backend "cancel"), which also checks the technician out.
class InProgressCard extends StatelessWidget {
  const InProgressCard({
    required this.task,
    required this.acceptedAt,
    this.onCancel,
    this.cancelling = false,
    super.key,
  });

  final TaskAssignment task;
  final DateTime acceptedAt;

  /// Null hides the button (the watch pins it at the bottom).
  final VoidCallback? onCancel;
  final bool cancelling;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final clock = context.read<AppClock>();
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: c.primary.withValues(alpha: 0.35)),
        borderRadius: BorderRadius.circular(AppShape.cardRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.inProgressTitle,
            style: theme.titleMedium?.copyWith(color: c.primary),
          ),
          Text(l10n.inProgressBody, style: theme.bodySmall),
          const SizedBox(height: 10),
          MachineCard(machineCode: task.machineCode),
          const SizedBox(height: 8),
          InfoRow(
            kind: InfoRowKind.location,
            label: l10n.taskLocation(task.location),
          ),
          const SizedBox(height: 6),
          InfoRow(kind: InfoRowKind.problem, label: task.issue),
          const SizedBox(height: 6),
          InfoRow(
            kind: InfoRowKind.time,
            label: l10n.acceptedTime,
            detail: clock.formatDateTime(acceptedAt),
          ),
          if (onCancel != null) ...[
            const SizedBox(height: 12),
            AppButton(
              label: l10n.cancelTaskButton,
              variant: AppButtonVariant.outlined,
              loading: cancelling,
              onPressed: cancelling ? null : onCancel,
            ),
          ],
        ],
      ),
    );
  }
}

/// Confirms "Batalkan Penugasan". Returns true when the user confirmed.
Future<bool> confirmCancelTask(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return showConfirmDialog(
    context,
    title: l10n.cancelTaskConfirmTitle,
    body: l10n.cancelTaskConfirmBody,
    confirmLabel: l10n.cancelTaskButton,
  );
}
