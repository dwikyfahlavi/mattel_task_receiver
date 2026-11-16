import 'dart:async';

import 'package:core/core.dart';
import 'package:drift/native.dart';

/// In-memory Drift database for tests.
AppDatabase memoryDatabase() => AppDatabase(NativeDatabase.memory());

/// Clock whose device time and offset are set by the test.
class FakeAppClock extends AppClock {
  FakeAppClock({
    required DateTime serverNowUtc,
    Duration offset = Duration.zero,
  }) : _device = serverNowUtc.subtract(offset),
       _offset = offset;

  DateTime _device;
  Duration _offset;

  /// Simulates the user changing the device clock (server time is unchanged
  /// until the next server sample).
  void setDeviceTime(DateTime deviceUtc) => _device = deviceUtc;

  void advance(Duration d) => _device = _device.add(d);

  @override
  DateTime deviceNowUtc() => _device;

  @override
  DateTime serverNowUtc() => _device.add(_offset);

  @override
  Duration get serverOffset => _offset;

  @override
  bool get hasServerTime => true;

  @override
  void updateServerTime(DateTime serverUtc) =>
      _offset = serverUtc.difference(_device);
}

TaskAssignment sampleTask({
  String id = 't-1',
  DateTime? assignedAt,
  Duration window = const Duration(seconds: 60),
}) {
  final at = assignedAt ?? DateTime.utc(2026, 10, 27, 2, 37, 59);
  return TaskAssignment(
    taskId: id,
    requestId: 'WO-2026-00193',
    machineCode: 'FAR339',
    location: 'B-12',
    issue: 'Changeover',
    assignedAt: at,
    expiresAt: at.add(window),
  );
}

/// A backend `work_order` JSON for [task].
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

/// `by` of a `work-order:updated` made by the technician's phone.
const phoneActor = {
  'source': 'mobile',
  'device_kind': 'PERSONAL',
  'device_id': null,
};

/// `by` of an action made by the watch [deviceId].
Map<String, Object?> watchActor(String deviceId) => {
  'source': 'mobile',
  'device_kind': 'SHARED',
  'device_id': deviceId,
};

const systemActor = {
  'source': 'system',
  'device_kind': null,
  'device_id': null,
};

/// In-memory remote settings.
LayeredRemoteSettings staticSettings([
  Map<String, Object?> values = const {},
]) => LayeredRemoteSettings(
  sources: [StaticSettingsSource(Map.of(values))],
  defaults: FeatureFlag.defaults,
);

/// Records `requestEnd` calls.
class RecordingSessionBus extends SessionEventBus {
  final ended = <SessionEndReason>[];
  StreamSubscription<SessionEndReason>? _sub;

  void listen() => _sub = endRequests.listen(ended.add);

  @override
  Future<void> dispose() async {
    await _sub?.cancel();
    await super.dispose();
  }
}
