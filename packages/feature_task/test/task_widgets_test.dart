import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_kit/testing.dart';
import 'package:ui_kit/ui_kit.dart';

import 'helpers.dart';

class _MockBloc extends MockBloc<TaskSessionEvent, TaskSessionState>
    implements TaskSessionBloc {}

void main() {
  setUpAll(() async {
    await initializeDateFormatting(JakartaTime.locale);
    registerFallbackValue(const TaskAcceptPressed());
  });

  final now = DateTime.utc(2026, 10, 27, 2, 38);
  final task = sampleTask(now).copyWith(
    // Long values must wrap, never truncate (doc 15 rule 4).
    machineCode: 'FAR012-INJECTION-MOLDING-LINE-7',
    issue: 'Tools Problem pada nozzle dan sistem pendingin mesin',
    location: 'Produksi Gedung B Lantai 2 Cell B-12',
  );
  late _MockBloc bloc;
  late FakeConnectivity connectivity;

  setUp(() {
    bloc = _MockBloc();
    connectivity = FakeConnectivity();
    when(() => bloc.state).thenReturn(TaskSessionState.assigned(task: task));
  });

  Future<void> pump(
    WidgetTester tester,
    Widget child,
    Size size,
    FormFactor ff,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AppClock>.value(
            value: FakeAppClock(now.add(const Duration(seconds: 1))),
          ),
          RepositoryProvider<ConnectivityService>.value(value: connectivity),
        ],
        child: BlocProvider<TaskSessionBloc>.value(
          value: bloc,
          child: testApp(child, formFactor: ff),
        ),
      ),
    );
    await tester.pump();
  }

  for (final entry in TestScreens.all.entries) {
    final (size, ff) = entry.value;

    testWidgets('popup lays out without overflow on ${entry.key}', (
      tester,
    ) async {
      await pump(
        tester,
        TaskPopupScreen(task: task, userFirstName: 'Budi'),
        size,
        ff,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Terima'), findsOneWidget);
      expect(find.text('Tolak'), findsOneWidget);
      expect(find.text('00:59'), findsOneWidget);
      // Critical text is shown in full.
      expect(find.text(task.machineCode), findsOneWidget);
      expect(find.text(task.issue), findsOneWidget);
      // Terima and Tolak are big enough on the watch (doc 15 rule 1).
      if (ff == FormFactor.watch) {
        expect(
          tester.getSize(find.widgetWithText(TextButton, 'Terima')).height,
          greaterThanOrEqualTo(64),
        );
      }
      await tester.pumpWidget(const SizedBox());
    });

    for (final reason in [
      ResolutionReason.rejected,
      ResolutionReason.timeout,
      ResolutionReason.lateDelivery,
      ResolutionReason.offlineMissed,
      ResolutionReason.cancelled,
    ]) {
      testWidgets('result ${reason.name} lays out on ${entry.key}', (
        tester,
      ) async {
        await pump(
          tester,
          TaskResultScreen(
            outcome: TaskOutcome(task: task, reason: reason),
            userFirstName: 'Budi',
            onCheckIn: () {},
          ),
          size,
          ff,
        );
        expect(tester.takeException(), isNull);
        expect(find.text('Kembali ke Beranda'), findsOneWidget);
        expect(
          find.text('Check In'),
          reason.makesUnavailable ? findsOneWidget : findsNothing,
        );
      });
    }

    testWidgets('accepted screen lays out on ${entry.key}', (tester) async {
      await pump(
        tester,
        TaskAcceptedScreen(task: task, acceptedAt: now),
        size,
        ff,
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Penugasan Diterima!'), findsOneWidget);
      if (ff == FormFactor.watch) {
        // One step on the watch (A.7 #8).
        expect(find.text('Kembali ke Beranda'), findsOneWidget);
      } else {
        await tester.tap(find.text('Lanjut'));
        await tester.pump();
        expect(find.text('Waktu Diterima'), findsOneWidget);
      }
    });
  }

  testWidgets('Tolak asks for confirmation before rejecting', (tester) async {
    await pump(
      tester,
      TaskPopupScreen(task: task, userFirstName: 'Budi'),
      TestScreens.phone,
      FormFactor.phone,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Tolak'));
    await tester.pumpAndSettle();
    expect(find.text('Tolak Penugasan?'), findsOneWidget);
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();
    verifyNever(() => bloc.add(const TaskRejectConfirmed()));

    await tester.tap(find.widgetWithText(TextButton, 'Tolak'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Tolak').last);
    await tester.pumpAndSettle();
    verify(() => bloc.add(any(that: isA<TaskRejectConfirmed>()))).called(1);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('offline disables Terima and Tolak (doc 16)', (tester) async {
    connectivity.online = false;
    await pump(
      tester,
      TaskPopupScreen(task: task, userFirstName: 'Budi'),
      TestScreens.phone,
      FormFactor.phone,
    );
    final terima = tester.widget<TextButton>(
      find.widgetWithText(TextButton, 'Terima'),
    );
    expect(terima.onPressed, isNull);
    expect(
      find.text('Tidak ada koneksi. Coba lagi saat online.'),
      findsOneWidget,
    );
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'watch side button: long press accepts, short press does not (doc 10.2)',
    (tester) async {
      // KEYCODE_F1 (131) is one of the default side-button codes.
      const keyCode = 131;
      await pump(
        tester,
        TaskPopupScreen(
          task: task,
          userFirstName: 'Budi',
          watchAcceptKeyCodes: const {keyCode},
        ),
        TestScreens.watchHdpi,
        FormFactor.watch,
      );
      final key = HardwareKeyLongPress.logicalKeyFor(keyCode);
      expect(key, LogicalKeyboardKey.f1);

      await tester.sendKeyDownEvent(key);
      await tester.pump(const Duration(milliseconds: 200));
      await tester.sendKeyUpEvent(key);
      await tester.pump(const Duration(milliseconds: 600));
      verifyNever(() => bloc.add(any(that: isA<TaskAcceptPressed>())));

      await tester.sendKeyDownEvent(key);
      await tester.pump(const Duration(milliseconds: 550));
      await tester.sendKeyUpEvent(key);
      verify(() => bloc.add(any(that: isA<TaskAcceptPressed>()))).called(1);
      await tester.pumpWidget(const SizedBox());
    },
  );

  testWidgets('In Progress card has Batalkan, never Selesai (D-22)', (
    tester,
  ) async {
    var cancelled = false;
    await pump(
      tester,
      Scaffold(
        body: SingleChildScrollView(
          child: InProgressCard(
            task: task,
            acceptedAt: now,
            onCancel: () => cancelled = true,
          ),
        ),
      ),
      TestScreens.phone,
      FormFactor.phone,
    );
    expect(find.text('Selesai'), findsNothing);
    await tester.tap(find.text('Batalkan Penugasan'));
    expect(cancelled, isTrue);
  });
}
