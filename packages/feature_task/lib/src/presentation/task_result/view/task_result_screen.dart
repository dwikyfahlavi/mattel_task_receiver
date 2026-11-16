import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../task_session/bloc/task_session_bloc.dart';

/// Result and missed-task explanations (doc 10.3, A.3/A.5). Uses the
/// Unavailable variant only (A.7 #4).
class TaskResultScreen extends StatelessWidget {
  const TaskResultScreen({
    required this.outcome,
    required this.userFirstName,
    required this.onCheckIn,
    super.key,
  });

  final TaskOutcome outcome;
  final String userFirstName;

  /// Runs Check In (readiness check included) and then closes the result.
  final VoidCallback onCheckIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final task = outcome.task;
    final (kind, title, body) = _copy(l10n);
    final unavailable = outcome.reason.makesUnavailable;
    final tablet = context.isTablet;
    void close() =>
        context.read<TaskSessionBloc>().add(const TaskResultClosed());

    final checkIn = AppButton(
      label: l10n.checkInButton,
      trailing: const StatusBadge(available: false),
      onPressed: () {
        close();
        onCheckIn();
      },
    );
    final back = AppButton(
      label: l10n.actionBackToHome,
      variant: AppButtonVariant.secondary,
      onPressed: close,
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) close();
      },
      child: Scaffold(
        backgroundColor: context.isWatch ? null : c.scrim,
        body: SafeArea(
          child: ModalCard(
            child: Column(
              mainAxisSize: context.isWatch
                  ? MainAxisSize.max
                  : MainAxisSize.min,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ResultIcon(kind: kind),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          style: theme.headlineSmall,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          body,
                          style: theme.bodyMedium?.copyWith(color: c.textMuted),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        // Machine, location and issue always in full (doc 10.3).
                        MachineCard(
                          machineCode: task.machineCode,
                          trailing: ProblemTag(label: task.issue),
                        ),
                        const SizedBox(height: 8),
                        InfoRow(
                          kind: InfoRowKind.location,
                          label: l10n.taskLocation(task.location),
                        ),
                        if (unavailable && !context.isWatch) ...[
                          const SizedBox(height: 12),
                          InfoBox(text: l10n.checkInAgainInfo),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                if (unavailable && tablet)
                  Row(
                    children: [
                      Expanded(child: checkIn),
                      const SizedBox(width: 12),
                      Expanded(child: back),
                    ],
                  )
                else ...[
                  if (unavailable) ...[checkIn, const SizedBox(height: 10)],
                  back,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  (ResultIconKind, String, String) _copy(AppLocalizations l10n) =>
      switch (outcome.reason) {
        ResolutionReason.rejected => (
          ResultIconKind.reassigned,
          l10n.reassignedTitle,
          l10n.reassignedBody(userFirstName),
        ),
        ResolutionReason.lateDelivery => (
          ResultIconKind.timeout,
          l10n.timeoutTitle,
          l10n.lateDeliveryBody,
        ),
        ResolutionReason.offlineMissed => (
          ResultIconKind.offline,
          l10n.offlineMissedTitle,
          l10n.offlineMissedBody,
        ),
        ResolutionReason.cancelled => (
          ResultIconKind.cancelled,
          l10n.cancelledTitle,
          l10n.cancelledBody(userFirstName),
        ),
        _ => (
          ResultIconKind.timeout,
          l10n.timeoutTitle,
          l10n.timeoutBody(userFirstName),
        ),
      };
}
