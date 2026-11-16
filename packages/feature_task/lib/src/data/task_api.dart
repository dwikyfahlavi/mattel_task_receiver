import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'task_dtos.dart';

part 'task_api.g.dart';

/// Work-order endpoints (docs/api_contract.md). Paths are relative to the
/// base URL. On the watch every call is signed by the Dio interceptor.
@RestApi()
abstract class TaskApi {
  factory TaskApi(Dio dio, {String? baseUrl}) = _TaskApi;

  /// Same content as the `state:snapshot` socket event.
  @GET('technicians/me/state')
  Future<dynamic> state();

  /// `{ work_order, status }`.
  @POST('technicians/me/work-orders/{id}/accept')
  Future<dynamic> accept(@Path('id') String workOrderId);

  /// Declining checks the technician out.
  @POST('technicians/me/work-orders/{id}/decline')
  Future<dynamic> decline(@Path('id') String workOrderId);

  /// Only after accepting; checks the technician out.
  @POST('technicians/me/work-orders/{id}/cancel')
  Future<dynamic> cancel(@Path('id') String workOrderId);

  /// Newest first. [status] is a comma-separated list of display statuses;
  /// [from] / [to] are `YYYY-MM-DD`.
  @GET('technicians/me/work-orders')
  Future<WorkOrderPageDto> workOrders({
    @Query('status') String? status,
    @Query('from') String? from,
    @Query('to') String? to,
    @Query('page') int? page,
    @Query('perPage') int? perPage,
  });

  @GET('technicians/me/work-orders/{id}')
  Future<WorkOrderDto> workOrder(@Path('id') String workOrderId);
}
