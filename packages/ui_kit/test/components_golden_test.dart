import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_kit/testing.dart';
import 'package:ui_kit/ui_kit.dart';

/// Golden gallery of the A.2 components at phone and watch scale.
/// Review against the Figma frames when it changes (A.8).
void main() {
  Widget scenario(FormFactor ff, Widget child) => testApp(
    Scaffold(
      body: Padding(padding: const EdgeInsets.all(12), child: child),
    ),
    formFactor: ff,
  );

  Widget gallery() => const SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 8,
          children: [
            StatusBadge(available: false),
            StatusBadge(available: true),
          ],
        ),
        SizedBox(height: 8),
        StatusBanner(available: false),
        SizedBox(height: 8),
        StatusBanner(available: true),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [CountdownChip(seconds: 59), CountdownChip(seconds: 9)],
        ),
        SizedBox(height: 8),
        MachineCard(
          machineCode: 'FAR012',
          trailing: ProblemTag(label: 'Tools Problem'),
        ),
        SizedBox(height: 8),
        InfoRow(kind: InfoRowKind.location, label: 'Area Produksi'),
        InfoRow(kind: InfoRowKind.problem, label: 'Tools Problem'),
        InfoRow(
          kind: InfoRowKind.time,
          label: 'Waktu Diterima',
          detail: 'Sen, 26 Okt 2026 | 09:16',
        ),
        SizedBox(height: 8),
        InfoBox(
          text: 'Untuk menerima penugasan kembali, silakan lakukan Check In ulang.',
        ),
        SizedBox(height: 8),
        NoticeBanner(
          message: 'Sesi berakhir pukul 15:40',
          tone: NoticeTone.warning,
        ),
        SizedBox(height: 8),
        HistoryItem(
          status: HistoryStatus.missed,
          title: 'FAR012',
          subtitle: 'Area Produksi · Tools Problem',
          reason: 'Tidak ada respon',
          date: 'Sen, 26 Okt 2026 | 09:16',
        ),
      ],
    ),
  );

  Widget buttons() => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppButton(
        label: 'Check In',
        onPressed: () {},
        trailing: const StatusBadge(available: false),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'Terima',
              variant: AppButtonVariant.success,
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AppButton(
              label: 'Tolak',
              variant: AppButtonVariant.danger,
              onPressed: () {},
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      const AppButton(
        label: 'Masuk',
        variant: AppButtonVariant.brand,
        onPressed: null,
      ),
      const SizedBox(height: 8),
      AppButton(
        label: 'Kembali ke Beranda',
        variant: AppButtonVariant.secondary,
        onPressed: () {},
      ),
      // The loading variant animates forever, so it is not in the golden.
    ],
  );

  goldenTest(
    'ui_kit components',
    fileName: 'ui_kit_components',
    builder: () => GoldenTestGroup(
      columns: 2,
      children: [
        GoldenTestScenario(
          name: 'phone',
          constraints: BoxConstraints.tight(const Size(360, 720)),
          child: scenario(FormFactor.phone, gallery()),
        ),
        GoldenTestScenario(
          name: 'watch',
          constraints: BoxConstraints.tight(const Size(427, 720)),
          child: scenario(FormFactor.watch, gallery()),
        ),
        GoldenTestScenario(
          name: 'buttons phone',
          constraints: BoxConstraints.tight(const Size(360, 400)),
          child: scenario(FormFactor.phone, buttons()),
        ),
        GoldenTestScenario(
          name: 'buttons watch (64 dp targets)',
          constraints: BoxConstraints.tight(const Size(427, 480)),
          child: scenario(FormFactor.watch, buttons()),
        ),
      ],
    ),
  );

  testWidgets('watch buttons meet the 64 dp target (doc 15)', (tester) async {
    tester.view.physicalSize = TestScreens.watchHdpi;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      testApp(
        Scaffold(
          body: AppButton(label: 'Terima', onPressed: () {}),
        ),
        formFactor: FormFactor.watch,
      ),
    );
    expect(
      tester.getSize(find.byType(TextButton)).height,
      greaterThanOrEqualTo(64),
    );
  });

  testWidgets('countdown chip formats and turns red in the last 10 s', (
    tester,
  ) async {
    await tester.pumpWidget(
      testApp(const Scaffold(body: CountdownChip(seconds: 9))),
    );
    expect(find.text('00:09'), findsOneWidget);
    final box = tester.widget<Container>(
      find
          .descendant(
            of: find.byType(CountdownChip),
            matching: find.byType(Container),
          )
          .first,
    );
    expect((box.decoration! as BoxDecoration).color, const Color(0xFFDC2626));
  });
}
