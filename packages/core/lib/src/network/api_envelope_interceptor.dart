import 'package:dio/dio.dart';

/// Unwraps the success envelope `{ "status_code", "message", "data" }` so
/// Retrofit DTOs map `data` directly.
///
/// Paged lists carry `pagination` next to `data`; they become
/// `{ "items": [...], "pagination": {...} }` so a page DTO can hold both.
class ApiEnvelopeInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    response.data = unwrap(response.data);
    handler.next(response);
  }

  static Object? unwrap(Object? body) {
    if (body is! Map || !body.containsKey('data')) return body;
    if (!body.containsKey('status_code') && !body.containsKey('statusCode')) {
      return body;
    }
    final data = body['data'];
    final pagination = body['pagination'];
    if (pagination is Map) {
      return <String, dynamic>{
        'items': data ?? const [],
        'pagination': pagination,
      };
    }
    return data;
  }
}
