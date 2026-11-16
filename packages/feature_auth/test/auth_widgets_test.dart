import 'dart:async';

import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_kit/testing.dart';
import 'package:ui_kit/ui_kit.dart';

class _MockRepo extends Mock implements AuthRepository {}

class _Clock extends AppClock {
  final DateTime now = DateTime.utc(2026, 10, 27, 3);
  @override
  DateTime serverNowUtc() => now;
  @override
  DateTime deviceNowUtc() => now;
  @override
  Duration get serverOffset => Duration.zero;
  @override
  bool get hasServerTime => true;
  @override
  void updateServerTime(DateTime serverUtc) {}
}

class _Realtime implements RealtimeService {
  @override
  Stream<RealtimeEvent> get events => const Stream.empty();
  @override
  Stream<bool> get connectionChanges => const Stream.empty();
  @override
  bool get isConnected => false;
  @override
  RealtimeMode? get mode => null;
  @override
  void start(RealtimeMode mode) {}
  @override
  Future<void> stop() async {}
  @override
  void reconnectNow() {}
  @override
  Future<bool> ack(String workOrderId) async => false;
}

class _Online implements ConnectivityService {
  @override
  bool get isOnline => true;
  @override
  Stream<bool> get onlineChanges => const Stream.empty();
  @override
  Future<void> start() async {}
  @override
  void reportReachable() {}
  @override
  void reportUnreachable() {}
  @override
  Future<void> dispose() async {}
}

