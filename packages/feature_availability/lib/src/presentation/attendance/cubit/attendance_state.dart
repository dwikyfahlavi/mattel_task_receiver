part of 'attendance_cubit.dart';

@freezed
abstract class AttendanceState with _$AttendanceState {
  const factory AttendanceState({
    @Default(<AttendanceDto>[]) List<AttendanceDto> items,
    @Default(true) bool loading,
    @Default(false) bool loadingMore,
    @Default(0) int page,
    @Default(false) bool hasMore,
    Failure? error,
  }) = _AttendanceState;
}
