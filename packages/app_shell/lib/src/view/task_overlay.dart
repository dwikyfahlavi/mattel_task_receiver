import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_availability/feature_availability.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Shows the task popup, accepted and result screens above every route
/// while signed in, so an assignment is never hidden behind another
/// screen (doc 9.2, 10.1). A nested Navigator gives dialogs (Tolak
/// confirmation) a route context.
class TaskOverlay extends StatelessWidget {
  const TaskOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final config = context.read<AppConfig>();
    return BlocBuilder<SessionCubit, SessionState>(
      buildWhen: (a, b) => a.infoOrNull?.user != b.infoOrNull?.user,
      builder: (context, session) {
        final info = session.infoOrNull;
        if (info == null) return child;
        return BlocBuilder<TaskSessionBloc, TaskSessionState>(
          buildWhen: (a, b) => _key(a) != _key(b),
          builder: (context, task) {
            final overlay = switch (task) {
              TaskAssigned(:final task) => TaskPopupScreen(
                task: task,
                userFirstName: info.user.firstName,
                watchAcceptKeyCodes: config.watchAcceptKeyCodes,
              ),
              TaskInProgress(
                :final task,
                :final acceptedAt,
                showAcceptedScreen: true,
              ) =>
                TaskAcceptedScreen(task: task, acceptedAt: acceptedAt),
              TaskResult(:final outcome) => TaskResultScreen(
                outcome: outcome,
                userFirstName: info.user.firstName,
                onCheckIn: () => context.read<AvailabilityBloc>().add(
                  const CheckInPressed(),
                ),
              ),
              _ => null,
            };
            if (overlay == null) return child;
            return Stack(
              children: [
                ExcludeFocus(child: ExcludeSemantics(child: child)),
                Positioned.fill(
                  child: Navigator(
                    key: ValueKey(_key(task)),
                    pages: [MaterialPage<void>(child: overlay)],
                    onDidRemovePage: (_) {},
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// Identity of what the overlay shows; equal keys keep widget state.
  static String _key(TaskSessionState s) => switch (s) {
    TaskAssigned(:final task) => 'assigned:${task.taskId}',
    TaskInProgress(:final task, showAcceptedScreen: true) =>
      'accepted:${task.taskId}',
    TaskResult(:final outcome) => 'result:${outcome.task.taskId}',
    _ => 'none',
  };
}
