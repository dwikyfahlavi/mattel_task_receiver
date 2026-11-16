/// Test helpers for widget and golden tests of every package.
library;

import 'package:flutter/material.dart';

import 'l10n/generated/app_localizations.dart';
import 'src/layout/device_profile.dart';
import 'src/theme/app_theme.dart';

/// Logical screen sizes used in widget and golden tests (doc 20, A.8).
///
/// The WD1 II panel is 640x480 px; its logical size depends on the density
/// the device reports, so both plausible sizes are covered.
abstract final class TestScreens {
  static const watchHdpi = Size(427, 320);
  static const watchXhdpi = Size(320, 240);
  static const phone = Size(360, 760);
  static const tablet = Size(800, 1280);
  static const tabletLandscape = Size(1280, 800);

  static const all = <String, (Size, FormFactor)>{
    'watch_427x320': (watchHdpi, FormFactor.watch),
    'watch_320x240': (watchXhdpi, FormFactor.watch),
    'phone_360x760': (phone, FormFactor.phone),
    'tablet_800x1280': (tablet, FormFactor.tablet),
    'tablet_1280x800': (tabletLandscape, FormFactor.tablet),
  };
}

/// Wraps [child] with the app theme, Indonesian localization and the
/// form factor, like the real apps do.
Widget testApp(Widget child, {FormFactor formFactor = FormFactor.phone}) =>
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(formFactor: formFactor),
      locale: const Locale('id'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, c) => DeviceProfile(formFactor: formFactor, child: c!),
      home: child,
    );
