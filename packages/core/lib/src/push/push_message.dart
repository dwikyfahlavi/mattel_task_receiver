import 'dart:convert';

import '../realtime/realtime_event.dart';

/// FCM data message format (proposed to the backend, docs/api_contract.md
/// "Push (proposed)"): the same event as the socket, so one parser serves
/// both channels.
///
/// ```json
/// { "event": "work-order:assigned", "payload": "{\"work_order\":{…}}" }
/// ```
///
/// FCM data values are strings, so `payload` is the socket payload as a JSON
/// string. Messages carry signals and work-order details only, never tokens
/// (security rules).
abstract final class PushMessage {
  static const eventKey = 'event';
  static const payloadKey = 'payload';

  /// Never throws: malformed messages become [UnknownRealtimeEvent].
  static RealtimeEvent parse(Map<String, dynamic> data) {
    final name = data[eventKey];
    if (name is! String || name.isEmpty) {
      return const UnknownRealtimeEvent('push');
    }
    // Token-bearing events are never accepted over push.
    if (name == RealtimeEvent.snapshot) return UnknownRealtimeEvent(name);
    Object? payload = data[payloadKey];
    if (payload is String) {
      try {
        payload = jsonDecode(payload);
      } on FormatException {
        return UnknownRealtimeEvent(name);
      }
    }
    return RealtimeEvent.parse(name, payload);
  }

  /// Builds a message (fake backend and tests).
  static Map<String, String> encode(String event, Object? payload) => {
    eventKey: event,
    payloadKey: jsonEncode(payload),
  };
}
