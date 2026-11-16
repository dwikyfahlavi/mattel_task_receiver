import 'package:app_shell/app_shell.dart';
import 'package:app_watch/src/watch_app.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ui_kit/ui_kit.dart';

/// Watch enrollment and QR login against the fake backend (the "phone"
/// approves the pairing after ~8 s):
///   fvm flutter test integration_test --flavor dev
/// (run from apps/app_watch).
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('QR login reaches Home without typing', (tester) async {
    await initializeDateFormatting(JakartaTime.locale);
    final getIt = GetIt.asNewInstance();
    await configureDependencies(
      getIt,
      config: AppConfig.fromValues(
        environment: AppEnvironment.dev,
        kind: AppKind.watch,
        rawBaseUrl: '',
        rawPins: '',
        rawFake: 'true',
        rawKeys: '',
        isReleaseBuild: false,
      ),
      firebase: const FirebaseStatus(configured: false),
    );
    await tester.pumpWidget(
      ShellApp(
        routes: watchRoutes(),
        formFactor: FormFactor.watch,
        getIt: getIt,
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await tester.tap(find.text('Masuk dengan QR Code'));
    await tester.pump(const Duration(seconds: 1));

    // A new watch enrolls once with the admin's code.
    expect(find.text('Daftarkan Watch'), findsOneWidget);
    await tester.enterText(
      find.byType(TextField),
      FakeBackend.demoEnrollmentCode,
    );
    await tester.pump();
    await tester.tap(find.text('Daftarkan'));
    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Scan QR Code'), findsOneWidget);

    final end = DateTime.now().add(const Duration(seconds: 20));
    while (DateTime.now().isBefore(end) &&
        find.text('Siap mulai bekerja?').evaluate().isEmpty) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    expect(find.text('Siap mulai bekerja?'), findsOneWidget);
  });
}
