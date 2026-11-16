import 'remote_settings.dart';

/// How work orders reach the device. The backend currently delivers over the
/// Socket.IO socket only; FCM is kept ready because the delivery channel is
/// still being decided with the backend team (DECISIONS D-21).
///
/// Both channels feed the same parser and `TaskEventProcessor`, so a work
/// order received twice (socket and push) is shown once.
enum TaskDelivery {
  /// Socket only (current backend). Keep-alive service on; no FCM token is
  /// registered with the backend.
  socket('socket'),

  /// FCM only. No socket and no keep-alive service; state is recovered with
  /// `GET /technicians/me/state` on start, resume and reconnect.
  fcm('fcm'),

  /// Both: the socket for live state, FCM to wake the device.
  both('both');

  const TaskDelivery(this.wireName);
  final String wireName;

  static const defaultValue = TaskDelivery.socket;

  static TaskDelivery parse(String? raw) {
    for (final d in values) {
      if (d.wireName == raw?.trim().toLowerCase()) return d;
    }
    return defaultValue;
  }

  static TaskDelivery fromSettings(RemoteSettings settings) =>
      parse(settings.string(RemoteKeys.taskDelivery));

  bool get usesSocket => this != fcm;
  bool get usesPush => this != socket;
}
