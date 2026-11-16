import 'dart:io' show HttpDate, HttpException;

import 'package:dio/dio.dart';

import '../time/app_clock.dart';

/// Refreshes the server clock offset from the `Date` header of every
/// response, including error responses (doc 7.3 / 11).
class ServerTimeInterceptor extends Interceptor {
  ServerTimeInterceptor(this._clock);

  final AppClock _clock;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _read(response);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response != null) _read(response);
    handler.next(err);
  }

  void _read(Response<dynamic> response) {
    final raw = response.headers.value('date');
    if (raw == null) return;
    try {
      _clock.updateServerTime(HttpDate.parse(raw));
    } on HttpException {
      // Malformed header: keep the previous offset.
    } on FormatException {
      // Malformed header: keep the previous offset.
    }
  }
}
