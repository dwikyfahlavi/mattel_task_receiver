import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../data/task_dtos.dart';
import '../../../data/task_repository.dart';
import '../bloc/history_bloc.dart';
import 'history_labels.dart';

/// "Riwayat Penugasan" (A.2 / A.3): the technician's work orders, newest
/// first, with status filters and paging (backend "My jobs").
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    required this.repository,
    required this.onBack,
    this.onOpenInProgress,
    this.onOpenDetail,
    super.key,
  });

  final TaskRepository repository;
  final VoidCallback onBack;

  /// Tapping an In Progress item returns to Home, where the running job is.
  final VoidCallback? onOpenInProgress;

  /// Tapping any other item opens its detail.
  final ValueChanged<String>? onOpenDetail;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => HistoryBloc(repository)..add(const HistoryRefreshed()),
    child: _HistoryView(
      onBack: onBack,
      onOpenInProgress: onOpenInProgress,
      onOpenDetail: onOpenDetail,
    ),
  );
}

class _HistoryView extends StatelessWidget {
  const _HistoryView({
    required this.onBack,
    this.onOpenInProgress,
    this.onOpenDetail,
  });

  final VoidCallback onBack;
  final VoidCallback? onOpenInProgress;
  final ValueChanged<String>? onOpenDetail;

  VoidCallback? _tapFor(WorkOrderDto item) {
    if (item.displayStatus == WorkOrderDisplayStatus.inProgress &&
        onOpenInProgress != null) {
      return onOpenInProgress;
    }
    final open = onOpenDetail;
    return open == null ? null : () => open(item.id);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final clock = context.read<AppClock>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: onBack,
        ),
        title: Text(l10n.historyTitle),
      ),
      body: MaxWidth(
        maxWidth: 640,
        child: Column(
          children: [
            const _Filters(),
            Expanded(
              child: BlocBuilder<HistoryBloc, HistoryState>(
                builder: (context, state) {
                  if (state.loading && state.items.isEmpty) {
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: 4,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, _) => const SkeletonBox(),
                    );
                  }
                  if (state.items.isEmpty) {
                    return _Message(
                      text: state.error != null
                          ? l10n.historyLoadFailed
                          : l10n.historyEmpty,
                      onRetry: state.error != null
                          ? () => context.read<HistoryBloc>().add(
                              const HistoryRefreshed(),
                            )
                          : null,
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => context.read<HistoryBloc>().add(
                      const HistoryRefreshed(),
                    ),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (n) {
                        if (n.metrics.extentAfter < 300) {
                          context.read<HistoryBloc>().add(
                            const HistoryMoreRequested(),
                          );
                        }
                        return false;
                      },
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            state.items.length + (state.loadingMore ? 1 : 0),
                        separatorBuilder: (_, _) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          if (i >= state.items.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          final item = state.items[i];
                          return HistoryItem(
                            status: historyStatusOf(item.displayStatus),
                            onTap: _tapFor(item),
                            title: item.machine.id,
                            subtitle: [
                              if (item.machine.cellPosition != null)
                                l10n.taskLocation(item.machine.cellPosition!),
                              if (item.issue.isNotEmpty) item.issue,
                            ].join(' · '),
                            reason: historyReasonText(l10n, item),
                            date: clock.formatDateTime(item.shownAt),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<HistoryBloc, HistoryState>(
      buildWhen: (a, b) => a.filter != b.filter,
      builder: (context, state) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Row(
          children: [
            for (final f in HistoryFilter.values)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(historyFilterLabel(l10n, f)),
                  selected: state.filter == f,
                  onSelected: (_) =>
                      context.read<HistoryBloc>().add(HistoryFilterChanged(f)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            AppButton(
              label: AppLocalizations.of(context).actionRetry,
              variant: AppButtonVariant.secondary,
              expand: false,
              onPressed: onRetry,
            ),
          ],
        ],
      ),
    ),
  );
}
