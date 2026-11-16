import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/task_dtos.dart';
import '../../../data/task_repository.dart';

part 'history_bloc.freezed.dart';
part 'history_event.dart';
part 'history_state.dart';

/// Paged "My jobs" (`page` / `perPage`, newest first, doc 18 "Lists").
/// Screen-scoped. A refresh or a filter change cancels a load in flight.
class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc(this._repo) : super(const HistoryState()) {
    on<HistoryRefreshed>(
      (_, emit) => _loadFirst(emit, state.filter),
      transformer: restartable(),
    );
    on<HistoryFilterChanged>(
      (e, emit) => _loadFirst(emit, e.filter),
      transformer: restartable(),
    );
    on<HistoryMoreRequested>(_onMore, transformer: droppable());
  }

  final TaskRepository _repo;

  Future<void> _loadFirst(
    Emitter<HistoryState> emit,
    HistoryFilter filter,
  ) async {
    emit(
      state.copyWith(
        filter: filter,
        loading: true,
        error: null,
        // A different filter must not show the previous filter's items.
        items: filter == state.filter ? state.items : const [],
      ),
    );
    final r = await _repo.history(statuses: filter.statuses);
    emit(
      r.fold(
        (page) => HistoryState(
          items: page.items,
          filter: filter,
          loading: false,
          page: page.pagination.page,
          hasMore: page.pagination.hasMore,
        ),
        (f) => state.copyWith(loading: false, error: f),
      ),
    );
  }

  Future<void> _onMore(
    HistoryMoreRequested e,
    Emitter<HistoryState> emit,
  ) async {
    if (!state.hasMore || state.loading || state.loadingMore) return;
    final filter = state.filter;
    emit(state.copyWith(loadingMore: true));
    final r = await _repo.history(
      page: state.page + 1,
      statuses: filter.statuses,
    );
    if (state.filter != filter) return; // filter changed meanwhile
    emit(
      r.fold(
        (page) => state.copyWith(
          items: [
            ...state.items,
            // A job can move between pages while paging; never show it twice.
            ...page.items.where((n) => !state.items.any((o) => o.id == n.id)),
          ],
          page: page.pagination.page,
          hasMore: page.pagination.hasMore,
          loadingMore: false,
        ),
        (f) => state.copyWith(loadingMore: false, error: f),
      ),
    );
  }
}
