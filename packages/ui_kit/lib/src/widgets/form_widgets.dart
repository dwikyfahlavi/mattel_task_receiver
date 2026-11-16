import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../l10n/generated/app_localizations.dart';

/// Labelled text field with a left icon and the A.2 states: empty, focused
/// (grey double ring), error (red label, border and message). Password
/// fields get a show/hide toggle (A.4 addition).
class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.errorText,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
    this.autofillHints,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    super.key,
  });

  /// Replaces the default "no whitespace" formatter of non-password fields.
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final String? errorText;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool enabled;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  final _focus = FocusNode();
  bool _hidden = true;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context).textTheme;
    final hasError = widget.errorText != null;
    final focused = _focus.hasFocus;
    final borderColor = hasError
        ? c.danger
        : (focused ? c.textMuted : c.border);

    OutlineInputBorder border(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppShape.fieldRadius),
      borderSide: BorderSide(color: color),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: hasError ? c.danger : c.text,
          ),
        ),
        const SizedBox(height: 6),
        DecoratedBox(
          // Focused "double ring" from the design.
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppShape.fieldRadius + 3),
            boxShadow: focused && !hasError
                ? [BoxShadow(color: c.border, spreadRadius: 3)]
                : const [],
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _focus,
            enabled: widget.enabled,
            obscureText: widget.obscure && _hidden,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            autofillHints: widget.autofillHints,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            autocorrect: false,
            enableSuggestions: !widget.obscure,
            textCapitalization: widget.textCapitalization,
            inputFormatters:
                widget.inputFormatters ??
                (widget.obscure
                    ? null
                    : [FilteringTextInputFormatter.deny(RegExp(r'\s'))]),
            style: theme.bodyMedium,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.hint,
              hintStyle: theme.bodyMedium?.copyWith(color: c.textDisabled),
              prefixIcon: Icon(
                widget.icon,
                size: 18,
                color: hasError ? c.danger : c.textMuted,
              ),
              suffixIcon: widget.obscure
                  ? IconButton(
                      tooltip: _hidden ? l10n.showPassword : l10n.hidePassword,
                      onPressed: () => setState(() => _hidden = !_hidden),
                      icon: Icon(
                        _hidden ? LucideIcons.eye : LucideIcons.eyeOff,
                        size: 18,
                        color: c.textMuted,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: c.surface,
              enabledBorder: border(borderColor),
              focusedBorder: border(borderColor),
              disabledBorder: border(c.border),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: 6),
          Semantics(
            liveRegion: true,
            child: Text(
              widget.errorText!,
              style: theme.bodySmall?.copyWith(color: c.danger),
            ),
          ),
        ],
      ],
    );
  }
}

/// Mattel logo and "MATTEL" wordmark (A.2).
class AppLogoHeader extends StatelessWidget {
  const AppLogoHeader({this.size = 40, this.centered = false, super.key});

  final double size;
  final bool centered;

  /// Bundled brand assets (sources in `design/assets/brands/`).
  static const logoAsset = 'assets/brands/logo.png';
  static const wordmarkAsset = 'assets/brands/wordmark.svg';

  /// Width / height of `wordmark.svg` (viewBox 511x94).
  static const _wordmarkAspect = 511 / 94;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final wordmarkHeight = size * 0.42;
    return Semantics(
      label: l10n.brandName,
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: centered
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          Image.asset(
            logoAsset,
            package: 'ui_kit',
            width: size,
            height: size,
            filterQuality: FilterQuality.medium,
          ),
          const SizedBox(width: 10),
          // Precompiled vector (vector_graphics transformer in pubspec).
          // Fixed size so layout does not shift while it loads.
          SizedBox(
            width: wordmarkHeight * _wordmarkAspect,
            height: wordmarkHeight,
            child: const VectorGraphic(
              loader: AssetBytesLoader(wordmarkAsset, packageName: 'ui_kit'),
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}

class CopyrightText extends StatelessWidget {
  const CopyrightText({required this.year, super.key});

  final int year;

  @override
  Widget build(BuildContext context) => Text(
    AppLocalizations.of(context).copyright(year),
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.bodySmall,
  );
}

/// Technician illustration with the status badge baked in (A.5): red ✗ when
/// Unavailable, green ✓ when Available. Phone and tablet only.
///
/// The images are bundled by **app_mobile** (`apps/app_mobile/assets/
/// illustrations/`), not by ui_kit, so the watch APK does not carry them.
/// Where they are absent (watch, package tests) a lightweight drawn
/// placeholder is shown instead.
class TechnicianIllustration extends StatelessWidget {
  const TechnicianIllustration({
    required this.available,
    this.size = 140,
    super.key,
  });

  /// App-level asset paths (no package prefix).
  static const successAsset = 'assets/illustrations/technician_success.png';
  static const failedAsset = 'assets/illustrations/technician_failed.png';

  final bool available;
  final double size;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox.square(
      dimension: size,
      child: Image.asset(
        available ? successAsset : failedAsset,
        width: size,
        height: size,
        filterQuality: FilterQuality.medium,
        // Keeps the previous image while switching state (no flash).
        gaplessPlayback: true,
        errorBuilder: (context, _, _) =>
            _IllustrationPlaceholder(available: available, size: size),
      ),
    ),
  );
}

class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder({required this.available, required this.size});

  final bool available;
  final double size;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return SizedBox.square(
      dimension: size,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: c.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(
                LucideIcons.wrench,
                size: size * 0.45,
                color: c.textMuted,
              ),
            ),
          ),
          Positioned(
            right: size * 0.06,
            bottom: size * 0.06,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: available ? c.success : c.danger,
                shape: BoxShape.circle,
                border: Border.all(color: c.surface, width: 3),
              ),
              child: Icon(
                available ? LucideIcons.check : LucideIcons.x,
                color: Colors.white,
                size: size * 0.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// One line of the readiness checklist with a fix button.
class ChecklistTile extends StatelessWidget {
  const ChecklistTile({
    required this.label,
    required this.passed,
    required this.blocking,
    this.onFix,
    super.key,
  });

  final String label;
  final bool passed;
  final bool blocking;
  final VoidCallback? onFix;

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final color = passed
        ? c.success
        : (blocking ? c.danger : const Color(0xFF8A5A00));
    final icon = passed
        ? LucideIcons.circleCheck
        : (blocking ? LucideIcons.circleX : LucideIcons.triangleAlert);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          if (!passed && onFix != null)
            TextButton(
              onPressed: onFix,
              child: Text(AppLocalizations.of(context).actionFix),
            ),
        ],
      ),
    );
  }
}

/// Simple pulsing placeholder for loading lists.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({this.height = 64, super.key});

  final double height;

  @override
  Widget build(BuildContext context) => Container(
    height: height,
    decoration: BoxDecoration(
      color: AppColors.of(context).surfaceMuted,
      borderRadius: BorderRadius.circular(AppShape.cardRadius),
    ),
  );
}
