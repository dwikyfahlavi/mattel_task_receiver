import '../db/app_database.dart';
import '../logging/app_logger.dart';
import '../push/push_service.dart';
import '../storage/secure_store.dart';
import '../storage/token_store.dart';
import '../tasks/task_notifications.dart';

/// Local half of "wipe on session end" (doc 8.1): FCM token, secure storage,
/// Drift session data (queue, active task, dedupe, pending results) and any
/// visible alert. The server half (logout, unregister token) is done by the
/// auth repository before calling this. Never throws.
class LocalSessionWiper {
  LocalSessionWiper({
    required TokenStore tokens,
    required SecureStore secure,
    required AppDatabase db,
    required PushService push,
    required TaskNotifications notifications,
  }) : _tokens = tokens,
       _secure = secure,
       _db = db,
       _push = push,
       _notifications = notifications;

  final TokenStore _tokens;
  final SecureStore _secure;
  final AppDatabase _db;
  final PushService _push;
  final TaskNotifications _notifications;

  Future<void> wipe() async {
    await _step('cancel alert', _notifications.cancelTaskAlert);
    // A new token is issued for the next user on a shared watch, so the
    // previous user's assignments cannot reach them.
    await _step('delete FCM token', _push.deleteToken);
    await _step('clear tokens', _tokens.clear);
    await _step('wipe secure storage', _secure.wipeSession);
    await _step('wipe database', _db.wipeSessionData);
  }

  Future<void> _step(String name, Future<void> Function() action) async {
    try {
      await action();
    } on Object catch (e, s) {
      AppLogger.error('Session wipe step failed: $name', e, s);
    }
  }
}
