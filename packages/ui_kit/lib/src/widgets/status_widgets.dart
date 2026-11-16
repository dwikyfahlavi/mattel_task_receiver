import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../l10n/generated/app_localizations.dart';
import '../layout/device_profile.dart';

/// Tiny uppercase pill: AVAILABLE / UNAVAILABLE (A.2).
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.available, super.key});

  final bool available;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: available ? c.successSurface : c.dangerSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        available ? l10n.statusAvailable : l10n.statusUnavailable,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: available ? c.success : c.danger),
      ),
    );
  }
}

/// Full-width rounded status box (A.2).
class StatusBanner extends StatelessWidget {
  const StatusBanner({required this.available, super.key});

  final bool available;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final color = available ? c.success : c.danger;
    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: available ? c.successSurface : c.dangerSurface,
          borderRadius: BorderRadius.circular(AppShape.cardRadius),
        ),
        child: Column(
          children: [
            Text(
              available
                  ? l10n.bannerAvailableTitle
                  : l10n.bannerUnavailableTitle,
              style: theme.titleMedium?.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              available
                  ? l10n.bannerAvailableSubtitle
                  : l10n.bannerUnavailableSubtitle,
              style: theme.bodySmall?.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Avatar, name, role, status badge and the round history button (A.2).
class UserHeader extends StatelessWidget {
  const UserHeader({
    required this.name,
    required this.initials,
    required this.available,
    required this.onHistory,
    this.onLogout,
    this.onProfile,
    super.key,
  });

  final String name;
  final String initials;
  final bool available;
  final VoidCallback onHistory;
  final VoidCallback? onLogout;

  /// Tapping the avatar and name opens the profile.
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final watch = context.isWatch;
    final avatar = watch ? 40.0 : 44.0;
    final identity = Row(
      children: [
        ExcludeSemantics(
          child: CircleAvatar(
            radius: avatar / 2,
            backgroundColor: c.primary,
            child: Text(
              initials,
              style: theme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.titleMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              // Wraps on narrow screens (watch) instead of overflowing.
              Wrap(
                spacing: 8,
                runSpacing: 2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(l10n.roleTechnician, style: theme.bodySmall),
                  StatusBadge(available: available),
                ],
              ),
            ],
          ),
        ),
      ],
    );
    return Row(
      children: [
        Expanded(
          child: onProfile == null
              ? identity
              : Tooltip(
                  message: l10n.profileTooltip,
                  child: InkWell(
                    onTap: onProfile,
                    borderRadius: BorderRadius.circular(AppShape.buttonRadius),
                    child: Semantics(
                      button: true,
                      label: l10n.profileTooltip,
                      child: identity,
                    ),
                  ),
                ),
        ),
        if (onLogout != null)
          IconButton(
            tooltip: l10n.actionLogout,
            onPressed: onLogout,
            constraints: BoxConstraints.tight(Size.square(watch ? 48 : 44)),
            icon: Icon(LucideIcons.logOut, color: c.textMuted),
          ),
        const SizedBox(width: 4),
        // A.7 #9: history entry point with an accessible label.
        Tooltip(
          message: l10n.historyTooltip,
          child: Material(
            color: c.text,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onHistory,
              child: SizedBox.square(
                dimension: watch ? 48 : 44,
                child: Icon(
                  LucideIcons.history,
                  color: Colors.white,
                  size: 20,
                  semanticLabel: l10n.historyTooltip,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Visible whenever the backend is unreachable (doc 9.3 / 15).
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        color: c.text,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(LucideIcons.wifiOff, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(
              AppLocalizations.of(context).offlineBanner,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

enum NoticeTone { info, warning, blocking }

/// Shift-end warning and other inline notices.
class NoticeBanner extends StatelessWidget {
  const NoticeBanner({
    required this.message,
    this.tone = NoticeTone.info,
    super.key,
  });

  final String message;
  final NoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final (bg, fg, icon) = switch (tone) {
      NoticeTone.info => (c.infoSurface, c.primary, LucideIcons.info),
      NoticeTone.warning => (
        const Color(0xFFFFF4DB),
        const Color(0xFF8A5A00),
        LucideIcons.clock,
      ),
      NoticeTone.blocking => (
        c.dangerSurface,
        c.danger,
        LucideIcons.triangleAlert,
      ),
    };
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(AppShape.buttonRadius),
        ),
        child: Row(
          children: [
            Icon(icon, color: fg, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: fg),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
