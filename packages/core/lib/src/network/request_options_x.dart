import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// `extra` keys understood by the interceptors.
abstract final class RequestFlags {
  /// Do not attach the bearer token, and a 401 does not end the session
  /// (login, enrollment, pairing before the exchange).
  static const skipAuth = 'skip_auth';

  /// Watch only: do not sign (enrollment proves the key in its body).
  static const unsigned = 'unsigned';

  /// Set on the single retry after a clock correction, to avoid loops.
  static const retried = 'retried';

  /// Options for unauthenticated calls.
  static Options get noAuth => Options(extra: {skipAuth: true});
}

/// Random id for local bookkeeping (outbox rows). The backend has no
/// `Idempotency-Key`; its endpoints are idempotent by state instead.
String newIdempotencyKey() => const Uuid().v4();
