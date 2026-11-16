import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../data/task_dtos.dart';
import '../../../data/task_repository.dart';
import '../../history/view/history_labels.dart';
import '../cubit/work_order_detail_cubit.dart';

/// One work order: machine, location, issue, how it ended and the repair
/// times (backend "One job"). Same card style as the result screens.
class WorkOrderDetailScreen extends StatelessWidget {
  const WorkOrderDetailScreen({
    required this.repository,
    required this.workOrderId,
    required this.onBack,
    super.key,
  });

  final TaskRepository repository;
  final String workOrderId;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => WorkOrderDetailCubit(repository, workOrderId)..load(),
    child: _DetailView(onBack: onBack),
  );
}

class _DetailView extends StatelessWidget {
  const _DetailView({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: onBack,
        ),
        title: Text(l10n.workOrderDetailTitle),
      ),
      body: MaxWidth(
        maxWidth: 640,
        child: BlocBuilder<WorkOrderDetailCubit, WorkOrderDetailState>(
          builder: (context, state) => switch (state) {
            WorkOrderDetailLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            WorkOrderDetailFailed(:final failure) => _Failed(
              text:
                  failure is ApiFailure &&
                      failure.hasCode(ApiErrorCode.workOrderNotFound)
                  ? l10n.workOrderNotFound
                  : failureText(l10n, failure),
              onRetry: context.read<WorkOrderDetailCubit>().load,
            ),
            WorkOrderDetailLoaded(:final workOrder) => _Content(
              workOrder: workOrder,
            ),
          },
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({required this.workOrder});

  final WorkOrderDto workOrder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final c = AppColors.of(context);
    final clock = context.read<AppClock>();
    final wo = workOrder;
    final repair = wo.repair;
    String? at(DateTime? t) => t == null ? null : clock.formatDateTime(t);

    final rows = <(String, String?)>[
      (l10n.detailRequestId, wo.requestId),
      (l10n.detailShift, wo.shift),
      (l10n.detailMachineType, wo.machine.type),
      (l10n.detailCreatedAt, at(wo.createdAt)),
      (l10n.detailProblemStarted, at(repair?.problemStartedAt)),
      (l10n.detailActionStarted, at(repair?.actionStartedAt)),
      (l10n.detailFinishedAt, at(repair?.finishedAt)),
      (l10n.detailRepairReason, repair?.reason),
      (l10n.detailAction, wo.issueAction),
    ].where((r) => r.$2 != null && r.$2!.isNotEmpty).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                wo.requestId ?? wo.machine.id,
                style: theme.titleLarge,
              ),
            ),
            _StatusPill(status: historyStatusOf(wo.displayStatus)),
          ],
        ),
        const SizedBox(height: 12),
        MachineCard(
          machineCode: wo.machine.id,
          trailing: wo.issue.isEmpty ? null : ProblemTag(label: wo.issue),
        ),
        if (wo.machine.cellPosition != null) ...[
          const SizedBox(height: 8),
          InfoRow(
            kind: InfoRowKind.location,
            label: l10n.taskLocation(wo.machine.cellPosition!),
          ),
        ],
        const SizedBox(height: 16),
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: c.border),
            borderRadius: BorderRadius.circular(AppShape.cardRadius),
          ),
          child: Column(
            children: [
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) Divider(height: 1, color: c.border),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          rows[i].$1,
                          style: theme.bodySmall?.copyWith(color: c.textMuted),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 3,
                        child: Text(rows[i].$2!, style: theme.bodyMedium),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final HistoryStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, label) = historyStatusStyle(context, status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.text, required this.onRetry});

  final String text;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          AppButton(
            label: AppLocalizations.of(context).actionRetry,
            variant: AppButtonVariant.secondary,
            expand: false,
            onPressed: onRetry,
          ),
        ],
      ),
    ),
  );
}
