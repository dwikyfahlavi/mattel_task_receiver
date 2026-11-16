import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_models.freezed.dart';
part 'task_models.g.dart';

/// A work order as the technician sees it (backend `work_order`, sent by
/// `work-order:assigned` and the state snapshot).
///
/// [toJson] / [fromJson] are the app's own storage format (Drift); use
/// [TaskAssignment.fromWorkOrder] for backend payloads.
@freezed
abstract class TaskAssignment with _$TaskAssignment {
  const TaskAssignment._();

  const factory TaskAssignment({
    /// `work_order.id`, used in every action URL.
    required String taskId,

    /// Human id, e.g. `WO-2026-00193`.
    String? requestId,

    /// `machine.id`, e.g. `FAR339`.
    required String machineCode,

    /// `machine.cell_position`, e.g. `B-12`.
    @Default('') String location,

    /// `issue`, e.g. `Changeover`.
    @Default('') String issue,
    String? shift,

    /// `created_at`, server time (UTC).
    required DateTime assignedAt,

    /// `respond_by`, server time (UTC). The countdown is derived from this
    /// (doc 7.3). The server auto-declines a few seconds later.
    required DateTime expiresAt,
  }) = _TaskAssignment;

  factory TaskAssignment.fromJson(Map<String, dynamic> json) =>
      _$TaskAssignmentFromJson(json);

  /// Response window when `respond_by` is missing.
  static const defaultWindow = Duration(seconds: 60);

  /// Parses a backend `work_order`. Returns null when the id, machine or
  /// creation time is missing; never throws.
  static TaskAssignment? fromWorkOrder(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['id'];
    final machine = raw['machine'];
    final machineCode = machine is Map ? machine['id'] : raw['machine_id'];
    final created = _utc(raw['created_at']);
    if (id is! String || id.isEmpty || created == null) return null;
    final location = machine is Map ? machine['cell_position'] : null;
    return TaskAssignment(
      taskId: id,
      requestId: raw['request_id'] as String?,
      machineCode: machineCode is String && machineCode.isNotEmpty
          ? machineCode
          : '-',
      location: location is String && location.isNotEmpty ? location : '-',
      issue: raw['issue'] is String && (raw['issue'] as String).isNotEmpty
          ? raw['issue'] as String
          : '-',
      shift: raw['shift'] as String?,
      assignedAt: created,
      expiresAt: _utc(raw['respond_by']) ?? created.add(defaultWindow),
    );
  }

  static DateTime? _utc(Object? raw) =>
      raw is String ? DateTime.tryParse(raw)?.toUtc() : null;
}

/// Why an assignment ended (doc 10.3). Unknown values map to [unknown].
@JsonEnum(fieldRename: FieldRename.snake)
enum ResolutionReason {
  /// No answer in time (`AUTO_DECLINED`).
  timeout,

  /// This technician declined (`DECLINED`).
  rejected,

  /// The work order arrived after `respond_by`.
  lateDelivery,

  /// The device was offline during the window.
  offlineMissed,

  /// Answered on the technician's other device.
  takenByOtherDevice,

  /// This technician gave up an accepted job (`CANCELLED`).
  cancelled,
  accepted,

  /// The repair was finished (`COMPLETED`).
  completed,
  unknown;

  static ResolutionReason parse(String? raw) => switch (raw) {
    'timeout' => timeout,
    'rejected' => rejected,
    'late_delivery' => lateDelivery,
    'offline_missed' => offlineMissed,
    'taken_by_other_device' => takenByOtherDevice,
    'cancelled' => cancelled,
    'accepted' => accepted,
    'completed' => completed,
    _ => unknown,
  };

  String get wireName => switch (this) {
    timeout => 'timeout',
    rejected => 'rejected',
    lateDelivery => 'late_delivery',
    offlineMissed => 'offline_missed',
    takenByOtherDevice => 'taken_by_other_device',
    cancelled => 'cancelled',
    accepted => 'accepted',
    completed => 'completed',
    unknown => 'unknown',
  };

  /// Decline, cancel and auto-decline check the technician out on the
  /// server: they must check in again (backend guide, part 4 rule 5).
  bool get makesUnavailable =>
      this == timeout ||
      this == rejected ||
      this == lateDelivery ||
      this == offlineMissed ||
      this == cancelled;

  /// Reasons that are dismissed without a result screen.
  bool get isSilent =>
      this == takenByOtherDevice || this == accepted || this == completed;
}

/// A result the user has not seen yet (process killed, screen off, offline).
/// Stored in Drift and shown at the next resume (doc 10.3).
@freezed
abstract class TaskOutcome with _$TaskOutcome {
  const factory TaskOutcome({
    required TaskAssignment task,
    required ResolutionReason reason,
  }) = _TaskOutcome;

  factory TaskOutcome.fromJson(Map<String, dynamic> json) =>
      _$TaskOutcomeFromJson(json);
}
