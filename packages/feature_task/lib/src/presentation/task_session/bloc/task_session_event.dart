part of 'task_session_bloc.dart';

sealed class TaskSessionEvent {
  const TaskSessionEvent();
}

/// Start listening after sign-in (or at startup with a restored session).
final class TaskSessionStarted extends TaskSessionEvent {
  const TaskSessionStarted();
}

/// Session ended: stop alerts and forget everything.
final class TaskSessionStopped extends TaskSessionEvent {
  const TaskSessionStopped();
}

/// App resumed or connectivity restored: re-read Drift and the server.
final class TaskReconcileRequested extends TaskSessionEvent {
  const TaskReconcileRequested();
}

/// The alert notification was tapped (work order id from the payload).
final class TaskNotificationTapped extends TaskSessionEvent {
  const TaskNotificationTapped(this.taskId);
  final String taskId;
}

final class TaskAcceptPressed extends TaskSessionEvent {
  const TaskAcceptPressed();
}

/// Tolak after the confirmation dialog.
final class TaskRejectConfirmed extends TaskSessionEvent {
  const TaskRejectConfirmed();
}

/// "Batalkan Penugasan" on an accepted job, after the confirmation dialog.
final class TaskCancelConfirmed extends TaskSessionEvent {
  const TaskCancelConfirmed();
}

/// Local countdown reached zero.
final class TaskCountdownExpired extends TaskSessionEvent {
  const TaskCountdownExpired();
}

/// Last 10 seconds: faster vibration (doc 10.1).
final class TaskCountdownUrgent extends TaskSessionEvent {
  const TaskCountdownUrgent();
}

final class TaskAcceptedScreenClosed extends TaskSessionEvent {
  const TaskAcceptedScreenClosed();
}

final class TaskResultClosed extends TaskSessionEvent {
  const TaskResultClosed();
}

/// A socket event or a push (both channels, D-21).
final class _EventReceived extends TaskSessionEvent {
  const _EventReceived(this.event, {this.fromPush = false});
  final RealtimeEvent event;
  final bool fromPush;
}
