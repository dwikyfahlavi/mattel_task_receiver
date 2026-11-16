import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui_kit/testing.dart';
import 'package:ui_kit/ui_kit.dart';

/// The phone/tablet app bundles the technician illustrations; ui_kit only
/// falls back to a drawn placeholder where they are missing (the watch).
void main() {
  for (final available in [true, false]) {
    testWidgets('illustration asset is bundled (available: $available)', (
      tester,
    ) async {
      await tester.pumpWidget(
        testApp(Scaffold(body: TechnicianIllustration(available: available))),
      );
      final context = tester.element(find.byType(TechnicianIllustration));
      final asset = available
          ? TechnicianIllustration.successAsset
          : TechnicianIllustration.failedAsset;
      Object? error;
      await tester.runAsync(
        () => precacheImage(
          AssetImage(asset),
          context,
          onError: (e, _) => error = e,
        ),
      );
      await tester.pump();

      expect(error, isNull, reason: '$asset must be declared in pubspec.yaml');
      // The placeholder draws a wrench icon; the real image does not.
      expect(find.byIcon(LucideIcons.wrench), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
