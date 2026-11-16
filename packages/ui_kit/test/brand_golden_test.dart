import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/testing.dart';
import 'package:ui_kit/ui_kit.dart';

/// Brand assets render from the bundle (logo PNG, precompiled wordmark).
/// Illustrations are bundled by app_mobile and tested there.
void main() {
  Widget scenario(FormFactor ff, Widget child) => testApp(
    Scaffold(
      body: Padding(padding: const EdgeInsets.all(12), child: child),
    ),
    formFactor: ff,
  );

  goldenTest(
    'brand header',
    fileName: 'brand_header',
    pumpBeforeTest: precacheImages,
    builder: () => GoldenTestGroup(
      columns: 1,
      children: [
        GoldenTestScenario(
          name: 'phone 40',
          constraints: BoxConstraints.tight(const Size(360, 80)),
          child: scenario(FormFactor.phone, const AppLogoHeader()),
        ),
        GoldenTestScenario(
          name: 'watch 24 centered',
          constraints: BoxConstraints.tight(const Size(320, 60)),
          child: scenario(
            FormFactor.watch,
            const AppLogoHeader(size: 24, centered: true),
          ),
        ),
      ],
    ),
  );

  testWidgets('logo and wordmark load from the bundle', (tester) async {
    await tester.pumpWidget(testApp(const Scaffold(body: AppLogoHeader())));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(Image), findsOneWidget);
    expect(find.bySemanticsLabel('MATTEL'), findsOneWidget);
  });

  testWidgets('illustration falls back without app assets (watch, tests)', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(const Scaffold(body: TechnicianIllustration(available: false))),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(TechnicianIllustration)),
      const Size.square(140),
    );
  });
}
