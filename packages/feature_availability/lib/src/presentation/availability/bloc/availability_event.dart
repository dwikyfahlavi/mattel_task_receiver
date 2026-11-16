part of 'availability_bloc.dart';

sealed class AvailabilityEvent {
  const AvailabilityEvent();
}

final class AvailabilityStarted extends AvailabilityEvent {
  const AvailabilityStarted();
}

final class AvailabilityRefreshed extends AvailabilityEvent {
  const AvailabilityRefreshed();
}

/// [skipWarnings] continues after the user saw the warning checklist.
final class CheckInPressed extends AvailabilityEvent {
  const CheckInPressed({this.skipWarnings = false});
  final bool skipWarnings;
}

final class CheckOutPressed extends AvailabilityEvent {
  const CheckOutPressed({this.sessionExpiresAt});
  final DateTime? sessionExpiresAt;
}

final class ReadinessDismissed extends AvailabilityEvent {
  const ReadinessDismissed();
}

/// Background readiness check (doc 12): at app start on the watch and on
/// every resume. Shows the checklist only for blocking problems, so a
/// silently broken setup (notifications off, channel muted, clock wrong) is
/// not missed while the technician is Available. Never checks in by itself.
final class ReadinessRecheckRequested extends AvailabilityEvent {
  const ReadinessRecheckRequested();
}

/// A queued Check Out was rejected by the server (doc 16): reload state.
final class _CheckOutConflict extends AvailabilityEvent {
  const _CheckOutConflict();
}

/// Shift end and manual logout: check out directly, without queueing.
final class ImmediateCheckOut extends AvailabilityEvent {
  const ImmediateCheckOut();
}

final class AvailabilityReset extends AvailabilityEvent {
  const AvailabilityReset();
}

final class _AvailabilityLost extends AvailabilityEvent {
  const _AvailabilityLost();
}

/// `status:changed` or the status of a state snapshot.
final class _StatusReceived extends AvailabilityEvent {
  const _StatusReceived(this.status);
  final TechnicianStatus status;
}
