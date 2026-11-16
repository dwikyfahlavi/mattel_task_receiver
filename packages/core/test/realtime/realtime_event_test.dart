import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

void main() {
  final task = sampleTask();

  group('RealtimeEvent.parse (socket payloads)', () {
    test('work-order:assigned', () {
      final e = RealtimeEvent.parse('work-order:assigned', {
        'work_order': workOrderJson(task),
      });
      expect(e, isA<WorkOrderAssigned>());
      final t = (e as WorkOrderAssigned).task;
      expect(t.taskId, task.taskId);
      expect(t.machineCode, 'FAR339');
      expect(t.location, 'B-12');
      expect(t.issue, 'Changeover');
      expect(t.expiresAt, task.expiresAt);
    });

    test('a missing respond_by defaults to created_at + 60 s', () {
      final json = workOrderJson(task)..remove('respond_by');
      final t = TaskAssignment.fromWorkOrder(json)!;
      expect(t.expiresAt, task.assignedAt.add(const Duration(seconds: 60)));
    });

    test('work-order:updated with who did it', () {
      final e = RealtimeEvent.parse('work-order:updated', {
        'work_order': workOrderJson(task),
        'reason': 'AUTO_DECLINED',
        'by': systemActor,
        'at': '2026-10-27T02:39:04Z',
      });
      final u = e as WorkOrderUpdated;
      expect(u.change, WorkOrderChange.autoDeclined);
      expect(u.by?.isSystem, isTrue);
      expect(
        WorkOrderChange.parse('REPAIR_FINISHED'),
        WorkOrderChange.completed,
      );
    });

    test('state:snapshot', () {
      final e = RealtimeEvent.parse('state:snapshot', {
        'self': {
          'kind': 'PERSONAL',
          'technician_id': 31,
          'session_id': 's',
          'device_id': null,
        },
        'status': {
          'checked_in': true,
          'checked_in_at': '2026-10-27T00:00:00Z',
          'is_available': true,
          'is_on_break': false,
          'shift': 'S1',
        },
        'pending_work_order': workOrderJson(task),
        'active_work_order': null,
        'paired_watches': [
          {
            'session_id': 'w1',
            'device': {'id': 'd', 'name': 'Watch 1', 'location': 'Line B'},
            'paired_at': '2026-10-27T00:00:00Z',
            'expires_at': '2026-10-27T12:00:00Z',
          },
        ],
      });
      final s = (e as SnapshotReceived).snapshot;
      expect(s.kind, SessionKind.personal);
      expect(s.status?.checkedIn, isTrue);
      expect(s.pendingWorkOrder?.taskId, task.taskId);
      expect(s.activeWorkOrder, isNull);
      expect(s.pairedWatches.single.name, 'Watch 1');
    });

    test('unpaired watch snapshot has only self', () {
      final s = StateSnapshot.parse({
        'self': {'kind': 'UNPAIRED_DEVICE', 'device_id': 'd'},
      });
      expect(s.kind, SessionKind.unpairedDevice);
      expect(s.status, isNull);
    });

    test('session:ended, pairing:approved, watch events', () {
      expect(
        (RealtimeEvent.parse('session:ended', {
          'reason': 'REPLACED',
        }) as SessionEndedEvent).reason,
        'REPLACED',
      );
      expect(
        (RealtimeEvent.parse('pairing:approved', {
          'pairing_id': 'p',
        }) as PairingApprovedEvent).pairingId,
        'p',
      );
      expect(
        RealtimeEvent.parse('watch:unpaired', {'session_id': 'w1'}),
        isA<WatchUnpairedEvent>(),
      );
    });

    test('malformed payloads never throw', () {
      expect(
        RealtimeEvent.parse('work-order:assigned', {'work_order': 'x'}),
        isA<UnknownRealtimeEvent>(),
      );
      expect(
        RealtimeEvent.parse('status:changed', 42),
        isA<UnknownRealtimeEvent>(),
      );
      expect(RealtimeEvent.parse('nope', null), isA<UnknownRealtimeEvent>());
    });
  });

  group('PushMessage (FCM, same events, D-21)', () {
    test('parses the socket event inside the data message', () {
      final data = PushMessage.encode('work-order:assigned', {
        'work_order': workOrderJson(task),
      });
      // FCM data values are strings: the payload travels as JSON text.
      expect(data[PushMessage.payloadKey], startsWith('{'));
      expect(PushMessage.parse(data), isA<WorkOrderAssigned>());
    });

    test('a snapshot is never accepted over push', () {
      expect(
        PushMessage.parse({'event': 'state:snapshot', 'payload': '{}'}),
        isA<UnknownRealtimeEvent>(),
      );
    });

    test('broken JSON is dropped', () {
      expect(
        PushMessage.parse({'event': 'work-order:assigned', 'payload': '{'}),
        isA<UnknownRealtimeEvent>(),
      );
      expect(PushMessage.parse({}), isA<UnknownRealtimeEvent>());
    });

    test('a decoded map payload works too', () {
      expect(
        PushMessage.parse({
          'event': 'session:ended',
          'payload': jsonDecode('{"reason":"EXPIRED"}'),
        }),
        isA<SessionEndedEvent>(),
      );
    });
  });
}
