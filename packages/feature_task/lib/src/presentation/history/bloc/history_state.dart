part of 'history_bloc.dart';

/// Filter chips of "Riwayat Penugasan", mapped to `display_status`.
enum HistoryFilter {
  all({}),
  inProgress({
    WorkOrderDisplayStatus.inProgress,
    WorkOrderDisplayStatus.waiting,
  }),
  completed({WorkOrderDisplayStatus.completed}),
  declined({WorkOrderDisplayStatus.declined}),
  cancelled({WorkOrderDisplayStatus.cancelled});

  const HistoryFilter(this.statuses);
  final Set<WorkOrderDisplayStatus> statuses;
}

@freezed
abstract class HistoryState with _$HistoryState {
  const HistoryState._();

  const factory HistoryState({
    @Default(<WorkOrderDto>[]) List<WorkOrderDto> items,
    @Default(HistoryFilter.all) HistoryFilter filter,
    @Default(true) bool loading,
    @Default(false) bool loadingMore,

    /// Last page loaded (1-based); 0 before the first load.
    @Default(0) int page,
    @Default(false) bool hasMore,
    Failure? error,
  }) = _HistoryState;
}
