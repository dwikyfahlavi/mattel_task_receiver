import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/task_dtos.dart';
import '../../../data/task_repository.dart';

part 'work_order_detail_cubit.freezed.dart';
part 'work_order_detail_state.dart';

/// `GET /technicians/me/work-orders/{id}`. Screen-scoped.
class WorkOrderDetailCubit extends Cubit<WorkOrderDetailState> {
  WorkOrderDetailCubit(this._repo, this.workOrderId)
    : super(const WorkOrderDetailState.loading());

  final TaskRepository _repo;
  final String workOrderId;

  Future<void> load() async {
    emit(const WorkOrderDetailState.loading());
    final r = await _repo.detail(workOrderId);
    if (isClosed) return;
    emit(r.fold(WorkOrderDetailState.loaded, WorkOrderDetailState.failed));
  }
}
