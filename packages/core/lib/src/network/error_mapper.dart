import 'dart:io' show HandshakeException, SocketException, TlsException;

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../error/failure.dart';
import '../error/result.dart';
import '../logging/app_logger.dart';
import '../time/app_clock.dart';

/// Maps exceptions to [Failure]s. Repositories wrap every remote call with
/// [ErrorMapper.guard] so cubits never see exceptions.
class ErrorMapper {
  ErrorMapper(this._clock);

  final AppClock _clock;

  /// Earliest plausible device date. A drained scanner can boot in 1970 or
  /// at its factory date, which also breaks TLS (doc 11).
  static final minimumPlausibleDate = DateTime.utc(2026, 1, 1);

  Future<Result<T>> guard<T>(Future<T> Function() call) async {
    try {
      return Result.ok(await call());
    } on Object catch (e, s) {
      return Result.err(map(e, s));
    }
  }

  Failure map(Object error, [StackTrace? stack]) {
    if (error is DioException) return _mapDio(error, stack);
    if (error is SocketException) return _network();
    if (error is HandshakeException || error is TlsException) return _tls();
    AppLogger.error('Unexpected error', error, stack);
    return UnexpectedFailure(error);
  }

  Failure _mapDio(DioException e, StackTrace? stack) {
    final response = e.response;
    if (response != null) return _fromResponse(response);
    final inner = e.error;
    if (e.type == DioExceptionType.badCertificate ||
        inner is HandshakeException ||
        inner is TlsException) {
      return _tls();
    }
    if (isConnectionError(e)) return _network();
    if (e.type == DioExceptionType.cancel) {
      return const UnexpectedFailure('cancelled');
    }
    AppLogger.error('Unexpected network error', e, stack);
    return UnexpectedFailure(e);
  }

  /// No response at all: offline, DNS, timeout, refused.
  static bool isConnectionError(DioException e) =>
      e.response == null &&
      (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.error is SocketException);

  Failure _network() => _clock.isDeviceClockSkewed
      ? const DeviceClockFailure()
      : const NoConnectionFailure();

  /// A TLS failure on a device whose date is clearly wrong is a clock problem,
  /// not a network problem: show "Periksa tanggal dan jam perangkat".
  Failure _tls() {
    final deviceNow = _clock.deviceNowUtc();
    if (_clock.isDeviceClockSkewed ||
        deviceNow.isBefore(minimumPlausibleDate)) {
      return const DeviceClockFailure();
    }
    return const NoConnectionFailure();
  }

  Failure _fromResponse(Response<dynamic> response) {
    final status = response.statusCode ?? 0;
    final data = response.data;
    final message = messageOf(data);
    final code = classify(status, message, path: response.requestOptions.path);
    if (code == ApiErrorCode.unauthorized &&
        response.requestOptions.headers.containsKey('Authorization')) {
      // A technician call with a token: the session is over (the auth
      // interceptor already asked the session to end).
      return const SessionExpiredFailure();
    }
    return ApiFailure(
      statusCode: status,
      code: code,
      message: message,
      retryAfter: code == ApiErrorCode.rateLimited
          ? retryAfterOf(response)
          : null,
    );
  }

  /// The backend error body is NestJS style:
  /// `{ "message": "…" | ["…"], "statusCode": 409 }`, sometimes wrapped in
  /// the success envelope `{ "status_code", "message", "data" }`.
  static String? messageOf(Object? data) {
    if (data is! Map) return null;
    final raw = data['message'];
    if (raw is String) return raw;
    if (raw is List) return raw.whereType<String>().join('; ');
    return null;
  }

  /// Derives an [ApiErrorCode] from the status and the English message
  /// (docs/api_contract.md "Errors"). Matching is case-insensitive and on
  /// short distinctive fragments, so wording tweaks do not break it.
  @visibleForTesting
  static String? classify(int status, String? message, {String path = ''}) {
    final m = (message ?? '').toLowerCase();
    bool has(String s) => m.contains(s);
    switch (status) {
      case 400:
        return ApiErrorCode.badRequest;
      case 401:
        if (has('kpk or password')) return ApiErrorCode.invalidCredentials;
        if (has('enrollment code')) return ApiErrorCode.enrollmentCodeInvalid;
        if (has('device signature')) return ApiErrorCode.invalidSignature;
        return ApiErrorCode.unauthorized;
      case 403:
        return ApiErrorCode.wrongDevice;
      case 404:
        if (has('pairing code')) return ApiErrorCode.pairCodeInvalid;
        if (has('work order')) return ApiErrorCode.workOrderNotFound;
        return null;
      case 409:
        if (has('already answered')) {
          return ApiErrorCode.workOrderAlreadyAnswered;
        }
        if (has('not checked in')) return ApiErrorCode.notCheckedIn;
        if (has('unavailable')) return ApiErrorCode.technicianUnavailable;
        if (has('not accepted this work order')) {
          return ApiErrorCode.workOrderNotAccepted;
        }
        if (has('pairing') || path.contains('pairings')) {
          return ApiErrorCode.pairingNotApproved;
        }
        return null;
      case 429:
        return ApiErrorCode.rateLimited;
    }
    return null;
  }

  /// `Retry-After` header (seconds) or `retryAfter` / `retry_after` in the
  /// body (seconds).
  @visibleForTesting
  static Duration? retryAfterOf(Response<dynamic> response) {
    int? seconds = int.tryParse(response.headers.value('retry-after') ?? '');
    final data = response.data;
    if (seconds == null && data is Map) {
      final raw = data['retryAfter'] ?? data['retry_after'];
      if (raw is num) seconds = raw.ceil();
      if (raw is String) seconds = int.tryParse(raw);
    }
    if (seconds == null || seconds < 0) return null;
    return Duration(seconds: seconds);
  }
}
