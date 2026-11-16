import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:feature_auth/feature_auth.dart';
import 'package:feature_availability/feature_availability.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_kit/testing.dart';
import 'package:ui_kit/ui_kit.dart';

class _Tasks extends MockBloc<TaskSessionEvent, TaskSessionState>
    implements TaskSessionBloc {}

class _Availability extends MockBloc<AvailabilityEvent, AvailabilityState>
    implements AvailabilityBloc {}

class _Shift extends MockCubit<ShiftBanner> implements ShiftEndCubit {}

class _Session extends MockCubit<SessionState> implements SessionCubit {}

class _Readiness extends Mock implements ReadinessService {}

class _ReadinessActions extends Mock implements ReadinessActions {}

class _Clock extends AppClock {
  final DateTime now = DateTime.utc(2026, 10, 26, 2, 16);
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
  setUpAll(() async {
    await initializeDateFormatting(JakartaTime.locale);
    registerFallbackValue(const AvailabilityStarted());
  });

  final clock = _Clock();
  final info = SessionInfo(
    user: const UserProfile(
      kpk: 31,
      name: 'Budi Andika Pratama Wijaya',
      role: UserRole.technician,
    ),
    policy: SessionPolicy(
      sessionExpiresAt: clock.now.add(const Duration(minutes: 10)),
      graceSeconds: 600,
    ),
  );
  final task = TaskAssignment(
    taskId: 't',
    machineCode: 'FAR012',
    location: 'B-12',
    issue: 'Changeover',
    assignedAt: clock.now,
    expiresAt: clock.now.add(const Duration(seconds: 60)),
  );

  late _Tasks tasks;
  late _Availability availability;
  late _Shift shift;

  setUp(() {
    tasks = _Tasks();
    availability = _Availability();
    shift = _Shift();
    when(() => tasks.notices).thenAnswer((_) => const Stream.empty());
    when(() => tasks.state).thenReturn(const TaskSessionState.idle());
    when(() => availability.state).thenReturn(const AvailabilityState());
    when(() => shift.state).thenReturn(const NoShiftBanner());
  });

  Future<void> pump(WidgetTester tester, Size size, FormFactor ff) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AppClock>.value(value: clock),
          RepositoryProvider<ConnectivityService>.value(value: _Online()),
          RepositoryProvider<ReadinessService>.value(value: _Readiness()),
          RepositoryProvider<ReadinessActions>.value(
            value: _ReadinessActions(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TaskSessionBloc>.value(value: tasks),
            BlocProvider<AvailabilityBloc>.value(value: availability),
            BlocProvider<ShiftEndCubit>.value(value: shift),
            BlocProvider<SessionCubit>.value(value: _Session()),
          ],
          child: testApp(
            HomeScreen(
              session: info,
              onOpenHistory: () {},
              onScanQr: ff == FormFactor.watch ? null : () {},
            ),
            formFactor: ff,
          ),
        ),
      ),
    );
    await tester.pump();
  }

  for (final entry in TestScreens.all.entries) {
    final (size, ff) = entry.value;

    testWidgets('unavailable home on ${entry.key}', (tester) async {
      await pump(tester, size, ff);
      expect(tester.takeException(), isNull);
      expect(find.text('Siap mulai bekerja?'), findsOneWidget);
      expect(find.text('Check In'), findsOneWidget);
      expect(
        find.text('Scan QR Code'),
        ff == FormFactor.watch ? findsNothing : findsOneWidget,
      );
    });

    testWidgets('available home shows Check Out on ${entry.key} (A.7 #1)', (
      tester,
    ) async {
      when(
        () => availability.state,
      ).thenReturn(AvailabilityState(available: true, checkedInAt: clock.now));
      when(() => shift.state)
          .thenReturn(ShiftEndingBanner(info.policy.sessionExpiresAt));
      await pump(tester, size, ff);
      expect(tester.takeException(), isNull);
      expect(find.text('Check In Berhasil!'), findsOneWidget);
      // Jakarta time of the check-in (doc 11).
      expect(find.text('Sen, 26 Okt 2026 | 09:16'), findsOneWidget);
      expect(
        find.text(
          ff == FormFactor.watch ? 'Check Out atau Unavailable' : 'Check Out',
        ),
        findsOneWidget,
      );
      expect(find.text('Sesi berakhir pukul 09:26'), findsOneWidget);
    });

    testWidgets('in-progress home disables Check Out on ${entry.key}', (
      tester,
    ) async {
      when(
        () => availability.state,
      ).thenReturn(AvailabilityState(available: true, checkedInAt: clock.now));
      when(() => tasks.state).thenReturn(
        TaskSessionState.inProgress(task: task, acceptedAt: clock.now),
      );
      when(() => shift.state).thenReturn(ShiftBlockedBanner(clock.now));
      await pump(tester, size, ff);
      expect(tester.takeException(), isNull);
      // No Selesai: the job ends when the repair is recorded (D-22).
      expect(find.text('Selesai'), findsNothing);
      expect(find.text('Batalkan Penugasan'), findsOneWidget);
      expect(find.text('Masih ada penugasan yang berjalan'), findsOneWidget);
      expect(
        find.text('Selesaikan penugasan untuk mengakhiri sesi'),
        findsOneWidget,
      );
      if (ff == FormFactor.watch) {
        // Watch pins Selesai at the bottom; Check Out is not offered.
        expect(find.text('Check Out atau Unavailable'), findsNothing);
      } else {
        final checkOut = find.widgetWithText(TextButton, 'Check Out');
        expect(tester.widget<TextButton>(checkOut).onPressed, isNull);
      }
    });
  }

  testWidgets('watch runs the readiness check when Home appears (doc 12)', (
    tester,
  ) async {
    await pump(tester, TestScreens.watchHdpi, FormFactor.watch);
    verify(() => availability.add(any(that: isA<ReadinessRecheckRequested>())))
        .called(1);
  });

  testWidgets('phone Home does not run a background check on mount', (
    tester,
  ) async {
    await pump(tester, TestScreens.phone, FormFactor.phone);
    verifyNever(
      () => availability.add(any(that: isA<ReadinessRecheckRequested>())),
    );
  });

  const warnReport = ReadinessReport([
    ReadinessResult(
      item: ReadinessItem.batteryOptimization,
      passed: false,
      severity: ReadinessSeverity.warn,
    ),
  ]);

  for (final forCheckIn in [true, false]) {
    testWidgets('a pending checklist is shown on mount; "Tetap Check In" '
        '${forCheckIn ? 'offered' : 'hidden'} (forCheckIn: $forCheckIn)', (
      tester,
    ) async {
      when(() => availability.state).thenReturn(
        AvailabilityState(
          readiness: warnReport,
          readinessForCheckIn: forCheckIn,
        ),
      );
      await pump(tester, TestScreens.phone, FormFactor.phone);
      await tester.pumpAndSettle();
      expect(find.text('Perhatian'), findsOneWidget);
      expect(
        find.text('Tetap Check In'),
        forCheckIn ? findsOneWidget : findsNothing,
      );
      await tester.tap(find.text('Tutup'));
      await tester.pumpAndSettle();
      verify(() => availability.add(any(that: isA<ReadinessDismissed>())))
          .called(1);
      verifyNever(() => availability.add(any(that: isA<CheckInPressed>())));
    });
  }

  testWidgets('history button has an accessible label (A.7 #9)', (
    tester,
  ) async {
    await pump(tester, TestScreens.phone, FormFactor.phone);
    expect(find.byTooltip('Riwayat Penugasan'), findsOneWidget);
  });
}
