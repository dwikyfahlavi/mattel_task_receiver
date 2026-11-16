import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui_kit/ui_kit.dart';

import '../widgets/watch_layout.dart';

/// Watch welcome (A.3).
class WatchWelcomeScreen extends StatelessWidget {
  const WatchWelcomeScreen({
    required this.onLoginWithQr,
    required this.year,
    this.sessionEndMessage,
    super.key,
  });

  final VoidCallback onLoginWithQr;
  final int year;
  final String? sessionEndMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, box) {
            final compact = box.maxHeight < compactWatchHeight;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: box.maxHeight - 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppLogoHeader(size: compact ? 24 : 36, centered: true),
                    Column(
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          l10n.watchWelcomeTitle,
                          style: theme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.watchWelcomeSubtitle,
                          style: theme.bodyMedium?.copyWith(
                            color: AppColors.of(context).textMuted,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (sessionEndMessage != null) ...[
                          const SizedBox(height: 8),
                          NoticeBanner(message: sessionEndMessage!),
                        ],
                        const SizedBox(height: 8),
                      ],
                    ),
                    Column(
                      children: [
                        AppButton(
                          label: l10n.watchLoginWithQr,
                          variant: AppButtonVariant.brand,
                          onPressed: onLoginWithQr,
                        ),
                        if (!compact) ...[
                          const SizedBox(height: 6),
                          CopyrightText(year: year),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
