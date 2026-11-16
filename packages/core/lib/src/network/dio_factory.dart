import 'dart:io' show HttpClient;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import '../connectivity/connectivity_service.dart';
import '../device/device_identity.dart';
import '../logging/app_logger.dart';
import '../session/session_events.dart';
import '../storage/token_store.dart';
import '../time/app_clock.dart';
import 'api_envelope_interceptor.dart';
import 'auth_interceptor.dart';
import 'certificate_pinning.dart';
import 'device_signing_interceptor.dart';
import 'reachability_interceptor.dart';
import 'server_time_interceptor.dart';

/// Builds the app's single [Dio] instance.
///
/// Interceptor order: server time, reachability, envelope unwrap, auth,
/// device signing (watch, last so nothing changes a signed request), and
/// (debug builds only) a redacting log. Retrofit clients use relative paths
/// (`technicians/me/state`) against a base URL ending in `/`.
abstract final class DioFactory {
  static const connectTimeout = Duration(seconds: 10);
  static const receiveTimeout = Duration(seconds: 15);

  static Dio create({
    required AppConfig config,
    required AppClock clock,
    required TokenStore tokens,
    required SessionEventBus sessionEvents,
    required ConnectivityService connectivity,
    RequestSigner? signer,
    HttpClientAdapter? adapter,
  }) {
    final dio = Dio(baseOptions(config))
      ..httpClientAdapter = adapter ?? pinnedAdapter(config.certificatePins);
    dio.interceptors.addAll([
      ServerTimeInterceptor(clock),
      ReachabilityInterceptor(connectivity),
      ApiEnvelopeInterceptor(),
      AuthInterceptor(tokens: tokens, sessionEvents: sessionEvents),
      if (signer != null)
        DeviceSigningInterceptor(
          signer: signer,
          tokens: tokens,
          clock: clock,
          retryClient: dio,
        ),
      if (kDebugMode) _RedactedLogInterceptor(),
    ]);
    return dio;
  }

  static BaseOptions baseOptions(AppConfig config) {
    final raw = config.apiBaseUrl.toString();
    return BaseOptions(
      baseUrl: raw.endsWith('/') ? raw : '$raw/',
      connectTimeout: connectTimeout,
      sendTimeout: receiveTimeout,
      receiveTimeout: receiveTimeout,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
    );
  }

  /// HTTPS adapter with SPKI pinning when [pins] is not empty (doc 17.1).
  static HttpClientAdapter pinnedAdapter(List<String> pins) =>
      IOHttpClientAdapter(
        createHttpClient: () => HttpClient()
          // Never accept certificates the platform trust store rejects.
          ..badCertificateCallback = (_, _, _) => false,
        validateCertificate: pins.isEmpty
            ? null
            : (certificate, host, port) =>
                  certificate != null &&
                  CertificatePinning.matches(certificate.der, pins),
      );
}

/// Logs method, path and status only. Never headers or bodies (doc 17.1).
class _RedactedLogInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final o = response.requestOptions;
    AppLogger.debug('HTTP ${o.method} ${o.path} -> ${response.statusCode}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final o = err.requestOptions;
    AppLogger.debug(
      'HTTP ${o.method} ${o.path} -> ${err.response?.statusCode ?? err.type.name}',
    );
    handler.next(err);
  }
}
