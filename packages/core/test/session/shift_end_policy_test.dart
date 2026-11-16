import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // 15:40 WIB.
  final cutoff = DateTime.utc(2026, 10, 27, 8, 40);
  final policy = SessionPolicy(sessionExpiresAt: cutoff, graceSeconds: 900);

  ShiftEndPhase at(Duration fromCutoff, {bool inProgress = false}) =>
      ShiftEndPolicy.evaluate(
        nowUtc: cutoff.add(fromCutoff),
        policy: policy,
        taskInProgress: inProgress,
      );

  test('active until 15 minutes before the cutoff', () {
    expect(at(const Duration(minutes: -16)), isA<ShiftActive>());
  });

  test('warning banner in the last 15 minutes', () {
    expect(at(const Duration(minutes: -15)), isA<ShiftEndingSoon>());
    expect(at(const Duration(seconds: -1)), isA<ShiftEndingSoon>());
  });

  test('cutoff with no task in progress ends the session', () {
    final p = at(Duration.zero);
    expect(p, isA<ShiftEnded>());
    expect((p as ShiftEnded).forced, isFalse);
  });

  test('no logout while a task is in progress, until the grace period', () {
    final p = at(const Duration(minutes: 5), inProgress: true);
    expect(p, isA<ShiftEndBlockedByTask>());
    expect(
      (p as ShiftEndBlockedByTask).forceAt,
      cutoff.add(const Duration(minutes: 15)),
    );
  });

  test('forced logout after the grace period', () {
    final p = at(const Duration(minutes: 15), inProgress: true);
    expect(p, isA<ShiftEnded>());
    expect((p as ShiftEnded).forced, isTrue);
  });

  test('a session found expired at cold start ends immediately', () {
    expect(at(const Duration(hours: 10)), isA<ShiftEnded>());
  });

  test('next transition points at the following boundary', () {
    expect(
      ShiftEndPolicy.nextTransition(at(const Duration(hours: -2))),
      cutoff.subtract(const Duration(minutes: 15)),
    );
    expect(
      ShiftEndPolicy.nextTransition(at(const Duration(minutes: -5))),
      cutoff,
    );
    expect(ShiftEndPolicy.nextTransition(at(Duration.zero)), isNull);
  });
}
