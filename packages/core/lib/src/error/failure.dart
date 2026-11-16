import 'package:meta/meta.dart';

/// Error kinds of the technician backend.
///
/// The backend answers errors with an HTTP status and an English `message`
/// only (no machine-readable code, see docs/api_contract.md), so
/// `ErrorMapper` derives these from status + message. Kept as strings so a
/// new kind does not crash older apps.
abstract final class ApiErrorCode {
  /// 401 on login: wrong KPK or password (never says which).
  static const invalidCredentials = 'INVALID_CREDENTIALS';

  /// 429: too many attempts. `ApiFailure.retryAfter` says how long to wait.
  static const rateLimited = 'RATE_LIMITED';

  /// 401 on a technician call: the session ended (logout, replaced, expired).
  static const unauthorized = 'UNAUTHORIZED';

  /// 401 on a watch call: the device signature was rejected.
  static const invalidSignature = 'INVALID_DEVICE_SIGNATURE';

  /// 403: wrong kind of device (a watch token on a phone-only call or the
  /// opposite).
  static const wrongDevice = 'WRONG_DEVICE';

  /// 409 "This work order was already answered": another device or the
  /// timer was first. Not an error for the user.
  static const workOrderAlreadyAnswered = 'WORK_ORDER_ALREADY_ANSWERED';

  /// 409 "You are not checked in".
  static const notCheckedIn = 'NOT_CHECKED_IN';

  /// 409 "You are currently marked as unavailable" (an accepted job exists).
  static const technicianUnavailable = 'TECHNICIAN_UNAVAILABLE';

  /// 409 "You have not accepted this work order" (cancel).
  static const workOrderNotAccepted = 'WORK_ORDER_NOT_ACCEPTED';

  /// 404 "Work order not found".
  static const workOrderNotFound = 'WORK_ORDER_NOT_FOUND';

  /// 404 "Pairing code is invalid or expired" (phone preview / approve).
  static const pairCodeInvalid = 'PAIR_CODE_INVALID';

  /// 409 "Pairing is …, not approved" (watch exchange).
  static const pairingNotApproved = 'PAIRING_NOT_APPROVED';

  /// 401 "Invalid or expired enrollment code".
  static const enrollmentCodeInvalid = 'ENROLLMENT_CODE_INVALID';

  /// 400: invalid request (validation message from the backend).
  static const badRequest = 'BAD_REQUEST';
}

/// Every error crossing a repository boundary is one of these.
/// Repositories map exceptions; cubits only ever see a [Failure].
@immutable
sealed class Failure {
  const Failure();
}

/// No network or the server could not be reached.
final class NoConnectionFailure extends Failure {
  const NoConnectionFailure();
  @override
  String toString() => 'NoConnectionFailure';
}

/// The device clock is far from server time (doc 11). Also used when TLS
/// fails on a device whose date is clearly wrong.
final class DeviceClockFailure extends Failure {
  const DeviceClockFailure();
  @override
  String toString() => 'DeviceClockFailure';
}

/// The session ended (401 on a technician call). The user is signed out.
final class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure();
  @override
  String toString() => 'SessionExpiredFailure';
}

/// The server answered with an error.
final class ApiFailure extends Failure {
  const ApiFailure({
    required this.statusCode,
    this.code,
    this.message,
    this.retryAfter,
  });

  final int statusCode;

  /// One of [ApiErrorCode], or null when the error is not recognised.
  final String? code;

  /// The backend's message. Never shown to users (English, technical).
  final String? message;

  /// For [ApiErrorCode.rateLimited]: how long to wait, when known.
  final Duration? retryAfter;

  bool hasCode(String value) => code == value;

  @override
  bool operator ==(Object other) =>
      other is ApiFailure &&
      other.statusCode == statusCode &&
      other.code == code &&
      other.message == message &&
      other.retryAfter == retryAfter;

  @override
  int get hashCode => Object.hash(statusCode, code, message, retryAfter);

  @override
  String toString() => 'ApiFailure($statusCode, $code)';
}

/// Anything else. Logged to Crashlytics by the mapper.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([this.error]);
  final Object? error;
  @override
  String toString() => 'UnexpectedFailure';
}
