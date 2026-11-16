// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availability_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CheckInDto _$CheckInDtoFromJson(Map<String, dynamic> json) => _CheckInDto(
  outcome: json['outcome'] as String,
  shift: json['shift'] as String?,
  date: json['date'] as String?,
  checkedInAt: json['checked_in_at'] == null
      ? null
      : DateTime.parse(json['checked_in_at'] as String),
);

Map<String, dynamic> _$CheckInDtoToJson(_CheckInDto instance) =>
    <String, dynamic>{
      'outcome': instance.outcome,
      'shift': ?instance.shift,
      'date': ?instance.date,
      'checked_in_at': ?instance.checkedInAt?.toIso8601String(),
    };

_CheckOutDto _$CheckOutDtoFromJson(Map<String, dynamic> json) => _CheckOutDto(
  outcome: json['outcome'] as String,
  shift: json['shift'] as String?,
  checkedInAt: json['checked_in_at'] == null
      ? null
      : DateTime.parse(json['checked_in_at'] as String),
);

Map<String, dynamic> _$CheckOutDtoToJson(_CheckOutDto instance) =>
    <String, dynamic>{
      'outcome': instance.outcome,
      'shift': ?instance.shift,
      'checked_in_at': ?instance.checkedInAt?.toIso8601String(),
    };

_AttendanceDto _$AttendanceDtoFromJson(Map<String, dynamic> json) =>
    _AttendanceDto(
      id: json['id'] as String,
      date: json['date'] as String,
      shift: json['shift'] as String?,
      status: json['status'] as String? ?? 'CLOSED',
      checkedInAt: json['checked_in_at'] == null
          ? null
          : DateTime.parse(json['checked_in_at'] as String),
      checkedOutAt: json['checked_out_at'] == null
          ? null
          : DateTime.parse(json['checked_out_at'] as String),
      workedMinutes: (json['worked_minutes'] as num?)?.toInt(),
      isAvailable: json['is_available'] as bool? ?? false,
      isOnBreak: json['is_on_break'] as bool? ?? false,
    );

Map<String, dynamic> _$AttendanceDtoToJson(_AttendanceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'shift': ?instance.shift,
      'status': instance.status,
      'checked_in_at': ?instance.checkedInAt?.toIso8601String(),
      'checked_out_at': ?instance.checkedOutAt?.toIso8601String(),
      'worked_minutes': ?instance.workedMinutes,
      'is_available': instance.isAvailable,
      'is_on_break': instance.isOnBreak,
    };

_AttendancePageDto _$AttendancePageDtoFromJson(Map<String, dynamic> json) =>
    _AttendancePageDto(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => AttendanceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <AttendanceDto>[],
      pagination: json['pagination'] == null
          ? const PaginationDto()
          : PaginationDto.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AttendancePageDtoToJson(_AttendancePageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };
