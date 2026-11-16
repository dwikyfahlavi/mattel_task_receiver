import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/availability_dtos.dart';
import '../../../data/availability_repository.dart';

part 'attendance_cubit.freezed.dart';
part 'attendance_state.dart';

/// "Riwayat Kehadiran": one row per shift, newest first, paged.
/// Screen-scoped.
class AttendanceCubit extends Cubit<AttendanceState> {
  AttendanceCubit(this._repo) : super(const AttendanceState());

  final AvailabilityRepository _repo;
  int _generation = 0;

  Future<void> refresh() async {
    final generation = ++_generation;
    emit(state.copyWith(loading: true, error: null));
    final r = await _repo.attendance();
    if (isClosed || generation != _generation) return;
    emit(
      r.fold(
        (page) => AttendanceState(
          items: page.items,
          loading: false,
          page: page.pagination.page,
          hasMore: page.pagination.hasMore,
        ),
        (f) => state.copyWith(loading: false, error: f),
      ),
    );
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.loading || state.loadingMore) return;
    final generation = _generation;
    emit(state.copyWith(loadingMore: true));
    final r = await _repo.attendance(page: state.page + 1);
    if (isClosed || generation != _generation) return;
    emit(
      r.fold(
        (page) => state.copyWith(
          items: [
            ...state.items,
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
