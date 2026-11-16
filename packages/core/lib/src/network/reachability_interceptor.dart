import 'package:dio/dio.dart';

import '../connectivity/connectivity_service.dart';
import 'error_mapper.dart';

/// Feeds request outcomes into [ConnectivityService] so the offline banner
/// reflects real backend reachability.
class ReachabilityInterceptor extends Interceptor {
  ReachabilityInterceptor(this._connectivity);

  final ConnectivityService _connectivity;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _connectivity.reportReachable();
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      _connectivity.reportReachable();
    } else if (ErrorMapper.isConnectionError(err)) {
      _connectivity.reportUnreachable();
    }
    handler.next(err);
  }
}
