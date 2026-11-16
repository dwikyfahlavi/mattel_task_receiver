import 'package:fake_async/fake_async.dart';
import 'package:feature_task/feature_task.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  final start = DateTime.utc(2026, 10, 27, 2, 38);

  test(
    'countdown reaches zero after 60s without relying on DateTime.now()',
    () {
      fakeAsync((async) {
        final clock = FakeAppClock(start);
        final cubit = CountdownCubit(
          clock: clock,
          expiresAtUtc: DateTime.utc(2026, 10, 27, 2, 39),
          stopwatchFactory: async.getClock(start).stopwatch,
        );
        expect(cubit.state, 60);
        async.elapse(const Duration(seconds: 30));
        expect(cubit.state, 30);
        async.elapse(const Duration(seconds: 31));
        expect(cubit.state, 0);
        cubit.close();
      });
    },
  );

  test(
    'changing the device clock does not change the countdown (doc 20 case 1)',
    () {
      fakeAsync((async) {
        final clock = FakeAppClock(start);
        final cubit = CountdownCubit(
          clock: clock,
          expiresAtUtc: start.add(const Duration(seconds: 60)),
          stopwatchFactory: async.getClock(start).stopwatch,
        );
        async.elapse(const Duration(seconds: 10));
        clock.changeDeviceClock(const Duration(hours: -3));
        async.elapse(const Duration(seconds: 10));
        expect(cubit.state, 40);
        cubit.close();
      });
    },
  );

  test('stops ticking after close', () {
    fakeAsync((async) {
      final cubit = CountdownCubit(
        clock: FakeAppClock(start),
        expiresAtUtc: start.add(const Duration(seconds: 60)),
        stopwatchFactory: async.getClock(start).stopwatch,
      );
      cubit.close();
      async.flushMicrotasks();
      expect(async.pendingTimers, isEmpty);
    });
  });

  test('stops its timer on its own at zero', () {
    fakeAsync((async) {
      final cubit = CountdownCubit(
        clock: FakeAppClock(start),
        expiresAtUtc: start.add(const Duration(seconds: 2)),
        stopwatchFactory: async.getClock(start).stopwatch,
      );
      async.elapse(const Duration(seconds: 3));
      expect(cubit.state, 0);
      expect(async.periodicTimerCount, 0);
      cubit.close();
    });
  });

  test('an already expired assignment starts at zero with no timer', () {
    fakeAsync((async) {
      final cubit = CountdownCubit(
        clock: FakeAppClock(start),
        expiresAtUtc: start.subtract(const Duration(seconds: 1)),
        stopwatchFactory: async.getClock(start).stopwatch,
      );
      expect(cubit.state, 0);
      expect(async.periodicTimerCount, 0);
      cubit.close();
    });
  });

  test('emits once per second although it ticks every 250 ms', () {
    fakeAsync((async) {
      final cubit = CountdownCubit(
        clock: FakeAppClock(start),
        expiresAtUtc: start.add(const Duration(seconds: 60)),
        stopwatchFactory: async.getClock(start).stopwatch,
      );
      final states = <int>[];
      final sub = cubit.stream.listen(states.add);
      async.elapse(const Duration(seconds: 3));
      expect(states, [59, 58, 57]);
      sub.cancel();
      cubit.close();
    });
  });
}
