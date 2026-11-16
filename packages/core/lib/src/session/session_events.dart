import 'dart:async';

/// Why a session ended. Every reason triggers the same wipe (doc 8.1).
enum SessionEndReason {
  /// User tapped Keluar.
  logout,

  /// Shift-end cutoff reached (doc 4.3).
  shiftEnd,

  /// A `401` on a technician call, or `session:ended` with `EXPIRED`.
  expired,

  /// Signed in on another phone, or another technician paired this watch
  /// (`session:ended` with `REPLACED`).
  replaced,

  /// The watch was unpaired from the phone (`LOGOUT` / `CHECK_OUT` on a
  /// watch session).
  unpaired,

  /// The admin disabled this watch (`DEVICE_DISABLED`).
  deviceDisabled,

  /// Any other server-side end.
  revoked;

  /// Whether the server already ended the session (no logout call needed).
  bool get endedByServer => this != logout && this != shiftEnd;
}

/// App-wide signal that the session must end. Emitted by the auth
/// interceptor, the realtime socket and the shift-end coordinator; consumed
/// by the app-scoped session cubit, which performs the wipe exactly once.
class SessionEventBus {
  final _controller = StreamController<SessionEndReason>.broadcast();

  Stream<SessionEndReason> get endRequests => _controller.stream;

  void requestEnd(SessionEndReason reason) {
    if (!_controller.isClosed) _controller.add(reason);
  }

  Future<void> dispose() => _controller.close();
}
