import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/ui_kit.dart';

import '../../../data/auth_dtos.dart';
import '../../../data/auth_repository.dart';
import '../cubit/profile_cubit.dart';

/// "Profil": KPK, name, shift, masked phone; entry to "Riwayat Kehadiran";
/// on the phone also "Watch Saya" with Putuskan (unpair).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.repository,
    required this.user,
    required this.onBack,
    required this.showWatches,
    this.onOpenAttendance,
    this.onLogout,
    super.key,
  });

  final AuthRepository repository;

  /// Shown at once, before the profile call answers.
  final UserProfile user;
  final VoidCallback onBack;

  /// Phone and tablet: list and unpair watches.
  final bool showWatches;
  final VoidCallback? onOpenAttendance;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => ProfileCubit(
      repository: repository,
      showWatches: showWatches,
      realtime: context.read<RealtimeService>(),
    )..load(),
    child: BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (a, b) =>
          a.unpairedCount != b.unpairedCount ||
          (b.actionError != null && a.actionError != b.actionError),
      listener: (context, state) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.maybeOf(context)
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                state.actionError != null
                    ? failureText(l10n, state.actionError!)
                    : l10n.unpairDone,
              ),
            ),
          );
      },
      child: _ProfileView(
        user: user,
        onBack: onBack,
        onOpenAttendance: onOpenAttendance,
        onLogout: onLogout,
      ),
    ),
  );
}

class _ProfileView extends StatelessWidget {
  const _ProfileView({
    required this.user,
    required this.onBack,
    this.onOpenAttendance,
    this.onLogout,
  });

  final UserProfile user;
  final VoidCallback onBack;
  final VoidCallback? onOpenAttendance;
  final VoidCallback? onLogout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final c = AppColors.of(context);
    final clock = context.read<AppClock>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: onBack,
        ),
        title: Text(l10n.profileTitle),
      ),
      body: MaxWidth(
        maxWidth: 640,
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();
            final p = state.profile;
            final rows = <(String, String)>[
              (l10n.profileKpk, '${p?.kpk ?? user.kpk}'),
              if ((p?.shift ?? user.shift) != null)
                (l10n.profileShift, (p?.shift ?? user.shift)!),
              if (p?.phoneNumberMasked != null)
                (l10n.profilePhone, p!.phoneNumberMasked!),
              if (p?.memberSince != null)
                (l10n.profileMemberSince, clock.formatDate(p!.memberSince!)),
              if (p != null)
                (
                  l10n.profileStatus,
                  p.isActive ? l10n.profileActive : l10n.profileInactive,
                ),
            ];
            return RefreshIndicator(
              onRefresh: cubit.load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: c.primary,
                        child: Text(
                          user.initials,
                          style: theme.titleLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p?.name ?? user.name, style: theme.titleLarge),
                            Text(l10n.roleTechnician, style: theme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (state.loadingProfile && p == null)
                    const SkeletonBox()
                  else ...[
                    _InfoTable(rows: rows),
                    if (state.profileError != null) ...[
                      const SizedBox(height: 8),
                      NoticeBanner(
                        message: l10n.profileLoadFailed,
                        tone: NoticeTone.warning,
                      ),
                    ],
                  ],
                  if (onOpenAttendance != null) ...[
                    const SizedBox(height: 12),
                    _NavTile(
                      icon: LucideIcons.calendarClock,
                      label: l10n.profileAttendance,
                      onTap: onOpenAttendance!,
                    ),
                  ],
                  if (cubit.showWatches) ...[
                    const SizedBox(height: 20),
                    Text(l10n.myWatchesTitle, style: theme.titleMedium),
                    const SizedBox(height: 8),
                    _Watches(state: state),
                  ],
                  if (onLogout != null) ...[
                    const SizedBox(height: 24),
                    AppButton(
                      label: l10n.actionLogout,
                      icon: LucideIcons.logOut,
                      variant: AppButtonVariant.outlined,
                      onPressed: onLogout,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _InfoTable extends StatelessWidget {
  const _InfoTable({required this.rows});

  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: c.border),
        borderRadius: BorderRadius.circular(AppShape.cardRadius),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 1, color: c.border),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      rows[i].$1,
                      style: theme.bodySmall?.copyWith(color: c.textMuted),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      rows[i].$2,
                      textAlign: TextAlign.end,
                      style: theme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Material(
      color: c.surface,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: c.border),
        borderRadius: BorderRadius.circular(AppShape.cardRadius),
      ),
      child: ListTile(
        leading: Icon(icon, color: c.primary),
        title: Text(label),
        trailing: const Icon(LucideIcons.chevronRight),
        onTap: onTap,
      ),
    );
  }
}

class _Watches extends StatelessWidget {
  const _Watches({required this.state});

  final ProfileState state;

  Future<void> _confirmUnpair(BuildContext context, PairedWatchDto w) async {
    final l10n = AppLocalizations.of(context);
    final cubit = context.read<ProfileCubit>();
    final ok = await showConfirmDialog(
      context,
      title: l10n.unpairConfirmTitle(w.device.name ?? l10n.watchUnnamed),
      body: l10n.unpairConfirmBody,
      confirmLabel: l10n.unpairButton,
    );
    if (ok) await cubit.unpair(w.sessionId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final c = AppColors.of(context);
    final theme = Theme.of(context).textTheme;
    final clock = context.read<AppClock>();
    if (state.loadingWatches && state.watches.isEmpty) {
      return const SkeletonBox();
    }
    if (state.watches.isEmpty) {
      return Text(
        state.watchesError != null
            ? l10n.myWatchesLoadFailed
            : l10n.myWatchesEmpty,
        style: theme.bodyMedium?.copyWith(color: c.textMuted),
      );
    }
    return Column(
      children: [
        for (final w in state.watches)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: c.border),
                borderRadius: BorderRadius.circular(AppShape.cardRadius),
              ),
              child: Row(
                children: [
                  Icon(LucideIcons.watch, color: c.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          w.device.name ?? l10n.watchUnnamed,
                          style: theme.titleMedium,
                        ),
                        if (w.device.location != null)
                          Text(
                            l10n.taskLocation(w.device.location!),
                            style: theme.bodySmall,
                          ),
                        if (w.pairedAt != null)
                          Text(
                            l10n.watchPairedSince(
                              clock.formatDateTime(w.pairedAt!),
                            ),
                            style: theme.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  AppButton(
                    label: l10n.unpairButton,
                    variant: AppButtonVariant.outlined,
                    expand: false,
                    loading: state.unpairing == w.sessionId,
                    onPressed: state.unpairing == null
                        ? () => _confirmUnpair(context, w)
                        : null,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
