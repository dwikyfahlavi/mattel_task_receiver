import 'package:flutter/material.dart';

/// Design tokens from Appendix A.1. Confirm against Figma before release.
///
/// Two reds on purpose: [brand] (Mattel red) for sign-in and the watch
/// welcome/QR screens, [danger] for alerts and destructive task actions.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primary,
    required this.success,
    required this.danger,
    required this.brand,
    required this.brandDisabled,
    required this.dangerSurface,
    required this.successSurface,
    required this.infoSurface,
    required this.text,
    required this.textMuted,
    required this.textDisabled,
    required this.border,
    required this.surfaceMuted,
    required this.surface,
    required this.scanAccent,
    required this.scrim,
  });

  final Color primary;
  final Color success;
  final Color danger;
  final Color brand;
  final Color brandDisabled;
  final Color dangerSurface;
  final Color successSurface;
  final Color infoSurface;
  final Color text;
  final Color textMuted;
  final Color textDisabled;
  final Color border;
  final Color surfaceMuted;
  final Color surface;
  final Color scanAccent;
  final Color scrim;

  static const light = AppColors(
    primary: Color(0xFF155DFC),
    success: Color(0xFF16A34A),
    danger: Color(0xFFDC2626),
    brand: Color(0xFFE81C2C),
    brandDisabled: Color(0xFFF38D95),
    dangerSurface: Color(0xFFFBEBEB),
    successSurface: Color(0xFFE8F6ED),
    infoSurface: Color(0xFFE6F3FA),
    text: Color(0xFF0A0A0A),
    textMuted: Color(0xFF737373),
    textDisabled: Color(0xFFA3A3A3),
    border: Color(0xFFE5E5E5),
    surfaceMuted: Color(0xFFF5F5F5),
    surface: Color(0xFFFFFFFF),
    scanAccent: Color(0xFFFDB623),
    scrim: Color(0x66000000),
  );

  static AppColors of(BuildContext context) =>
      Theme.of(context).extension<AppColors>() ?? light;

  @override
  AppColors copyWith({
    Color? primary,
    Color? success,
    Color? danger,
    Color? brand,
    Color? brandDisabled,
    Color? dangerSurface,
    Color? successSurface,
    Color? infoSurface,
    Color? text,
    Color? textMuted,
    Color? textDisabled,
    Color? border,
    Color? surfaceMuted,
    Color? surface,
    Color? scanAccent,
    Color? scrim,
  }) => AppColors(
    primary: primary ?? this.primary,
    success: success ?? this.success,
    danger: danger ?? this.danger,
    brand: brand ?? this.brand,
    brandDisabled: brandDisabled ?? this.brandDisabled,
    dangerSurface: dangerSurface ?? this.dangerSurface,
    successSurface: successSurface ?? this.successSurface,
    infoSurface: infoSurface ?? this.infoSurface,
    text: text ?? this.text,
    textMuted: textMuted ?? this.textMuted,
    textDisabled: textDisabled ?? this.textDisabled,
    border: border ?? this.border,
    surfaceMuted: surfaceMuted ?? this.surfaceMuted,
    surface: surface ?? this.surface,
    scanAccent: scanAccent ?? this.scanAccent,
    scrim: scrim ?? this.scrim,
  );

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      primary: l(primary, other.primary),
      success: l(success, other.success),
      danger: l(danger, other.danger),
      brand: l(brand, other.brand),
      brandDisabled: l(brandDisabled, other.brandDisabled),
      dangerSurface: l(dangerSurface, other.dangerSurface),
      successSurface: l(successSurface, other.successSurface),
      infoSurface: l(infoSurface, other.infoSurface),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      textDisabled: l(textDisabled, other.textDisabled),
      border: l(border, other.border),
      surfaceMuted: l(surfaceMuted, other.surfaceMuted),
      surface: l(surface, other.surface),
      scanAccent: l(scanAccent, other.scanAccent),
      scrim: l(scrim, other.scrim),
    );
  }
}

/// Spacing and shape tokens (A.1: cards 12-16, buttons 8-10, pills full).
abstract final class AppShape {
  static const cardRadius = 14.0;
  static const dialogRadius = 16.0;
  static const buttonRadius = 10.0;
  static const fieldRadius = 10.0;

  /// Watch touch targets (doc 15).
  static const watchMinTarget = 64.0;

  /// Tablet dialog and content widths (A.4 / A.6).
  static const tabletDialogMaxWidth = 520.0;
  static const tabletContentMaxWidth = 480.0;
}