void main() {
  setUpAll(() => initializeDateFormatting(JakartaTime.locale));

  late _MockRepo repo;
  setUp(() => repo = _MockRepo());

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = TestScreens.phone,
    FormFactor ff = FormFactor.phone,
    FeatureFlags? flags,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<FeatureFlags>.value(
            value: flags ?? DefaultFeatureFlags(),
          ),
          RepositoryProvider<AppClock>.value(value: _Clock()),
          RepositoryProvider<RealtimeService>.value(value: _Realtime()),
          RepositoryProvider<ConnectivityService>.value(value: _Online()),
        ],
        child: testApp(child, formFactor: ff),
      ),
    );
    await tester.pump();
  }

  LoginScreen login({VoidCallback? onVendor}) => LoginScreen(
    repository: repo,
    onSignedIn: (_) {},
    year: 2026,
    onVendorLogin: onVendor,
  );

  void stubLogin(Failure failure) => when(
    () => repo.login(
      kpk: any(named: 'kpk'),
      password: any(named: 'password'),
      remember: any(named: 'remember'),
    ),
  ).thenAnswer((_) async => Result.err(failure));

  Future<void> submit(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField).at(0), '31');
    await tester.enterText(find.byType(TextField).at(1), '0000');
    await tester.pump();
    await tester.tap(find.widgetWithText(TextButton, 'Masuk'));
    await tester.pump();
    await tester.pump();
  }

  group('LoginScreen (doc 3.1, A.4)', () {
    for (final entry in {
      'phone': (TestScreens.phone, FormFactor.phone),
      'tablet': (TestScreens.tablet, FormFactor.tablet),
      'tablet landscape': (TestScreens.tabletLandscape, FormFactor.tablet),
    }.entries) {
      testWidgets('lays out on ${entry.key}', (tester) async {
        await pump(tester, login(), size: entry.value.$1, ff: entry.value.$2);
        expect(tester.takeException(), isNull);
        expect(find.text('KPK'), findsOneWidget);
        expect(find.text('Tetap masuk di perangkat ini'), findsOneWidget);
        // Tablet: centered column with a max width (A.4).
        final width = tester.getSize(find.byType(AppTextField).first).width;
        expect(width, lessThanOrEqualTo(AppShape.tabletContentMaxWidth));
      });
    }

    testWidgets('Masuk is disabled until both fields are filled', (
      tester,
    ) async {
      await pump(tester, login());
      TextButton masuk() =>
          tester.widget<TextButton>(find.widgetWithText(TextButton, 'Masuk'));
      expect(masuk().onPressed, isNull);
      await tester.enterText(find.byType(TextField).at(0), '31');
      await tester.enterText(find.byType(TextField).at(1), '081234567890');
      await tester.pump();
      expect(masuk().onPressed, isNotNull);
    });

    testWidgets('the KPK field accepts digits only (max 9)', (tester) async {
      await pump(tester, login());
      await tester.enterText(find.byType(TextField).at(0), '12ab3456789012');
      await tester.pump();
      expect(
        tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
        '123456789',
      );
    });

    testWidgets('wrong credentials show "KPK atau password salah!"', (
      tester,
    ) async {
      stubLogin(
        const ApiFailure(
          statusCode: 401,
          code: ApiErrorCode.invalidCredentials,
        ),
      );
      await pump(tester, login());
      await submit(tester);
      expect(find.text('KPK atau password salah!'), findsOneWidget);
    });

    testWidgets('lockout shows the wait in minutes', (tester) async {
      stubLogin(
        const ApiFailure(
          statusCode: 429,
          code: ApiErrorCode.rateLimited,
          retryAfter: Duration(seconds: 840),
        ),
      );
      await pump(tester, login());
      await submit(tester);
      expect(
        find.text('Terlalu banyak percobaan. Coba lagi dalam 14 menit.'),
        findsOneWidget,
      );
    });

    testWidgets('vendor button hidden by default (flag off, doc 20 case 8)', (
      tester,
    ) async {
      await pump(tester, login(onVendor: () {}));
      expect(find.text('Masuk sebagai Vendor Technician'), findsNothing);
    });

    testWidgets('vendor button shown when the flag is on and a route exists', (
      tester,
    ) async {
      await pump(
        tester,
        login(onVendor: () {}),
        flags: DefaultFeatureFlags({FeatureFlag.vendorTechnicianLogin: true}),
      );
      expect(find.text('Masuk sebagai Vendor Technician'), findsOneWidget);
    });

    testWidgets('flag on but no route: still hidden', (tester) async {
      await pump(
        tester,
        login(),
        flags: DefaultFeatureFlags({FeatureFlag.vendorTechnicianLogin: true}),
      );
      expect(find.text('Masuk sebagai Vendor Technician'), findsNothing);
    });
  });

  group('Watch login (A.3)', () {
    for (final entry in {
      '427x320': TestScreens.watchHdpi,
      '320x240': TestScreens.watchXhdpi,
    }.entries) {
      testWidgets('welcome lays out on ${entry.key}', (tester) async {
        await pump(
          tester,
          WatchWelcomeScreen(onLoginWithQr: () {}, year: 2026),
          size: entry.value,
          ff: FormFactor.watch,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Masuk dengan QR Code'), findsOneWidget);
      });

      testWidgets('QR screen lays out on ${entry.key}', (tester) async {
        final pending = Completer<Result<PairingDto>>();
        when(repo.createPairing).thenAnswer((_) => pending.future);
        when(() => repo.pairingStatus(any()))
            .thenAnswer((_) async => const Result.ok(PairingStatus.pending));
        await pump(
          tester,
          WatchQrScreen(
            repository: repo,
            onSignedIn: (_) {},
            year: 2026,
            qrBuilder: (data, size) =>
                SizedBox.square(dimension: size, child: const Placeholder()),
          ),
          size: entry.value,
          ff: FormFactor.watch,
        );
        pending.complete(
          Result.ok(
            PairingDto(
              pairingId: 'p',
              qrPayload: '{"v":1,"t":"pair","code":"c"}',
              expiresAt: DateTime.utc(2026, 10, 27, 3, 1),
            ),
          ),
        );
        await tester.pump();
        await tester.pump();
        expect(tester.takeException(), isNull);
        expect(find.byType(Placeholder), findsOneWidget);
        expect(find.text('Buat Ulang QR Code'), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      });

      testWidgets('enrollment lays out on ${entry.key}', (tester) async {
        await pump(
          tester,
          WatchEnrollScreen(
            repository: repo,
            onEnrolled: (_) {},
            scanWithCamera: () async => null,
          ),
          size: entry.value,
          ff: FormFactor.watch,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Daftarkan'), findsOneWidget);
        expect(find.text('Scan Kode'), findsOneWidget);
      });
    }

    testWidgets('a camera scan fills the code and enrolls', (tester) async {
      when(() => repo.enroll('K7M2Q9XD4B')).thenAnswer(
        (_) async => const Result.ok(DeviceDto(id: 'd1', name: 'Watch 1')),
      );
      DeviceDto? enrolled;
      await pump(
        tester,
        WatchEnrollScreen(
          repository: repo,
          onEnrolled: (d) => enrolled = d,
          scanWithCamera: () async => '{"v":1,"code":"K7M2Q9XD4B"}',
        ),
        size: TestScreens.watchHdpi,
        ff: FormFactor.watch,
      );
      await tester.tap(find.text('Scan Kode'));
      await tester.pump();
      await tester.pump();
      expect(enrolled?.id, 'd1');
    });
  });
}
