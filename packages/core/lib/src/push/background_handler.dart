import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

import '../db/app_database.dart';
import '../db/key_value_store.dart';
import '../logging/app_logger.dart';
import '../realtime/realtime_event.dart';
import '../realtime/realtime_models.dart';
import '../tasks/task_event_processor.dart';
import '../tasks/task_event_store.dart';
import '../tasks/task_notifications.dart';
import 'push_message.dart';

/// Key of the last known server clock offset, written by the foreground app
/// so the background isolate can judge `respond_by` correctly.
const clockOffsetKey = 'clock.offset_ms';

/// Key set when a push ended the session while the app was in the
/// background; the foreground app wipes the session on its next start.
const sessionEndedKey = 'session.ended_in_background';

/// FCM background handler (doc 7.5).
///
/// Runs in a separate isolate with **no GetIt graph**. It only: parses the
/// payload, dedupes against Drift (opened directly), and shows or cancels
/// the full-screen alert. The `work-order:ack` is a socket message, so it is
/// sent by the foreground app when the work order is presented.
/// Register it with
/// `FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessageHandler)`.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundMessageHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await handleBackgroundPush(
    message.data,
    initFirebase: () async {
      if (Firebase.apps.isEmpty) await Firebase.initializeApp();
    },
  );
}

/// Testable body of the background handler.
Future<void> handleBackgroundPush(
  Map<String, dynamic> data, {
  Future<void> Function()? initFirebase,
  AppDatabase Function()? openDatabase,
  TaskNotifications? notifications,
  DateTime Function()? deviceNowUtc,
}) async {
  final event = PushMessage.parse(data);
  if (event is! WorkOrderAssigned &&
      event is! WorkOrderUpdated &&
      event is! SessionEndedEvent) {
    return;
  }

  AppDatabase? db;
  try {
    await initFirebase?.call();
    db = (openDatabase ?? AppDatabase.open)();
    final kv = KeyValueStore(db);
    if (event is SessionEndedEvent) {
      await kv.write(sessionEndedKey, event.reason ?? 'true');
      return;
    }
    final offsetMs = int.tryParse(await kv.read(clockOffsetKey) ?? '') ?? 0;
    final serverNow = (deviceNowUtc?.call() ?? DateTime.now().toUtc()).add(
      Duration(milliseconds: offsetMs),
    );
    // The background isolate cannot tell this device's own actions apart;
    // its own actions only happen in the foreground anyway.
    final processor = TaskEventProcessor(
      TaskEventStore(db),
      self: const ThisDevice(kind: SessionKind.unknown),
    );
    final decision = switch (event) {
      WorkOrderAssigned(:final task) => await processor.assigned(
        task,
        serverNowUtc: serverNow,
      ),
      WorkOrderUpdated() => await processor.updated(
        event,
        serverNowUtc: serverNow,
      ),
      _ => const IgnoreEvent('not a work-order event'),
    };

    final alerts = notifications ?? TaskNotifications();
    switch (decision) {
      case PresentAssignment(:final task):
        await alerts.initialize();
        await alerts.showTaskAlert(
          task,
          remaining: task.expiresAt.difference(serverNow),
        );
      case DismissActive() || MoveToInProgress() || CompleteActive():
        await alerts.initialize();
        await alerts.cancelTaskAlert();
      case ShowMissed() || IgnoreEvent():
        break;
    }
  } on Object catch (e, s) {
    AppLogger.error('Background push handling failed', e, s);
  } finally {
    await db?.close();
  }
}
