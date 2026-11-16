import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../task_session/bloc/task_session_bloc.dart';
import '../cubit/countdown_cubit.dart';

/// The assignment popup (doc 10.1, A.3/A.5/A.6).
///
/// * Not dismissible by back or outside tap.
/// * Keeps the screen on while visible.
/// * Only [CountdownChip] rebuilds every second (doc 7.3).
/// * Watch: side-button long press accepts (doc 10.2).
class TaskPopupScreen extends StatelessWidget {
  const TaskPopupScreen({
    required this.task,
    required this.userFirstName,
    this.watchAcceptKeyCodes = const {},
    super.key,
  });

  final TaskAssignment task;
  final String userFirstName;
  final Set<int> watchAcceptKeyCodes;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: KeepScreenOn(
        child: BlocProvider(
          // Rebuilt from expires_at, so it survives rotation and process death.
          key: ValueKey(task.taskId),
          create: (_) => CountdownCubit(
            clock: context.read<AppClock>(),
            expiresAtUtc: task.expiresAt,
          ),
          child: _CountdownEffects(
            child: context.isWatch
                ? HardwareKeyLongPress(
                    androidKeyCodes: watchAcceptKeyCodes,
                    onLongPress: () => context.read<TaskSessionBloc>().add(
                      const TaskAcceptPressed(),
                    ),
                    child: _WatchPopup(task: task),
                  )
                : _MobilePopup(task: task, userFirstName: userFirstName),
          ),
        ),
      ),
    );
  }
}

/// Escalates the alert in the last 10 s and reports expiry, without
/// rebuilding anything.
class _CountdownEffects extends StatelessWidget {
  const _CountdownEffects({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => BlocListener<CountdownCubit, int>(
    listenWhen: (prev, next) =>
        (prev > CountdownChip.urgentThreshold &&
            next <= CountdownChip.urgentThreshold) ||
        (prev > 0 && next == 0),
    listener: (context, secs) {
      final bloc = context.read<TaskSessionBloc>();
      if (secs == 0) {
        bloc.add(const TaskCountdownExpired());
      } else {
        bloc.add(const TaskCountdownUrgent());
      }
    },
    child: child,
  );
}

class _LiveCountdownChip extends StatelessWidget {
  const _LiveCountdownChip();

  @override
  Widget build(BuildContext context) => BlocBuilder<CountdownCubit, int>(
    builder: (context, secs) => CountdownChip(seconds: secs),
  );
}

/// Action row shared by all layouts. Disabled while offline or busy.
class _Actions extends StatelessWidget {
  const _Actions({required this.sideBySide});

  final bool sideBySide;

  Future<void> _reject(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final bloc = context.read<TaskSessionBloc>();
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.rejectConfirmTitle,
      body: l10n.rejectConfirmBody,
      confirmLabel: l10n.taskReject,
    );
    if (confirmed) bloc.add(const TaskRejectConfirmed());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return OnlineBuilder(
      builder: (context, online) =>
          BlocBuilder<TaskSessionBloc, TaskSessionState>(
            buildWhen: (a, b) =>
                a is! TaskAssigned ||
                b is! TaskAssigned ||
                a.action != b.action ||
                a.error != b.error,
            builder: (context, state) {
              final s = state is TaskAssigned ? state : null;
              final busy = s == null || s.action != TaskAction.none;
              final enabled = online && !busy;
              final accept = AppButton(
                label: l10n.taskAccept,
                variant: AppButtonVariant.success,
                loading: s?.action == TaskAction.accepting,
                onPressed: enabled
                    ? () => context.read<TaskSessionBloc>().add(
                        const TaskAcceptPressed(),
                      )
                    : null,
              );
              final reject = AppButton(
                label: l10n.taskReject,
                variant: AppButtonVariant.danger,
                loading: s?.action == TaskAction.rejecting,
                onPressed: enabled ? () => _reject(context) : null,
              );
              final error = s?.error;
              final checking = s?.action == TaskAction.checkingExpiry;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!online || error != null || checking)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        !online
                            ? l10n.offlineActionDisabled
                            : checking
                            ? l10n.taskExpiryChecking
                            : failureText(l10n, error!),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall
                            ?.copyWith(color: AppColors.of(context).danger),
                      ),
                    ),
                  if (sideBySide)
                    Row(
                      children: [
                        Expanded(child: accept),
                        const SizedBox(width: 12),
                        Expanded(child: reject),
                      ],
                    )
                  else ...[
                    accept,
                    const SizedBox(height: 10),
                    reject,
                  ],
                ],
              );
            },
          ),
    );
  }
}

class _MobilePopup extends StatelessWidget {
  const _MobilePopup({required this.task, required this.userFirstName});

  final TaskAssignment task;
  final String userFirstName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final tablet = context.isTablet;
    return Scaffold(
      backgroundColor: c.scrim,
      body: SafeArea(
        child: ModalCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.circleAlert, color: c.danger),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.taskNewTitle, style: theme.titleLarge),
                        Text(l10n.taskRespondWithin, style: theme.bodySmall),
                      ],
                    ),
                  ),
                  const _LiveCountdownChip(),
                ],
              ),
              const SizedBox(height: 16),
              // Content scrolls; the actions stay visible (A.7 #3).
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.taskGreeting(userFirstName),
                        style: theme.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      MachineCard(machineCode: task.machineCode),
                      const SizedBox(height: 12),
                      InfoRow(
                        kind: InfoRowKind.location,
                        label: l10n.taskLocation(task.location),
                      ),
                      const SizedBox(height: 8),
                      InfoRow(kind: InfoRowKind.problem, label: task.issue),
                      const SizedBox(height: 12),
                      InfoBox(text: l10n.taskInstruction),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _Actions(sideBySide: tablet),
            ],
          ),
        ),
      ),
    );
  }
}

/// High-contrast full-screen popup for the 640x480 watch (A.3).
class _WatchPopup extends StatelessWidget {
  const _WatchPopup({required this.task});

  final TaskAssignment task;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(LucideIcons.circleAlert, color: c.danger, size: 26),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(l10n.taskNewTitle, style: theme.titleLarge),
                  ),
                  const _LiveCountdownChip(),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MachineCard(machineCode: task.machineCode),
                      const SizedBox(height: 8),
                      InfoRow(
                        kind: InfoRowKind.location,
                        label: l10n.taskLocation(task.location),
                      ),
                      const SizedBox(height: 6),
                      InfoRow(kind: InfoRowKind.problem, label: task.issue),
                      const SizedBox(height: 6),
                      Text(l10n.taskHardwareKeyHint, style: theme.bodySmall),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const _Actions(sideBySide: true),
            ],
          ),
        ),
      ),
    );
  }
}
