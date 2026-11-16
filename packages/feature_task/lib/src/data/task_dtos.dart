import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_dtos.freezed.dart';
part 'task_dtos.g.dart';

/// `display_status` of `GET /technicians/me/work-orders` (show this, not the
/// raw `status`).
@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum WorkOrderDisplayStatus {
  /// Asked, not answered yet.
  waiting,

  /// Accepted, repair not finished.
  inProgress,

  /// Repair finished with the technician and their action recorded.
  completed,

  /// Repair finished without a technician or action recorded.
  cancelled,

  /// Declined, auto-declined, or cancelled by the technician.
  declined,
  unknown;

  /// Value of the `status` query filter.
  String get wireName => switch (this) {
    waiting => 'WAITING',
    inProgress => 'IN_PROGRESS',
    completed => 'COMPLETED',
    cancelled => 'CANCELLED',
    declined => 'DECLINED',
    unknown => '',
  };
}

@freezed
abstract class MachineDto with _$MachineDto {
  const factory MachineDto({
    required String id,
    String? cellPosition,

    /// Detail endpoint only.
    String? type,
  }) = _MachineDto;

  factory MachineDto.fromJson(Map<String, dynamic> json) =>
      _$MachineDtoFromJson(json);
}

@freezed
abstract class RepairDto with _$RepairDto {
  const factory RepairDto({
    String? reason,
    DateTime? problemStartedAt,
    DateTime? actionStartedAt,
    DateTime? finishedAt,
  }) = _RepairDto;

  factory RepairDto.fromJson(Map<String, dynamic> json) =>
      _$RepairDtoFromJson(json);
}

/// One item of "My jobs" and the job detail (backend guide, part 1 step 11).
@freezed
abstract class WorkOrderDto with _$WorkOrderDto {
  const WorkOrderDto._();

  const factory WorkOrderDto({
    required String id,
    String? requestId,
    String? status,
    String? shift,
    required DateTime createdAt,
    DateTime? respondBy,
    required MachineDto machine,
    @Default('') String issue,

    /// Detail endpoint only.
    String? issueAction,
    String? repairId,
    @JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown)
    @Default(WorkOrderDisplayStatus.unknown)
    WorkOrderDisplayStatus displayStatus,
    DateTime? updatedAt,
    RepairDto? repair,
  }) = _WorkOrderDto;

  factory WorkOrderDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderDtoFromJson(json);

  /// The time to show in lists: last change, else creation.
  DateTime get shownAt => updatedAt ?? createdAt;
}

/// `pagination` next to `data` in paged lists.
@freezed
abstract class PaginationDto with _$PaginationDto {
  const PaginationDto._();

  const factory PaginationDto({
    @Default(1) int page,
    @Default(20) int perPage,
    @Default(0) int totalData,
    @Default(0) int totalPages,
  }) = _PaginationDto;

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);

  bool get hasMore => page < totalPages;
}

/// A page of work orders (the envelope interceptor puts `data` in `items`).
@freezed
abstract class WorkOrderPageDto with _$WorkOrderPageDto {
  const factory WorkOrderPageDto({
    @Default(<WorkOrderDto>[]) List<WorkOrderDto> items,
    @Default(PaginationDto()) PaginationDto pagination,
  }) = _WorkOrderPageDto;

  factory WorkOrderPageDto.fromJson(Map<String, dynamic> json) =>
      _$WorkOrderPageDtoFromJson(json);
}
