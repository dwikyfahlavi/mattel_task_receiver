// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskAssignment _$TaskAssignmentFromJson(Map<String, dynamic> json) =>
    _TaskAssignment(
      taskId: json['task_id'] as String,
      requestId: json['request_id'] as String?,
      machineCode: json['machine_code'] as String,
      location: json['location'] as String? ?? '',
      issue: json['issue'] as String? ?? '',
      shift: json['shift'] as String?,
      assignedAt: DateTime.parse(json['assigned_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$TaskAssignmentToJson(_TaskAssignment instance) =>
    <String, dynamic>{
      'task_id': instance.taskId,
      'request_id': ?instance.requestId,
      'machine_code': instance.machineCode,
      'location': instance.location,
      'issue': instance.issue,
      'shift': ?instance.shift,
      'assigned_at': instance.assignedAt.toIso8601String(),
      'expires_at': instance.expiresAt.toIso8601String(),
    };

_TaskOutcome _$TaskOutcomeFromJson(Map<String, dynamic> json) => _TaskOutcome(
  task: TaskAssignment.fromJson(json['task'] as Map<String, dynamic>),
  reason: $enumDecode(_$ResolutionReasonEnumMap, json['reason']),
);

Map<String, dynamic> _$TaskOutcomeToJson(_TaskOutcome instance) =>
    <String, dynamic>{
      'task': instance.task.toJson(),
      'reason': _$ResolutionReasonEnumMap[instance.reason]!,
    };

const _$ResolutionReasonEnumMap = {
  ResolutionReason.timeout: 'timeout',
  ResolutionReason.rejected: 'rejected',
  ResolutionReason.lateDelivery: 'late_delivery',
  ResolutionReason.offlineMissed: 'offline_missed',
  ResolutionReason.takenByOtherDevice: 'taken_by_other_device',
  ResolutionReason.cancelled: 'cancelled',
  ResolutionReason.accepted: 'accepted',
  ResolutionReason.completed: 'completed',
  ResolutionReason.unknown: 'unknown',
};
