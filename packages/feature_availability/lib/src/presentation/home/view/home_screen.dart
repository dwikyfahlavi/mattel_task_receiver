import 'dart:async';

import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../availability/bloc/availability_bloc.dart';
import '../../readiness/view/readiness_sheet.dart';
import '../../shift_end/cubit/shift_end_cubit.dart';
import '../widgets/stream_listener.dart';

/// Home for phone, tablet (A.5/A.6) and watch (A.3).
///
/// Expects `AvailabilityBloc`, `TaskSessionBloc`, `ShiftEndCubit` and
/// `SessionCubit` above it.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.session,
    required this.onOpenHistory,
    this.onScanQr,
    this.onOpenProfile,
    super.key,
  });

  final SessionInfo session;
  final VoidCallback onOpenHistory;

  /// Profile, attendance and (phone) my watches.
  final VoidCallback? onOpenProfile;

  /// Phone and tablet only: opens the watch pairing scanner.
  final VoidCallback? onScanQr;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AvailabilityBloc, AvailabilityState>(
          listenWhen: (a, b) => a.readiness == null && b.readiness != null,
          listener: _showReadiness,
        ),
        BlocListener<AvailabilityBloc, AvailabilityState>(
          listenWhen: (a, b) => a.checkOutQueuedCount != b.checkOutQueuedCount,
          listener: (context, _) =>
              _snack(context, AppLocalizations.of(context).checkOutQueued),
        ),
        BlocListener<AvailabilityBloc, AvailabilityState>(
          listenWhen: (a, b) =>
              a.checkOutBlockedCount != b.checkOutBlockedCount,
          listener: (context, _) =>
              _snack(context, AppLocalizations.of(context).checkOutBlocked),
        ),
        BlocListener<AvailabilityBloc, AvailabilityState>(
          listenWhen: (a, b) =>
              a.checkOutConflictCount != b.checkOutConflictCount,
          listener: (context, _) =>
              _snack(context, AppLocalizations.of(context).checkOutConflict),
        ),
        BlocListener<AvailabilityBloc, AvailabilityState>(
          listenWhen: (a, b) => b.error != null && a.error != b.error,
          listener: (context, state) => _snack(
            context,
            failureText(AppLocalizations.of(context), state.error!),
          ),
        ),
      ],
      child: StreamListener(
        stream: context.read<TaskSessionBloc>().notices,
        onEvent: (context, TaskNotice notice) {
          final l10n = AppLocalizations.of(context);
          _snack(context, switch (notice) {
            TaskNotice.alreadyResolved => l10n.taskAlreadyResolved,
            TaskNotice.completed => l10n.taskCompleted,
            TaskNotice.acceptedElsewhere => l10n.taskAcceptedElsewhere,
            TaskNotice.conflict => l10n.taskConflict,
            TaskNotice.offline => l10n.offlineActionDisabled,
          });
        },
        child: _ReadinessOnMount(
          child: context.isWatch
              ? _WatchHome(
                  session: session,
                  onOpenHistory: onOpenHistory,
                  onOpenProfile: onOpenProfile,
                )
              : _MobileHome(
                  session: session,
                  onOpenHistory: onOpenHistory,
                  onScanQr: onScanQr,
                  onOpenProfile: onOpenProfile,
                ),
        ),
      ),
    );
  }

  static Future<void> _showReadiness(
    BuildContext context,
    AvailabilityState state,
  ) async {
    final report = state.readiness;
    if (report == null) return;
    final bloc = context.read<AvailabilityBloc>();
    // A background check only explains the problem; "Tetap Check In" is
    // offered only when the user tapped Check In.
    final forCheckIn = state.readinessForCheckIn;
    final proceed = await showReadinessSheet(
      context,
      report,
      offerCheckIn: forCheckIn,
    );
    bloc.add(const ReadinessDismissed());
    if (proceed && forCheckIn) {
      bloc.add(const CheckInPressed(skipWarnings: true));
    }
  }

  static void _snack(BuildContext context, String text) {
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }
}

/// When Home appears: shows a report that was raised before Home existed
/// (otherwise it would stay pending and block later checks), and on the
/// watch runs the start-up readiness check (doc 12).
class _ReadinessOnMount extends StatefulWidget {
  const _ReadinessOnMount({required this.child});

  final Widget child;

  @override
  State<_ReadinessOnMount> createState() => _ReadinessOnMountState();
}

