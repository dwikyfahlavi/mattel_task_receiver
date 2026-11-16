import 'dart:convert';

import 'package:dio/dio.dart';

import '../device/device_identity.dart';
import '../logging/app_logger.dart';
import '../storage/token_store.dart';
import '../time/app_clock.dart';
import 'request_options_x.dart';

/// Watch only: signs every request with the device key (backend guide,
/// part 2 step 3).
///
/// * The body is serialised here, so the signed bytes are exactly the bytes
///   sent. No body and an empty map both send (and hash) nothing.
/// * After pairing the signature includes the token's `session_id`.
/// * A `401` with an `X-Server-Time` header means the clock is off: the
///   offset is corrected and the request is signed again and retried once
///   (a signature works only once, so the retry has a new nonce).
///
/// Must be the last request interceptor so nothing changes the request after
/// it was signed.
class DeviceSigningInterceptor extends Interceptor {
  DeviceSigningInterceptor({
    required RequestSigner signer,
    required TokenStore tokens,
    required AppClock clock,
    required Dio retryClient,
  }) : _signer = signer,
       _tokens = tokens,
       _clock = clock,
       _retryClient = retryClient;

  final RequestSigner _signer;
  final TokenStore _tokens;
  final AppClock _clock;
  final Dio _retryClient;

  static const serverTimeHeader = 'x-server-time';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[RequestFlags.unsigned] == true) {
      return handler.next(options);
    }
    try {
      await _sign(options);
      handler.next(options);
    } on Object catch (e, s) {
      AppLogger.error('Could not sign request', e, s);
      handler.reject(
        DioException(
          requestOptions: options,
          error: e,
          type: DioExceptionType.unknown,
        ),
      );
    }
  }

  Future<void> _sign(RequestOptions options) async {
    final body = _encodeBody(options);
    // Only send a session id when the token is actually attached.
    final sessionId = options.headers.containsKey('Authorization')
        ? _tokens.sessionId
        : null;
    final headers = await _signer.headersFor(
      method: options.method,
      uri: options.uri,
      body: body,
      sessionId: sessionId,
    );
    options.headers.addAll(headers);
  }

  /// Serialises the body to the exact bytes that will be sent.
  static List<int> _encodeBody(RequestOptions options) {
    final data = options.data;
    if (data == null || (data is Map && data.isEmpty)) {
      options.data = null;
      return const [];
    }
    if (data is String) return utf8.encode(data);
    if (data is List<int>) return data;
    final text = jsonEncode(data);
    options.data = text;
    return utf8.encode(text);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final response = err.response;
    final options = err.requestOptions;
    final serverSeconds = int.tryParse(
      response?.headers.value(serverTimeHeader) ?? '',
    );
    if (response?.statusCode != 401 ||
        serverSeconds == null ||
        options.extra[RequestFlags.retried] == true ||
        options.extra[RequestFlags.unsigned] == true) {
      return handler.next(err);
    }
    _clock.updateServerTime(
      DateTime.fromMillisecondsSinceEpoch(serverSeconds * 1000, isUtc: true),
    );
    AppLogger.info('Device clock corrected from X-Server-Time; retrying');
    try {
      final retry = options.copyWith(
        extra: {...options.extra, RequestFlags.retried: true},
      );
      // The retry client signs again (fresh nonce) through this interceptor.
      handler.resolve(await _retryClient.fetch<dynamic>(retry));
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
