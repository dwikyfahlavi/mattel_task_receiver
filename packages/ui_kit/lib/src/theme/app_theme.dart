import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../layout/device_profile.dart';

/// Material theme built from the A.1 tokens. Only sizing differs per form
/// factor (watch scale); colors and shapes are shared.
abstract final class AppTheme {
  /// Bundled Inter from this package (never a network font).
  static const fontFamily = 'packages/ui_kit/Inter';

  static ThemeData light({FormFactor formFactor = FormFactor.phone}) {
    const c = AppColors.light;
    final watch = formFactor == FormFactor.watch;
    final scheme = ColorScheme.fromSeed(seedColor: c.primary).copyWith(
      primary: c.primary,
      onPrimary: Colors.white,
      error: c.danger,
      onError: Colors.white,
      surface: c.surface,
      onSurface: c.text,
      outline: c.border,
    );
    // A.1: title 20-24 bold, section 16-18 semibold, body 14, caption 12,
    // badges 9-10. The watch keeps body >= 14 and caption >= 12 (A.3).
    final text = TextTheme(
      headlineSmall: TextStyle(
        fontSize: watch ? 20 : 24,
        fontWeight: FontWeight.w700,
        color: c.text,
      ),
      titleLarge: TextStyle(
        fontSize: watch ? 18 : 20,
        fontWeight: FontWeight.w700,
        color: c.text,
      ),
      titleMedium: TextStyle(
        fontSize: watch ? 16 : 17,
        fontWeight: FontWeight.w600,
        color: c.text,
      ),
      bodyLarge: TextStyle(fontSize: watch ? 15 : 16, color: c.text),
      bodyMedium: TextStyle(fontSize: watch ? 14 : 14, color: c.text),
      bodySmall: TextStyle(fontSize: watch ? 12 : 12, color: c.textMuted),
      labelLarge: TextStyle(
        fontSize: watch ? 16 : 15,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: TextStyle(
        fontSize: watch ? 10 : 9.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
      ),
    );
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: scheme,
      scaffoldBackgroundColor: c.surface,
      textTheme: text,
      extensions: const [c],
      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),
      appBarTheme: AppBarTheme(
        backgroundColor: c.surface,
        foregroundColor: c.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppShape.dialogRadius),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(color: c.border, width: 1.5),
      ),
      snackBarTheme: const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      // The watch has no blur; dialogs use a plain scrim (A.3).
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        modalBarrierColor: c.scrim,
      ),
    );
  }
}