class _ReadinessOnMountState extends State<_ReadinessOnMount> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final bloc = context.read<AvailabilityBloc>();
      if (bloc.state.readiness != null) {
        unawaited(HomeScreen._showReadiness(context, bloc.state));
      } else if (context.isWatch) {
        bloc.add(const ReadinessRecheckRequested());
      }
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Keluar: blocked while a job is In Progress (doc 4.2 rule 6), asks for
/// confirmation, checks out directly, then ends the session.
Future<void> logoutWithConfirm(BuildContext context) async {
  final l10n = AppLocalizations.of(context);
  final tasks = context.read<TaskSessionBloc>();
  final session = context.read<SessionCubit>();
  final availability = context.read<AvailabilityBloc>();
  if (tasks.state.isInProgress) {
    HomeScreen._snack(context, l10n.checkOutBlocked); // doc 4.2 rule 6
    return;
  }
  final ok = await showConfirmDialog(
    context,
    title: l10n.logoutConfirmTitle,
    body: l10n.logoutConfirmBody,
    confirmLabel: l10n.actionLogout,
  );
  if (!ok) return;
  availability.add(const ImmediateCheckOut());
  await session.end(SessionEndReason.logout);
}

void _checkOut(BuildContext context, SessionInfo session) => context
    .read<AvailabilityBloc>()
    .add(CheckOutPressed(sessionExpiresAt: session.policy.sessionExpiresAt));

/// "Batalkan Penugasan" (backend cancel, checks the technician out).
Future<void> _cancelTask(BuildContext context) async {
  final bloc = context.read<TaskSessionBloc>();
  if (await confirmCancelTask(context)) bloc.add(const TaskCancelConfirmed());
}

class _ShiftBannerView extends StatelessWidget {
  const _ShiftBannerView();

  @override
  Widget build(BuildContext context) => BlocBuilder<ShiftEndCubit, ShiftBanner>(
    builder: (context, banner) {
      final l10n = AppLocalizations.of(context);
      final clock = context.read<AppClock>();
      return switch (banner) {
        NoShiftBanner() => const SizedBox.shrink(),
        ShiftEndingBanner(:final cutoff) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NoticeBanner(
            message: l10n.sessionEndsAt(clock.formatTime(cutoff)),
            tone: NoticeTone.warning,
          ),
        ),
        ShiftBlockedBanner() => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: NoticeBanner(
            message: l10n.sessionEndBlocked,
            tone: NoticeTone.blocking,
          ),
        ),
      };
    },
  );
}

/// Main availability action. Check In when Unavailable; Check Out when
/// Available (A.7 #1), disabled with the reason while In Progress.
class _AvailabilityAction extends StatelessWidget {
  const _AvailabilityAction({required this.session});

  final SessionInfo session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final watch = context.isWatch;
    return OnlineBuilder(
      builder: (context, online) =>
          BlocBuilder<AvailabilityBloc, AvailabilityState>(
            builder: (context, a) =>
                BlocBuilder<TaskSessionBloc, TaskSessionState>(
                  buildWhen: (x, y) => x.isInProgress != y.isInProgress,
                  builder: (context, t) {
                    if (!a.available) {
                      return Column(
                        children: [
                          AppButton(
                            label: l10n.checkInButton,
                            icon: LucideIcons.logIn,
                            loading: a.busy == AvailabilityBusy.checkingIn,
                            // Check In requires network (doc 16).
                            onPressed: online
                                ? () => context.read<AvailabilityBloc>().add(
                                    const CheckInPressed(),
                                  )
                                : null,
                          ),
                          if (!online) ...[
                            const SizedBox(height: 6),
                            Text(
                              l10n.offlineActionDisabled,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      );
                    }
                    final blocked = t.isInProgress;
                    return Column(
                      children: [
                        AppButton(
                          label: watch
                              ? l10n.watchCheckOutButton
                              : l10n.checkOutButton,
                          variant: watch
                              ? AppButtonVariant.danger
                              : AppButtonVariant.outlined,
                          icon: LucideIcons.logOut,
                          loading: a.busy == AvailabilityBusy.checkingOut,
                          onPressed: blocked
                              ? null
                              : () => _checkOut(context, session),
                        ),
                        if (blocked) ...[
                          const SizedBox(height: 6),
                          Text(
                            l10n.checkOutBlocked,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.of(context).danger),
                          ),
                        ],
                      ],
                    );
                  },
                ),
          ),
    );
  }
}

class _StatusTexts extends StatelessWidget {
  const _StatusTexts();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final clock = context.read<AppClock>();
    return BlocBuilder<AvailabilityBloc, AvailabilityState>(
      buildWhen: (a, b) =>
          a.available != b.available || a.checkedInAt != b.checkedInAt,
      builder: (context, a) {
        final at = a.checkedInAt;
        return Column(
          children: [
            Text(
              a.available ? l10n.checkInSuccessTitle : l10n.homeReadyTitle,
              style: theme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              a.available && at != null
                  ? clock.formatDateTime(at)
                  : l10n.homeReadySubtitle,
              style: theme.bodyMedium?.copyWith(
                color: AppColors.of(context).textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 14),
            StatusBanner(available: a.available),
          ],
        );
      },
    );
  }
}

class _InProgressSection extends StatelessWidget {
  const _InProgressSection({this.showButton = true});

