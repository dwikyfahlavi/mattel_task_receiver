part of 'history_bloc.dart';

sealed class HistoryEvent {
  const HistoryEvent();
}

/// First load, pull-to-refresh and retry.
final class HistoryRefreshed extends HistoryEvent {
  const HistoryRefreshed();
}

/// Scrolled near the end.
final class HistoryMoreRequested extends HistoryEvent {
  const HistoryMoreRequested();
}

/// A filter chip was tapped.
final class HistoryFilterChanged extends HistoryEvent {
  const HistoryFilterChanged(this.filter);
  final HistoryFilter filter;
}
