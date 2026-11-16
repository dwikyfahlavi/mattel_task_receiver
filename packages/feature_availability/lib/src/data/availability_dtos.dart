import 'package:feature_task/feature_task.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'availability_dtos.freezed.dart';
part 'availability_dtos.g.dart';

/// `POST /technicians/me/check-in`: `CHECKED_IN`, `RESUMED` (checked out
/// earlier in this shift) or `ALREADY_CHECKED_IN`.
@freezed
abstract class CheckInDto with _$CheckInDto {
  const factory CheckInDto({
    required String outcome,
    String? shift,
    String? date,
    DateTime? checkedInAt,
  }) = _CheckInDto;

  factory CheckInDto.fromJson(Map<String, dynamic> json) =>
      _$CheckInDtoFromJson(json);
}

/// `POST /technicians/me/check-out`: `CHECKED_OUT` or `NOT_CHECKED_IN`.
/// Attendance only: it never ends a session.
@freezed
abstract class CheckOutDto with _$CheckOutDto {
  const factory CheckOutDto({
    required String outcome,
    String? shift,
    DateTime? checkedInAt,
  }) = _CheckOutDto;

  factory CheckOutDto.fromJson(Map<String, dynamic> json) =>
      _$CheckOutDtoFromJson(json);
}

/// One row per shift (`GET /technicians/me/attendance`).
@freezed
abstract class AttendanceDto with _$AttendanceDto {
  const AttendanceDto._();

  const factory AttendanceDto({
    required String id,

    /// `YYYY-MM-DD`, the shift date.
    required String date,
    String? shift,

    /// `OPEN` while still checked in, else `CLOSED`.
    @Default('CLOSED') String status,
    DateTime? checkedInAt,
    DateTime? checkedOutAt,
    int? workedMinutes,
    @Default(false) bool isAvailable,
    @Default(false) bool isOnBreak,
  }) = _AttendanceDto;

  factory AttendanceDto.fromJson(Map<String, dynamic> json) =>
      _$AttendanceDtoFromJson(json);

  bool get isOpen => status == 'OPEN';
}

@freezed
abstract class AttendancePageDto with _$AttendancePageDto {
  const factory AttendancePageDto({
    @Default(<AttendanceDto>[]) List<AttendanceDto> items,
    @Default(PaginationDto()) PaginationDto pagination,
  }) = _AttendancePageDto;

  factory AttendancePageDto.fromJson(Map<String, dynamic> json) =>
      _$AttendancePageDtoFromJson(json);
}