  final bool showButton;

  @override
  Widget build(BuildContext context) => OnlineBuilder(
    builder: (context, online) =>
        BlocBuilder<TaskSessionBloc, TaskSessionState>(
          builder: (context, s) => switch (s) {
            TaskInProgress(:final task, :final acceptedAt, :final action) =>
              Padding(
                padding: const EdgeInsets.only(top: 14),
                child: InProgressCard(
                  task: task,
                  acceptedAt: acceptedAt,
                  cancelling: action == TaskAction.cancelling,
                  // Cancel requires network (doc 16).
                  onCancel: showButton && online
                      ? () => _cancelTask(context)
                      : null,
                ),
              ),
            _ => const SizedBox.shrink(),
          },
        ),
  );
}

class _MobileHome extends StatelessWidget {
  const _MobileHome({
    required this.session,
    required this.onOpenHistory,
    this.onScanQr,
    this.onOpenProfile,
  });

  final SessionInfo session;
  final VoidCallback onOpenHistory;
  final VoidCallback? onScanQr;
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<AvailabilityBloc>().add(const AvailabilityRefreshed());
            context.read<TaskSessionBloc>().add(const TaskReconcileRequested());
          },
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              MaxWidth(
                child: Column(
                  children: [
                    BlocBuilder<AvailabilityBloc, AvailabilityState>(
                      buildWhen: (a, b) => a.available != b.available,
                      builder: (context, a) => UserHeader(
                        name: session.user.name,
                        initials: session.user.initials,
                        available: a.available,
                        onHistory: onOpenHistory,
                        onProfile: onOpenProfile,
                        onLogout: () => logoutWithConfirm(context),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _ShiftBannerView(),
                    BlocBuilder<AvailabilityBloc, AvailabilityState>(
                      buildWhen: (a, b) => a.available != b.available,
                      builder: (context, a) =>
                          TechnicianIllustration(available: a.available),
                    ),
                    const SizedBox(height: 16),
                    const _StatusTexts(),
                    const _InProgressSection(),
                    const SizedBox(height: 20),
                    _AvailabilityAction(session: session),
                    if (onScanQr != null) ...[
                      const SizedBox(height: 10),
                      AppButton(
                        label: l10n.scanQrButton,
                        icon: LucideIcons.scanLine,
                        variant: AppButtonVariant.secondary,
                        onPressed: onScanQr,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.scanQrCaption,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact watch home without illustration (A.3). The main action is pinned
/// at the bottom so it is always reachable on the 2.8" screen; the status
/// content scrolls above it.
class _WatchHome extends StatelessWidget {
  const _WatchHome({
    required this.session,
    required this.onOpenHistory,
    this.onOpenProfile,
  });

  final SessionInfo session;
  final VoidCallback onOpenHistory;
  final VoidCallback? onOpenProfile;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            BlocBuilder<AvailabilityBloc, AvailabilityState>(
              buildWhen: (a, b) => a.available != b.available,
              builder: (context, a) => UserHeader(
                name: session.user.name,
                initials: session.user.initials,
                available: a.available,
                onHistory: onOpenHistory,
                onProfile: onOpenProfile,
                onLogout: () => logoutWithConfirm(context),
              ),
            ),
            const SizedBox(height: 6),
            const Expanded(
              // Small, fixed content: build all of it (screen readers too).
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _ShiftBannerView(),
                    _StatusTexts(),
                    _InProgressSection(showButton: false),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            _WatchPrimaryAction(session: session),
          ],
        ),
      ),
    ),
  );
}

/// Watch bottom action: while a job is In Progress, Check Out is blocked
/// (doc 4.2 rule 6) and the pinned action is "Batalkan Penugasan" (D-22);
/// otherwise Check In / Check Out.
class _WatchPrimaryAction extends StatelessWidget {
  const _WatchPrimaryAction({required this.session});

  final SessionInfo session;

  @override
  Widget build(BuildContext context) => OnlineBuilder(
    builder: (context, online) =>
        BlocBuilder<TaskSessionBloc, TaskSessionState>(
          buildWhen: (a, b) =>
              a.isInProgress != b.isInProgress ||
              (a is TaskInProgress &&
                  b is TaskInProgress &&
                  a.action != b.action),
          builder: (context, t) {
            if (t is! TaskInProgress) {
              return _AvailabilityAction(session: session);
            }
            final l10n = AppLocalizations.of(context);
            final cancelling = t.action == TaskAction.cancelling;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.checkOutBlocked,
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.of(context).danger),
                ),
                const SizedBox(height: 4),
                AppButton(
                  label: l10n.cancelTaskButton,
                  variant: AppButtonVariant.outlined,
                  loading: cancelling,
                  onPressed: online && !cancelling
                      ? () => _cancelTask(context)
                      : null,
                ),
              ],
            );
          },
        ),
  );
}
