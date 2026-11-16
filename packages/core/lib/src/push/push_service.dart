import 'dart:async';

import 'package:async/async.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../logging/app_logger.dart';
import '../realtime/realtime_event.dart';
import 'push_message.dart';

/// Where a push came from: received while the app was running, or the tap
/// on a notification that opened the app.
enum PushOrigin { foreground, notificationTap }

class IncomingPush {
  const IncomingPush(this.event, this.origin);
  final RealtimeEvent event;
  final PushOrigin origin;
}

/// FCM wrapper. The app-scoped task session is the only listener of
/// [messages] (doc 7.1).
abstract class PushService {
  Stream<IncomingPush> get messages;
  Stream<String> get tokenRefreshes;

  Future<String?> token();

  /// Called on every session end so the next technician on a shared watch
  /// gets a new token and never the previous user's work orders.
  Future<void> deleteToken();

  /// Message that cold-started the app from a notification, if any.
  Future<IncomingPush?> initialMessage();
}

/// FCM registration-token flow.
///
/// firebase_messaging 17 deprecates the token API in favour of FID
/// registration. Moving requires the backend to send by Firebase
/// Installation ID, so it is decided together with the push contract
/// (DECISIONS D-03, D-21).
class FirebasePushService implements PushService {
  FirebasePushService([FirebaseMessaging? messaging])
    : _messaging = messaging ?? FirebaseMessaging.instance;

  final FirebaseMessaging _messaging;

  @override
  Stream<IncomingPush> get messages => StreamGroup.merge([
    FirebaseMessaging.onMessage.map(
      (m) => IncomingPush(PushMessage.parse(m.data), PushOrigin.foreground),
    ),
    FirebaseMessaging.onMessageOpenedApp.map(
      (m) =>
          IncomingPush(PushMessage.parse(m.data), PushOrigin.notificationTap),
    ),
  ]);

  @override
  // ignore: deprecated_member_use
  Stream<String> get tokenRefreshes => _messaging.onTokenRefresh;

  @override
  Future<String?> token() async {
    try {
      // ignore: deprecated_member_use
      return await _messaging.getToken();
    } on Object catch (e) {
      AppLogger.warn('FCM token unavailable', error: e);
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      // ignore: deprecated_member_use
      await _messaging.deleteToken();
    } on Object catch (e) {
      AppLogger.warn('FCM deleteToken failed', error: e);
    }
  }

  @override
  Future<IncomingPush?> initialMessage() async {
    final m = await _messaging.getInitialMessage();
    if (m == null) return null;
    return IncomingPush(PushMessage.parse(m.data), PushOrigin.notificationTap);
  }
}

/// Used when Firebase is not configured. Work orders still arrive over the
/// socket and are recovered from the state snapshot.
class NoopPushService implements PushService {
  @override
  Stream<IncomingPush> get messages => const Stream.empty();
  @override
  Stream<String> get tokenRefreshes => const Stream.empty();
  @override
  Future<String?> token() async => null;
  @override
  Future<void> deleteToken() async {}
  @override
  Future<IncomingPush?> initialMessage() async => null;
}

/// Delivers pushes from a stream as foreground messages (dev fake backend,
/// tests).
class StreamPushService implements PushService {
  StreamPushService(this._source);

  final Stream<Map<String, dynamic>> _source;

  @override
  Stream<IncomingPush> get messages => _source.map(
    (data) => IncomingPush(PushMessage.parse(data), PushOrigin.foreground),
  );
  @override
  Stream<String> get tokenRefreshes => const Stream.empty();
  @override
  Future<String?> token() async => 'fake-fcm-token';
  @override
  Future<void> deleteToken() async {}
  @override
  Future<IncomingPush?> initialMessage() async => null;
}
