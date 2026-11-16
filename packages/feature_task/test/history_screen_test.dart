import 'package:core/core.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ui_kit/testing.dart';
import 'package:ui_kit/ui_kit.dart';

import 'helpers.dart';

class _MockRepo extends Mock implements TaskRepository {}

void main() {
  setUpAll(() async {
    await initializeDateFormatting(JakartaTime.locale);
    registerFallbackValue(<WorkOrderDisplayStatus>{});
  });

  final now = DateTime.utc(2026, 10, 27, 2, 38);
  late _MockRepo repo;

  WorkOrderDto entry(String id, WorkOrderDisplayStatus status) => WorkOrderDto(
    id: id,
    requestId: 'WO-$id',
    createdAt: now,
    updatedAt: now,
    machine: MachineDto(id: 'MC-$id', cellPosition: 'B-12'),
    issue: 'Changeover',
    displayStatus: status,
  );

  WorkOrderPageDto page(
    List<WorkOrderDto> items, {
    int no = 1,
    int pages = 1,
  }) => WorkOrderPageDto(
    items: items,
    pagination: PaginationDto(
      page: no,
      totalData: items.length,
      totalPages: pages,
    ),
  );

  setUp(() {
    repo = _MockRepo();
    when(
      () => repo.history(
        page: any(named: 'page'),
        statuses: any(named: 'statuses'),
      ),
    ).thenAnswer(
      (_) async => Result.ok(
        page([
          entry('1', WorkOrderDisplayStatus.inProgress),
          entry('2', WorkOrderDisplayStatus.completed),
          entry('3', WorkOrderDisplayStatus.declined),
        ]),
      ),
    );
    when(() => repo.detail(any())).thenAnswer(
      (i) async => Result.ok(
        entry(
          i.positionalArguments.first as String,
          WorkOrderDisplayStatus.completed,
        ).copyWith(
          machine: const MachineDto(
            id: 'MC-2',
            cellPosition: 'B-12',
            type: 'Injection Molding',
          ),
          issueAction: 'Ganti nozzle',
          repair: RepairDto(problemStartedAt: now, finishedAt: now),
        ),
      ),
    );
  });

  Future<void> pump(
    WidgetTester tester,
    Size size,
    FormFactor ff,
    Widget w,
  ) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      RepositoryProvider<AppClock>.value(
        value: FakeAppClock(now),
        child: testApp(w, formFactor: ff),
      ),
    );
    await tester.pump();
    await tester.pump();
  }

  for (final e in TestScreens.all.entries) {
    final (size, ff) = e.value;
    testWidgets('history lays out on ${e.key}', (tester) async {
      await pump(
        tester,
        size,
        ff,
        HistoryScreen(repository: repo, onBack: () {}),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('MC-1'), findsOneWidget);
      expect(find.text('Semua'), findsOneWidget);
    });

    testWidgets('work order detail lays out on ${e.key}', (tester) async {
      await pump(
        tester,
        size,
        ff,
        WorkOrderDetailScreen(
          repository: repo,
          workOrderId: '2',
          onBack: () {},
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.text('Ganti nozzle'), findsOneWidget);
      expect(find.text('Injection Molding'), findsOneWidget);
    });
  }

  testWidgets('In Progress goes Home, others open the detail', (tester) async {
    var home = 0;
    final opened = <String>[];
    await pump(
      tester,
      TestScreens.phone,
      FormFactor.phone,
      HistoryScreen(
        repository: repo,
        onBack: () {},
        onOpenInProgress: () => home++,
        onOpenDetail: opened.add,
      ),
    );
    await tester.tap(find.text('MC-2'));
    await tester.tap(find.text('MC-1'));
    await tester.pump();
    expect(home, 1);
    expect(opened, ['2']);
  });

  testWidgets('declined items explain why', (tester) async {
    await pump(
      tester,
      TestScreens.phone,
      FormFactor.phone,
      HistoryScreen(repository: repo, onBack: () {}),
    );
    expect(
      find.text('Ditolak, dibatalkan atau tidak ada respon'),
      findsOneWidget,
    );
  });

  testWidgets('a filter chip reloads with the display statuses', (
    tester,
  ) async {
    await pump(
      tester,
      TestScreens.phone,
      FormFactor.phone,
      HistoryScreen(repository: repo, onBack: () {}),
    );
    final chip = find.widgetWithText(ChoiceChip, 'Selesai');
    await tester.ensureVisible(chip);
    await tester.pump();
    await tester.tap(chip);
    await tester.pump();
    await tester.pump();
    verify(
      () => repo.history(
        page: any(named: 'page'),
        statuses: {WorkOrderDisplayStatus.completed},
      ),
    ).called(1);
  });

  test('HistoryBloc pages by page number and never duplicates', () async {
    var calls = 0;
    when(
      () => repo.history(
        page: any(named: 'page'),
        statuses: any(named: 'statuses'),
      ),
    ).thenAnswer((i) async {
      calls++;
      final p = i.namedArguments[#page] as int;
      return Result.ok(
        p == 1
            ? page([entry('a', WorkOrderDisplayStatus.completed)], pages: 2)
            : page(
                [
                  entry('a', WorkOrderDisplayStatus.completed),
                  entry('b', WorkOrderDisplayStatus.completed),
                ],
                no: 2,
                pages: 2,
              ),
      );
    });
    final bloc = HistoryBloc(repo)..add(const HistoryRefreshed());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.hasMore, isTrue);
    bloc.add(const HistoryMoreRequested());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(bloc.state.items.map((w) => w.id), ['a', 'b']);
    expect(bloc.state.hasMore, isFalse);
    bloc.add(const HistoryMoreRequested());
    await Future<void>.delayed(const Duration(milliseconds: 10));
    expect(calls, 2);
    await bloc.close();
  });
}
