import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers.dart';

/// Jakarta wall-clock time as UTC (WIB is UTC+7).
DateTime wib(int y, int m, int d, int h, [int min = 0]) =>
    DateTime.utc(y, m, d, h, min).subtract(const Duration(hours: 7));

void main() {
  const user = UserProfile(kpk: 31, name: 'Mulyadi', shift: 'S1');

  group('ShiftSchedule', () {
    final s = ShiftSchedule.defaults;

    test('a day shift ends the same day', () {
      expect(s.cutoffFor('S1', wib(2026, 11, 12, 8)), wib(2026, 11, 12, 15));
    });

    test('a login shortly before the shift belongs to it', () {
      expect(s.cutoffFor('S1', wib(2026, 11, 12, 5)), wib(2026, 11, 12, 15));
    });

    test('a night shift ends the next morning', () {
      expect(
        s.cutoffFor('S3', wib(2026, 11, 12, 23, 30)),
        wib(2026, 11, 13, 7),
      );
      expect(s.cutoffFor('s3', wib(2026, 11, 13, 2)), wib(2026, 11, 13, 7));
    });

    test('the device time zone does not matter (doc 11)', () {
      // Same instant expressed in local time on any device.
      final local = wib(2026, 11, 12, 8).toLocal();
      expect(s.cutoffFor('S1', local), wib(2026, 11, 12, 15));
    });

    test('an unknown shift has no cutoff', () {
      expect(s.cutoffFor('S9', wib(2026, 11, 12, 8)), isNull);
      expect(s.cutoffFor(null, wib(2026, 11, 12, 8)), isNull);
    });

    test('invalid remote JSON falls back to the defaults', () {
      expect(ShiftSchedule.parse('not json'), isNull);
      expect(ShiftSchedule.parse('{"S1":{"start":"25:00","end":"x"}}'), isNull);
      final settings = staticSettings({'shift_schedule': '{oops'});
      expect(ShiftSchedule.fromSettings(settings), ShiftSchedule.defaults);
    });

    test('the schedule can come from Remote Config / Firestore', () {
      final settings = staticSettings({
        'shift_schedule': {
          'S1': {'start': '06:00', 'end': '14:00'},
        },
      });
      expect(
        ShiftSchedule.fromSettings(settings)
            .cutoffFor('S1', wib(2026, 11, 12, 8)),
        wib(2026, 11, 12, 14),
      );
    });
  });

  group('SessionPolicyFactory', () {
    test('the shift end wins when it comes before the token expiry', () {
      final p = SessionPolicyFactory.build(
        user: user,
        startedAtUtc: wib(2026, 11, 12, 8),
        schedule: ShiftSchedule.defaults,
        graceMinutes: 30,
        tokenExpiresAtUtc: wib(2026, 11, 12, 20),
      );
      expect(p.sessionExpiresAt, wib(2026, 11, 12, 15));
      expect(p.grace, const Duration(minutes: 30));
    });

    test('the 12 h watch token wins when it expires first', () {
      final p = SessionPolicyFactory.build(
        user: user,
        startedAtUtc: wib(2026, 11, 12, 8),
        schedule: ShiftSchedule.defaults,
        graceMinutes: 30,
        tokenExpiresAtUtc: wib(2026, 11, 12, 10),
      );
      expect(p.sessionExpiresAt, wib(2026, 11, 12, 10));
    });

    test('unknown shift and no expiry: 12 hours', () {
      final start = wib(2026, 11, 12, 8);
      final p = SessionPolicyFactory.build(
        user: const UserProfile(kpk: 1, name: 'x'),
        startedAtUtc: start,
        schedule: ShiftSchedule.defaults,
        graceMinutes: -5,
      );
      expect(p.sessionExpiresAt, start.add(const Duration(hours: 12)));
      expect(p.graceSeconds, 0);
    });
  });

  test('the JWT session id is read without verifying', () {
    const token = 'eyJhbGciOiJub25lIn0.eyJzZXNzaW9uX2lkIjoic2Vzcy0xIn0.sig';
    expect(const AuthTokens(accessToken: token).sessionId, 'sess-1');
    expect(const AuthTokens(accessToken: 'garbage').sessionId, isNull);
  });
}
