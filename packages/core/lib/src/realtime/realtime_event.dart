import 'package:meta/meta.dart';

import '../tasks/task_models.dart';
import 'realtime_models.dart';

/// A parsed socket event (backend guide, part 1 step 5). Parsing is tolerant
/// and never throws: malformed payloads become [UnknownRealtimeEvent].
@immutable
sealed class RealtimeEvent {
  const RealtimeEvent();

  static const snapshot = 'state:snapshot';
  static const statusChanged = 'status:changed';
  static const workOrderAssigned = 'work-order:assigned';
  static const workOrderUpdated = 'work-order:updated';
  static const watchPaired = 'watch:paired';
  static const watchUnpaired = 'watch:unpaired';
  static const sessionEnded = 'session:ended';
  static const pairingApproved = 'pairing:approved';

  /// Every event name the app listens to.
  static const names = [
    snapshot,
    statusChanged,
    workOrderAssigned,
    workOrderUpdated,
    watchPaired,
    watchUnpaired,
    sessionEnded,
    pairingApproved,
  ];

  static RealtimeEvent parse(String name, Object? payload) {
    try {
      final map = payload is Map ? payload : const {};
      switch (name) {
        case snapshot:
          return SnapshotReceived(StateSnapshot.parse(payload));
        case statusChanged:
          final status = TechnicianStatus.parse(map['status']);
          if (status == null) return UnknownRealtimeEvent(name);
          return StatusChanged(
            status: status,
            reason: map['reason'] as String?,
            by: ActorRef.parse(map['by']),
            at: _utc(map['at']),
          );
        case workOrderAssigned:
          final task = TaskAssignment.fromWorkOrder(map['work_order']);
          return task == null
              ? UnknownRealtimeEvent(name)
              : WorkOrderAssigned(task);
        case workOrderUpdated:
          final raw = map['work_order'];
          final id = raw is Map ? raw['id'] : null;
          if (id is! String || id.isEmpty) return UnknownRealtimeEvent(name);
          return WorkOrderUpdated(
            workOrderId: id,
            workOrder: TaskAssignment.fromWorkOrder(raw),
            change: WorkOrderChange.parse(map['reason']),
            by: ActorRef.parse(map['by']),
            at: _utc(map['at']),
          );
        case watchPaired:
          final watch = PairedWatch.parse(payload);
          return watch == null
              ? UnknownRealtimeEvent(name)
              : WatchPairedEvent(watch);
        case watchUnpaired:
          final id = map['session_id'];
          return id is String
              ? WatchUnpairedEvent(id, reason: map['reason'] as String?)
              : UnknownRealtimeEvent(name);
        case sessionEnded:
          return SessionEndedEvent(map['reason'] as String?);
        case pairingApproved:
          final id = map['pairing_id'];
          return id is String
              ? PairingApprovedEvent(id)
              : UnknownRealtimeEvent(name);
      }
      return UnknownRealtimeEvent(name);
    } on Object {
      return UnknownRealtimeEvent(name);
    }
  }

  static DateTime? _utc(Object? raw) =>
      raw is String ? DateTime.tryParse(raw)?.toUtc() : null;
}

final class SnapshotReceived extends RealtimeEvent {
  const SnapshotReceived(this.snapshot);
  final StateSnapshot snapshot;
}

final class StatusChanged extends RealtimeEvent {
  const StatusChanged({required this.status, this.reason, this.by, this.at});

  final TechnicianStatus status;

  /// `CHECK_IN`, `CHECK_OUT`, `ACCEPTED`, `DECLINED`, `AUTO_DECLINED`,
  /// `CANCELLED`, `REPAIR_FINISHED`.
  final String? reason;
  final ActorRef? by;
  final DateTime? at;
}

final class WorkOrderAssigned extends RealtimeEvent {
  const WorkOrderAssigned(this.task);
  final TaskAssignment task;
}

final class WorkOrderUpdated extends RealtimeEvent {
  const WorkOrderUpdated({
    required this.workOrderId,
    required this.change,
    this.workOrder,
    this.by,
    this.at,
  });

  final String workOrderId;
  final TaskAssignment? workOrder;
  final WorkOrderChange change;
  final ActorRef? by;
  final DateTime? at;
}

final class WatchPairedEvent extends RealtimeEvent {
  const WatchPairedEvent(this.watch);
  final PairedWatch watch;
}

final class WatchUnpairedEvent extends RealtimeEvent {
  const WatchUnpairedEvent(this.sessionId, {this.reason});
  final String sessionId;
  final String? reason;
}

/// The server ended this session and closes the socket. Do not reconnect
/// with the old token.
final class SessionEndedEvent extends RealtimeEvent {
  const SessionEndedEvent(this.reason);

  /// `LOGOUT`, `CHECK_OUT`, `REPLACED`, `EXPIRED`, `DEVICE_DISABLED`, …
  final String? reason;
}

/// Unpaired watch only: the phone approved this pairing.
final class PairingApprovedEvent extends RealtimeEvent {
  const PairingApprovedEvent(this.pairingId);
  final String pairingId;
}

/// The handshake was refused (`connect_error` "Unauthorized"). The token may
/// be dead, or the watch clock may be off; the session verifies over HTTP.
final class RealtimeAuthRejected extends RealtimeEvent {
  const RealtimeAuthRejected();
}

final class UnknownRealtimeEvent extends RealtimeEvent {
  const UnknownRealtimeEvent(this.name);
  final String name;
}
