import 'package:clock/clock.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting(JakartaTime.locale));

  // Note: 27 Oct 2026 is a Tuesday ("Sel"). The design mock shows
  // "Sen, 27 Okt 2026", which is sample data with a wrong weekday.
  group('Jakarta formatting (doc 11)', () {
    test('formats a UTC instant in WIB regardless of the device zone', () {
      final clock = SystemAppClock();
      // 02:16 UTC == 09:16 WIB, Monday 26 Oct 2026.
      final instant = DateTime.utc(2026, 10, 26, 2, 16);
      expect(clock.formatDateTime(instant), 'Sen, 26 Okt 2026 | 09:16');
      expect(clock.formatTime(instant), '09:16');
    });

    test('an instant with another offset is converted, not reinterpreted', () {
      final clock = SystemAppClock();
      final instant = DateTime.parse('2026-10-25T21:16:00-05:00');
      expect(clock.formatDateTime(instant), 'Sen, 26 Okt 2026 | 09:16');
    });

    test('UTC evening is the next day in WIB', () {
      final clock = SystemAppClock();
      expect(
        clock.formatDateTime(DateTime.utc(2026, 10, 26, 18, 30)),
        'Sel, 27 Okt 2026 | 01:30',
      );
    });
  });

  group('server offset', () {
    test('serverNowUtc applies the offset learned from the server', () {
      final device = DateTime.utc(2026, 10, 27, 2);
      final clock = SystemAppClock(Clock.fixed(device));
      clock.updateServerTime(device.add(const Duration(minutes: 3)));
      expect(clock.serverNowUtc(), device.add(const Duration(minutes: 3)));
      expect(clock.isDeviceClockSkewed, isFalse);
    });

    test('a device clock off by more than 5 minutes is flagged', () {
      final device = DateTime.utc(2020, 1, 1);
      final clock = SystemAppClock(Clock.fixed(device));
      clock.updateServerTime(DateTime.utc(2026, 10, 27, 2));
      expect(clock.isDeviceClockSkewed, isTrue);
    });

    test('sub-second jitter does not move the offset', () {
      final device = DateTime.utc(2026, 10, 27, 2);
      final clock = SystemAppClock(Clock.fixed(device));
      final emitted = <Duration>[];
      clock.offsetChanges.listen(emitted.add);
      clock.updateServerTime(device.add(const Duration(seconds: 10)));
      clock.updateServerTime(
        device.add(const Duration(seconds: 10, milliseconds: 400)),
      );
      expect(clock.serverOffset, const Duration(seconds: 10));
      expect(emitted, [const Duration(seconds: 10)]);
    });
  });
}
