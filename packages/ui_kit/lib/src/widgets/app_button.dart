import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../layout/device_profile.dart';

enum AppButtonVariant { primary, success, danger, brand, secondary, outlined }

/// Full-width button with the A.2 variants, an optional leading icon, a
/// trailing badge ("Check In" + UNAVAILABLE) and a loading state.
///
/// On the watch the minimum height is 64 dp (doc 15 watch rule 1).
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.trailing,
    this.loading = false,
    this.expand = true,
    this.semanticsHint,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final Widget? trailing;
  final bool loading;
  final bool expand;
  final String? semanticsHint;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final watch = context.isWatch;
    final enabled = onPressed != null && !loading;
    final (bg, fg, border) = _colors(c);
    final disabledBg = variant == AppButtonVariant.brand
        ? c.brandDisabled
        : variant == AppButtonVariant.outlined ||
              variant == AppButtonVariant.secondary
        ? c.surfaceMuted
        : bg.withValues(alpha: 0.45);
    final disabledFg =
        variant == AppButtonVariant.outlined ||
            variant == AppButtonVariant.secondary
        ? c.textDisabled
        : Colors.white;

    final content = Row(
      mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: enabled ? fg : disabledFg,
            ),
          )
        else if (icon != null)
          Icon(icon, size: watch ? 22 : 18),
        if (loading || icon != null) const SizedBox(width: 8),
        Flexible(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 8), trailing!],
      ],
    );

    return Semantics(
      button: true,
      enabled: enabled,
      hint: semanticsHint,
      excludeSemantics: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: watch ? AppShape.watchMinTarget : 48,
          minWidth: watch ? AppShape.watchMinTarget : 0,
        ),
        child: TextButton(
          onPressed: enabled ? onPressed : null,
          style: ButtonStyle(
            padding: const WidgetStatePropertyAll(
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            backgroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.disabled) ? disabledBg : bg,
            ),
            foregroundColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.disabled) ? disabledFg : fg,
            ),
            overlayColor: WidgetStatePropertyAll(fg.withValues(alpha: 0.08)),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppShape.buttonRadius),
                side: border == null
                    ? BorderSide.none
                    : BorderSide(color: border),
              ),
            ),
          ),
          child: content,
        ),
      ),
    );
  }

  (Color bg, Color fg, Color? border) _colors(AppColors c) => switch (variant) {
    AppButtonVariant.primary => (c.primary, Colors.white, null),
    AppButtonVariant.success => (c.success, Colors.white, null),
    AppButtonVariant.danger => (c.danger, Colors.white, null),
    AppButtonVariant.brand => (c.brand, Colors.white, null),
    AppButtonVariant.secondary => (c.surfaceMuted, c.text, null),
    AppButtonVariant.outlined => (c.surface, c.text, c.border),
  };
}
