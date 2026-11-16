import 'package:app_mobile/src/mobile_app.dart';
import 'package:app_shell/app_shell.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// End-to-end flow on a device or emulator against the in-memory fake
/// backend (doc 20 "Integration"):
///   fvm flutter test integration_test --flavor dev
/// (run from apps/app_mobile).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login, check in, receive and accept a task until it is done', (
    tester,
  ) async {
    await initializeDateFormatting(JakartaTime.locale);
    final getIt = GetIt.asNewInstance();
    final config = AppConfig.fromValues(
      environment: AppEnvironment.dev,
      kind: AppKind.mobile,
      rawBaseUrl: '',
      rawPins: '',
      rawFake: 'true',
      rawKeys: '',
      isReleaseBuild: false,
    );
    await configureDependencies(
      getIt,
      config: config,
      firebase: const FirebaseStatus(configured: false),
    );
    await tester.pumpWidget(
      ShellApp(routes: mobileRoutes(), formFactor: null, getIt: getIt),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Sign in with KPK and the phone-number password.
    await tester.enterText(find.byType(TextField).at(0), FakeBackend.demoKpk);
    await tester.enterText(
      find.byType(TextField).at(1),
      FakeBackend.demoPassword,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Masuk'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Siap mulai bekerja?'), findsOneWidget);

    // Check In (readiness warnings may show the checklist on an emulator).
    await tester.tap(find.widgetWithText(TextButton, 'Check In'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    final continueAnyway = find.text('Tetap Check In');
    if (continueAnyway.evaluate().isNotEmpty) {
      await tester.tap(continueAnyway);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }
    if (find.text('Perangkat belum siap').evaluate().isNotEmpty) {
      markTestSkipped(
        'Device is not ready (notification permission). Grant it and re-run.',
      );
      return;
    }
    expect(find.text('Check In Berhasil!'), findsOneWidget);

    // The fake backend assigns a task after ~6 s.
    await _pumpUntil(
      tester,
      find.text('Penugasan Baru'),
      const Duration(seconds: 15),
    );
    await tester.tap(find.widgetWithText(TextButton, 'Terima'));
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.text('Penugasan Diterima!'), findsOneWidget);
    await tester.tap(find.text('Lanjut'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kembali ke Beranda'));
    await tester.pumpAndSettle();

    // In Progress blocks Check Out until the repair is recorded as finished
    // (the fake backend completes it after ~45 s; no Selesai, D-22).
    expect(find.text('Masih ada penugasan yang berjalan'), findsOneWidget);
    expect(find.text('Batalkan Penugasan'), findsOneWidget);
    await _pumpUntilGone(
      tester,
      find.text('Masih ada penugasan yang berjalan'),
      const Duration(seconds: 60),
    );
  });
}

Future<void> _pumpUntilGone(
  WidgetTester tester,
  Finder finder,
  Duration timeout,
) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isEmpty) return;
  }
  fail('Timed out waiting for $finder to disappear');
}

Future<void> _pumpUntil(
  WidgetTester tester,
  Finder finder,
  Duration timeout,
) async {
  final end = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Timed out waiting for $finder');
}
