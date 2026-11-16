// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MachineDto _$MachineDtoFromJson(Map<String, dynamic> json) => _MachineDto(
  id: json['id'] as String,
  cellPosition: json['cell_position'] as String?,
  type: json['type'] as String?,
);

Map<String, dynamic> _$MachineDtoToJson(_MachineDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cell_position': ?instance.cellPosition,
      'type': ?instance.type,
    };

_RepairDto _$RepairDtoFromJson(Map<String, dynamic> json) => _RepairDto(
  reason: json['reason'] as String?,
  problemStartedAt: json['problem_started_at'] == null
      ? null
      : DateTime.parse(json['problem_started_at'] as String),
  actionStartedAt: json['action_started_at'] == null
      ? null
      : DateTime.parse(json['action_started_at'] as String),
  finishedAt: json['finished_at'] == null
      ? null
      : DateTime.parse(json['finished_at'] as String),
);

Map<String, dynamic> _$RepairDtoToJson(_RepairDto instance) =>
    <String, dynamic>{
      'reason': ?instance.reason,
      'problem_started_at': ?instance.problemStartedAt?.toIso8601String(),
      'action_started_at': ?instance.actionStartedAt?.toIso8601String(),
      'finished_at': ?instance.finishedAt?.toIso8601String(),
    };

_WorkOrderDto _$WorkOrderDtoFromJson(Map<String, dynamic> json) =>
    _WorkOrderDto(
      id: json['id'] as String,
      requestId: json['request_id'] as String?,
      status: json['status'] as String?,
      shift: json['shift'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      respondBy: json['respond_by'] == null
          ? null
          : DateTime.parse(json['respond_by'] as String),
      machine: MachineDto.fromJson(json['machine'] as Map<String, dynamic>),
      issue: json['issue'] as String? ?? '',
      issueAction: json['issue_action'] as String?,
      repairId: json['repair_id'] as String?,
      displayStatus:
          $enumDecodeNullable(
            _$WorkOrderDisplayStatusEnumMap,
            json['display_status'],
            unknownValue: WorkOrderDisplayStatus.unknown,
          ) ??
          WorkOrderDisplayStatus.unknown,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      repair: json['repair'] == null
          ? null
          : RepairDto.fromJson(json['repair'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkOrderDtoToJson(
  _WorkOrderDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'request_id': ?instance.requestId,
  'status': ?instance.status,
  'shift': ?instance.shift,
  'created_at': instance.createdAt.toIso8601String(),
  'respond_by': ?instance.respondBy?.toIso8601String(),
  'machine': instance.machine.toJson(),
  'issue': instance.issue,
  'issue_action': ?instance.issueAction,
  'repair_id': ?instance.repairId,
  'display_status': _$WorkOrderDisplayStatusEnumMap[instance.displayStatus]!,
  'updated_at': ?instance.updatedAt?.toIso8601String(),
  'repair': ?instance.repair?.toJson(),
};

const _$WorkOrderDisplayStatusEnumMap = {
  WorkOrderDisplayStatus.waiting: 'WAITING',
  WorkOrderDisplayStatus.inProgress: 'IN_PROGRESS',
  WorkOrderDisplayStatus.completed: 'COMPLETED',
  WorkOrderDisplayStatus.cancelled: 'CANCELLED',
  WorkOrderDisplayStatus.declined: 'DECLINED',
  WorkOrderDisplayStatus.unknown: 'UNKNOWN',
};

_PaginationDto _$PaginationDtoFromJson(Map<String, dynamic> json) =>
    _PaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      perPage: (json['per_page'] as num?)?.toInt() ?? 20,
      totalData: (json['total_data'] as num?)?.toInt() ?? 0,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$PaginationDtoToJson(_PaginationDto instance) =>
    <String, dynamic>{
      'page': instance.page,
      'per_page': instance.perPage,
      'total_data': instance.totalData,
      'total_pages': instance.totalPages,
    };

_WorkOrderPageDto _$WorkOrderPageDtoFromJson(Map<String, dynamic> json) =>
    _WorkOrderPageDto(
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => WorkOrderDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <WorkOrderDto>[],
      pagination: json['pagination'] == null
          ? const PaginationDto()
          : PaginationDto.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WorkOrderPageDtoToJson(_WorkOrderPageDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'pagination': instance.pagination.toJson(),
    };
