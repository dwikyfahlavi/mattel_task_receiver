import 'package:meta/meta.dart';

import '../tasks/task_models.dart';

/// Kind of session on the socket (`self.kind`).
enum SessionKind {
  personal,
  shared,
  unpairedDevice,
  unknown;

  static SessionKind parse(Object? raw) => switch (raw) {
    'PERSONAL' => personal,
    'SHARED' => shared,
    'UNPAIRED_DEVICE' => unpairedDevice,
    _ => unknown,
  };
}

DateTime? _utc(Object? raw) =>
    raw is String ? DateTime.tryParse(raw)?.toUtc() : null;

String? _str(Object? raw) => raw is String && raw.isNotEmpty ? raw : null;

/// Who did something (`by`): the technician's phone (`PERSONAL`, no device
/// id), one of their watches (`SHARED`), WhatsApp or the system.
@immutable
class ActorRef {
  const ActorRef({this.source, this.deviceKind, this.deviceId});

  static ActorRef? parse(Object? raw) {
    if (raw is! Map) return null;
    return ActorRef(
      source: _str(raw['source']),
      deviceKind: SessionKind.parse(raw['device_kind']),
      deviceId: _str(raw['device_id']),
    );
  }

  /// `mobile`, `whatsapp` or `system`.
  final String? source;
  final SessionKind? deviceKind;
  final String? deviceId;

  bool get isSystem => source == 'system';
}

/// `status` of the snapshot and of `status:changed`.
@immutable
class TechnicianStatus {
  const TechnicianStatus({
    this.checkedIn = false,
    this.checkedInAt,
    this.isAvailable = false,
    this.isOnBreak = false,
    this.shift,
  });

  static TechnicianStatus? parse(Object? raw) {
    if (raw is! Map) return null;
    return TechnicianStatus(
      checkedIn: raw['checked_in'] == true,
      checkedInAt: _utc(raw['checked_in_at']),
      isAvailable: raw['is_available'] == true,
      isOnBreak: raw['is_on_break'] == true,
      shift: _str(raw['shift']),
    );
  }

  final bool checkedIn;
  final DateTime? checkedInAt;

  /// Checked in and free (no accepted job).
  final bool isAvailable;
  final bool isOnBreak;
  final String? shift;

  @override
  bool operator ==(Object other) =>
      other is TechnicianStatus &&
      other.checkedIn == checkedIn &&
      other.checkedInAt == checkedInAt &&
      other.isAvailable == isAvailable &&
      other.isOnBreak == isOnBreak &&
      other.shift == shift;

  @override
  int get hashCode =>
      Object.hash(checkedIn, checkedInAt, isAvailable, isOnBreak, shift);
}

/// A watch paired to the technician (`paired_watches`, `watch:paired`,
/// `GET /technicians/me/devices`).
@immutable
class PairedWatch {
  const PairedWatch({
    required this.sessionId,
    this.deviceId,
    this.name,
    this.location,
    this.pairedAt,
    this.expiresAt,
  });

  static PairedWatch? parse(Object? raw) {
    if (raw is! Map) return null;
    final sessionId = _str(raw['session_id']);
    if (sessionId == null) return null;
    final device = raw['device'];
    return PairedWatch(
      sessionId: sessionId,
      deviceId: device is Map ? _str(device['id']) : null,
      name: device is Map ? _str(device['name']) : null,
      location: device is Map ? _str(device['location']) : null,
      pairedAt: _utc(raw['paired_at']),
      expiresAt: _utc(raw['expires_at']),
    );
  }

  final String sessionId;
  final String? deviceId;
  final String? name;
  final String? location;
  final DateTime? pairedAt;
  final DateTime? expiresAt;
}

/// `state:snapshot` / `GET /technicians/me/state`: the truth to redraw from
/// on every (re)connect (backend guide, part 4 rule 1).
@immutable
class StateSnapshot {
  const StateSnapshot({
    required this.kind,
    this.technicianId,
    this.sessionId,
    this.deviceId,
    this.status,
    this.pendingWorkOrder,
    this.activeWorkOrder,
    this.activeSince,
    this.pairedWatches = const [],
  });

  static StateSnapshot parse(Object? raw) {
    final map = raw is Map ? raw : const {};
    final self = map['self'];
    final active = map['active_work_order'];
    final watches = map['paired_watches'];
    return StateSnapshot(
      kind: SessionKind.parse(self is Map ? self['kind'] : null),
      technicianId: self is Map && self['technician_id'] is num
          ? (self['technician_id'] as num).toInt()
          : null,
      sessionId: self is Map ? _str(self['session_id']) : null,
      deviceId: self is Map ? _str(self['device_id']) : null,
      status: TechnicianStatus.parse(map['status']),
      pendingWorkOrder: TaskAssignment.fromWorkOrder(map['pending_work_order']),
      activeWorkOrder: TaskAssignment.fromWorkOrder(active),
      activeSince: active is Map
          ? _utc(active['accepted_at']) ?? _utc(active['updated_at'])
          : null,
      pairedWatches: watches is List
          ? watches.map(PairedWatch.parse).whereType<PairedWatch>().toList()
          : const [],
    );
  }

  final SessionKind kind;
  final int? technicianId;
  final String? sessionId;
  final String? deviceId;
  final TechnicianStatus? status;

  /// A job waiting for an answer.
  final TaskAssignment? pendingWorkOrder;

  /// An accepted, unfinished job.
  final TaskAssignment? activeWorkOrder;

  /// When the active job was accepted, when the backend says so.
  final DateTime? activeSince;
  final List<PairedWatch> pairedWatches;
}

/// `reason` of `work-order:updated`.
enum WorkOrderChange {
  accepted,
  declined,
  autoDeclined,
  cancelled,
  completed,
  unknown;

  static WorkOrderChange parse(Object? raw) => switch (raw) {
    'ACCEPTED' => accepted,
    'DECLINED' => declined,
    'AUTO_DECLINED' => autoDeclined,
    'CANCELLED' => cancelled,
    'COMPLETED' || 'REPAIR_FINISHED' => completed,
    _ => unknown,
  };
}
