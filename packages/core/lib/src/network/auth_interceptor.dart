import 'package:dio/dio.dart';

import '../logging/app_logger.dart';
import '../session/session_events.dart';
import '../storage/token_store.dart';
import 'request_options_x.dart';

/// Attaches the technician token and ends the session on `401`.
///
/// The backend has no refresh token: any `401` on a call that carried a
/// token means the session is over (logout elsewhere, replaced, expired,
/// unpaired). The watch's device signature 401s are retried first by
/// `DeviceSigningInterceptor` when they come from a wrong clock.
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStore tokens,
    required SessionEventBus sessionEvents,
  }) : _tokens = tokens,
       _sessionEvents = sessionEvents;

  final TokenStore _tokens;
  final SessionEventBus _sessionEvents;

  static const header = 'Authorization';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[RequestFlags.skipAuth] != true) {
      final token = _tokens.current?.accessToken;
      if (token != null) options.headers[header] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final options = err.requestOptions;
    final sentToken = options.headers[header];
    // A watch 401 caused by a wrong clock is retried once by the signing
    // interceptor; only the retry's 401 ends the session.
    final clockRetryPending =
        err.response?.headers.value('x-server-time') != null &&
        options.extra[RequestFlags.retried] != true &&
        options.extra[RequestFlags.unsigned] != true &&
        options.headers.containsKey('X-Signature');
    if (err.response?.statusCode == 401 &&
        !clockRetryPending &&
        options.extra[RequestFlags.skipAuth] != true &&
        sentToken is String &&
        sentToken == 'Bearer ${_tokens.current?.accessToken}') {
      AppLogger.info('401 on ${options.path}: session ended');
      _sessionEvents.requestEnd(SessionEndReason.expired);
    }
    handler.next(err);
  }
}
