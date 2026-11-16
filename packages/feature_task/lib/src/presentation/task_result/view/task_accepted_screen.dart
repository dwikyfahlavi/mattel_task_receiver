import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../task_session/bloc/task_session_bloc.dart';

/// "Penugasan Diterima!" (A.5 steps 1 and 2 on phone/tablet, single step
/// on the watch, A.7 #8).
class TaskAcceptedScreen extends StatefulWidget {
  const TaskAcceptedScreen({
    required this.task,
    required this.acceptedAt,
    super.key,
  });

  final TaskAssignment task;
  final DateTime acceptedAt;

  @override
  State<TaskAcceptedScreen> createState() => _TaskAcceptedScreenState();
}

class _TaskAcceptedScreenState extends State<TaskAcceptedScreen> {
  bool _details = false;

  void _close() =>
      context.read<TaskSessionBloc>().add(const TaskAcceptedScreenClosed());

  @override
  Widget build(BuildContext context) {
    final showDetails = _details || context.isWatch;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _close();
      },
      child: Scaffold(
        backgroundColor: context.isWatch ? null : AppColors.of(context).scrim,
        body: SafeArea(
          child: ModalCard(
            child: showDetails
                ? _AcceptedDetails(
                    task: widget.task,
                    acceptedAt: widget.acceptedAt,
                    onClose: _close,
                  )
                : _AcceptedIntro(
                    onContinue: () => setState(() => _details = true),
                  ),
          ),
        ),
      ),
    );
  }
}

class _AcceptedIntro extends StatelessWidget {
  const _AcceptedIntro({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const ResultIcon(kind: ResultIconKind.success),
        const SizedBox(height: 16),
        Text(
          l10n.acceptedTitle,
          style: theme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          l10n.acceptedSubtitle,
          style: theme.bodyMedium?.copyWith(
            color: AppColors.of(context).textMuted,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        AppButton(label: l10n.actionContinue, onPressed: onContinue),
      ],
    );
  }
}

class _AcceptedDetails extends StatelessWidget {
  const _AcceptedDetails({
    required this.task,
    required this.acceptedAt,
    required this.onClose,
  });

  final TaskAssignment task;
  final DateTime acceptedAt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final clock = context.read<AppClock>();
    final watch = context.isWatch;
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (watch) ...[
              const ResultIcon(kind: ResultIconKind.success),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.acceptedTitle, style: theme.titleLarge),
                  if (!watch)
                    Text(l10n.acceptedDetailSubtitle, style: theme.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        MachineCard(machineCode: task.machineCode),
        const SizedBox(height: 10),
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
        if (!watch) ...[
          const SizedBox(height: 12),
          InfoBox(text: l10n.acceptedInfo),
        ],
      ],
    );
    return Column(
      mainAxisSize: watch ? MainAxisSize.max : MainAxisSize.min,
      children: [
        Flexible(child: SingleChildScrollView(child: body)),
        const SizedBox(height: 12),
        AppButton(label: l10n.actionBackToHome, onPressed: onClose),
      ],
    );
  }
}
