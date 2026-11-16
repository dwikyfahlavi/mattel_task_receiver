import 'package:ui_kit/ui_kit.dart';

import '../../../data/task_dtos.dart';
import '../bloc/history_bloc.dart';

HistoryStatus historyStatusOf(WorkOrderDisplayStatus s) => switch (s) {
  WorkOrderDisplayStatus.waiting => HistoryStatus.waiting,
  WorkOrderDisplayStatus.inProgress => HistoryStatus.inProgress,
  WorkOrderDisplayStatus.completed => HistoryStatus.done,
  WorkOrderDisplayStatus.cancelled => HistoryStatus.cancelled,
  WorkOrderDisplayStatus.declined ||
  WorkOrderDisplayStatus.unknown => HistoryStatus.missed,
};

/// Second line of a history item: the reason for missed items (doc 3.1).
/// The backend does not tell decline, auto-decline and cancel apart here.
String? historyReasonText(AppLocalizations l10n, WorkOrderDto item) =>
    switch (item.displayStatus) {
      WorkOrderDisplayStatus.declined => l10n.historyReasonDeclined,
      WorkOrderDisplayStatus.cancelled => l10n.historyReasonCancelled,
      _ => null,
    };

String historyFilterLabel(AppLocalizations l10n, HistoryFilter f) =>
    switch (f) {
      HistoryFilter.all => l10n.historyFilterAll,
      HistoryFilter.inProgress => l10n.historyInProgress,
      HistoryFilter.completed => l10n.historyDone,
      HistoryFilter.declined => l10n.historyMissed,
      HistoryFilter.cancelled => l10n.historyCancelled,
    };
