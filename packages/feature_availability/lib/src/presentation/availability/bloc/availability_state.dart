part of 'availability_bloc.dart';

enum AvailabilityBusy { none, checkingIn, checkingOut }

@freezed
abstract class AvailabilityState with _$AvailabilityState {
  const AvailabilityState._();

  const factory AvailabilityState({
    @Default(false) bool available,
    DateTime? checkedInAt,
    @Default(AvailabilityBusy.none) AvailabilityBusy busy,

    /// Set when Check In was blocked or warned by the readiness check, or a
    /// background check found a blocking problem.
    ReadinessReport? readiness,

    /// True when [readiness] came from a Check In tap: only then may the
    /// checklist offer "Tetap Check In".
    @Default(false) bool readinessForCheckIn,
    Failure? error,

    /// Increments each time a Check Out was queued offline (snackbar trigger).
    @Default(0) int checkOutQueuedCount,

    /// Check Out tapped while a task is In Progress (doc 4.2 rule 6).
    @Default(0) int checkOutBlockedCount,

    /// Increments when the server refused a queued Check Out (doc 16).
    @Default(0) int checkOutConflictCount,
  }) = _AvailabilityState;
}
