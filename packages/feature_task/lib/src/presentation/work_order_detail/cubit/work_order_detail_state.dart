part of 'work_order_detail_cubit.dart';

@freezed
sealed class WorkOrderDetailState with _$WorkOrderDetailState {
  const factory WorkOrderDetailState.loading() = WorkOrderDetailLoading;
  const factory WorkOrderDetailState.loaded(WorkOrderDto workOrder) =
      WorkOrderDetailLoaded;
  const factory WorkOrderDetailState.failed(Failure failure) =
      WorkOrderDetailFailed;
}
