import 'dart:async';

import 'package:core/core.dart';
import 'package:drift/native.dart';

AppDatabase memoryDatabase() => AppDatabase(NativeDatabase.memory());

class FakeAppClock extends AppClock {
  FakeAppClock(this._server);

  DateTime _server;
  Duration _deviceSkew = Duration.zero;

  void advance(Duration d) => _server = _server.add(d);

  /// The user changes the device clock: device time moves, server time and
  /// the countdown must not.
  void changeDeviceClock(Duration by) => _deviceSkew += by;

  @override
  DateTime serverNowUtc() => _server;
  @override
  DateTime deviceNowUtc() => _server.add(_deviceSkew);
  @override
  Duration get serverOffset => -_deviceSkew;
  @override
  bool get hasServerTime => true;
  @override
  void updateServerTime(DateTime serverUtc) => _server = serverUtc;
}

class FakeConnectivity implements ConnectivityService {
  final _c = StreamController<bool>.broadcast();
  bool online = true;

  @override
  bool get isOnline => online;
  @override
  Stream<bool> get onlineChanges => _c.stream;
  @override
  Future<void> start() async {}
  @override
  void reportReachable() {}
  @override
  void reportUnreachable() {}
  @override
  Future<void> dispose() => _c.close();
}

/// FCM: events arrive through [send] like foreground data messages.
class FakePush implements PushService {
  final controller = StreamController<IncomingPush>.broadcast();

  void send(String event, Object? payload) => controller.add(
    IncomingPush(
      PushMessage.parse(PushMessage.encode(event, payload)),
      PushOrigin.foreground,
    ),
  );

  @override
  Stream<IncomingPush> get messages => controller.stream;
  @override
  Stream<String> get tokenRefreshes => const Stream.empty();
  @override
  Future<String?> token() async => 'token';
  @override
  Future<void> deleteToken() async {}
  @override
  Future<IncomingPush?> initialMessage() async => null;
}

/// The socket: events arrive through [send]; [connected] is set by tests.
class FakeRealtime implements RealtimeService {
  final _events = StreamController<RealtimeEvent>.broadcast();
  final _connection = StreamController<bool>.broadcast();
  final acks = <String>[];
  bool connected = false;
  RealtimeMode? _mode;

  void send(String event, Object? payload) =>
      _events.add(RealtimeEvent.parse(event, payload));

  @override
  Stream<RealtimeEvent> get events => _events.stream;
  @override
  Stream<bool> get connectionChanges => _connection.stream;
  @override
  bool get isConnected => connected;
  @override
  RealtimeMode? get mode => _mode;
  @override
  void start(RealtimeMode mode) => _mode = mode;
  @override
  Future<void> stop() async => _mode = null;
  @override
  void reconnectNow() {}
  @override
  Future<bool> ack(String workOrderId) async {
    acks.add(workOrderId);
    return true;
  }

  Future<void> close() async {
    await _events.close();
    await _connection.close();
  }
}

TaskAssignment sampleTask(DateTime assignedAt, {String id = 't-1'}) =>
    TaskAssignment(
      taskId: id,
      requestId: 'WO-2026-00193',
      machineCode: 'FAR339',
      location: 'B-12',
      issue: 'Changeover',
      assignedAt: assignedAt,
      expiresAt: assignedAt.add(const Duration(seconds: 60)),
    );

Map<String, Object?> workOrderJson(TaskAssignment task) => {
  'id': task.taskId,
  'request_id': task.requestId,
  'status': 'PENDING',
  'shift': 'S1',
  'created_at': task.assignedAt.toIso8601String(),
  'respond_by': task.expiresAt.toIso8601String(),
  'machine': {'id': task.machineCode, 'cell_position': task.location},
  'issue': task.issue,
};

const systemActor = {
  'source': 'system',
  'device_kind': null,
  'device_id': null,
};
const phoneActor = {
  'source': 'mobile',
  'device_kind': 'PERSONAL',
  'device_id': null,
};
const watchActor = {
  'source': 'mobile',
  'device_kind': 'SHARED',
  'device_id': 'w1',
};

Map<String, Object?> updatedPayload(
  TaskAssignment task,
  String reason, {
  Map<String, Object?> by = systemActor,
}) => {
  'work_order': workOrderJson(task),
  'reason': reason,
  'by': by,
  'at': task.assignedAt.add(const Duration(seconds: 10)).toIso8601String(),
};

/// A `state:snapshot` payload.
Map<String, Object?> snapshotPayload({
  TaskAssignment? pending,
  TaskAssignment? active,
  bool checkedIn = true,
}) => {
  'self': {'kind': 'PERSONAL', 'technician_id': 31, 'session_id': 's'},
  'status': {
    'checked_in': checkedIn,
    'is_available': checkedIn && active == null,
  },
  'pending_work_order': pending == null ? null : workOrderJson(pending),
  'active_work_order': active == null ? null : workOrderJson(active),
};
