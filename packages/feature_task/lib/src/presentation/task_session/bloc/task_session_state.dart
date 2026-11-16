part of 'task_session_bloc.dart';

/// Pending user action on the assignment popup or the In Progress card.
enum TaskAction { none, accepting, rejecting, cancelling, checkingExpiry }

/// App-scoped task state (doc 4.1 / 7.1).
@freezed
sealed class TaskSessionState with _$TaskSessionState {
  const TaskSessionState._();

  /// Nothing to show.
  const factory TaskSessionState.idle() = TaskIdle;

  /// Popup visible with a running countdown.
  const factory TaskSessionState.assigned({
    required TaskAssignment task,
    @Default(TaskAction.none) TaskAction action,
    Failure? error,
  }) = TaskAssigned;

  /// Accepted until the repair is finished (`work-order:updated COMPLETED`,
  /// D-22: the technician has no Selesai action). Blocks Check Out and new
  /// popups (doc 4.2 rule 6). [showAcceptedScreen] is true right after
  /// accepting so the "Penugasan Diterima" screens are shown once.
  const factory TaskSessionState.inProgress({
    required TaskAssignment task,
    required DateTime acceptedAt,
    @Default(false) bool showAcceptedScreen,
    @Default(TaskAction.none) TaskAction action,
    Failure? error,
  }) = TaskInProgress;

  /// Result / missed-task explanation (doc 10.3).
  const factory TaskSessionState.result({required TaskOutcome outcome}) =
      TaskResult;

  bool get isInProgress => this is TaskInProgress;

  /// True while an assignment needs an answer (no restart, no logout).
  bool get isAssigned => this is TaskAssigned;
}

/// One-shot messages for snackbars.
enum TaskNotice {
  /// Answered on another device, or by the timer, first.
  alreadyResolved,

  /// The repair of the job In Progress was recorded as finished.
  completed,

  /// Accepted on the technician's other device.
  acceptedElsewhere,

  /// The server state differed and was reloaded.
  conflict,
  offline,
}
