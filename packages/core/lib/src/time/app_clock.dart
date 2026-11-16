import 'dart:async';

import 'package:clock/clock.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest_10y.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// The only source of time in the app (doc 11). Widgets never call
/// `DateTime.now()`.
///
/// * [serverNowUtc] is device time corrected by the offset learned from the
///   `Date` header of every API response and `server_time` in `/app/config`.
/// * All display formatting is in Asia/Jakarta regardless of the device zone.
abstract class AppClock {
  /// Corrected "now" in UTC. Use for business decisions (shift end, expiry).
  DateTime serverNowUtc();

  /// Raw device time in UTC. Only for measuring the offset.
  DateTime deviceNowUtc();

  /// Current offset (server minus device).
  Duration get serverOffset;

  /// True once at least one server time sample was received.
  bool get hasServerTime;

  /// Records a server time sample.
  void updateServerTime(DateTime serverUtc);

  /// True when the device clock differs from the server by more than
  /// [AppClock.skewTolerance]. Blocks Check In (doc 12).
  bool get isDeviceClockSkewed => serverOffset.abs() > skewTolerance;

  static const skewTolerance = Duration(minutes: 5);

  tz.TZDateTime toJakarta(DateTime instant) =>
      tz.TZDateTime.from(instant.toUtc(), JakartaTime.location);

  tz.TZDateTime jakartaNow() => toJakarta(serverNowUtc());

  /// `Sen, 27 Okt 2026 | 09:16`
  String formatDateTime(DateTime instant) => DateFormat(
    'EEE, d MMM y | HH:mm',
    JakartaTime.locale,
  ).format(toJakarta(instant));

  /// `09:16`
  String formatTime(DateTime instant) =>
      DateFormat('HH:mm', JakartaTime.locale).format(toJakarta(instant));

  /// `27 Okt 2026`
  String formatDate(DateTime instant) =>
      DateFormat('d MMM y', JakartaTime.locale).format(toJakarta(instant));
}

/// Asia/Jakarta location, loaded lazily on first use (doc 18: keep startup light).
abstract final class JakartaTime {
  static const locale = 'id_ID';
  static tz.Location? _location;

  static tz.Location get location {
    final cached = _location;
    if (cached != null) return cached;
    // Only the last 10 years of rules: Asia/Jakarta has been UTC+7 since 1964.
    tzdata.initializeTimeZones();
    return _location = tz.getLocation('Asia/Jakarta');
  }
}

/// Production clock based on `package:clock` (overridable in tests via
/// `withClock`).
class SystemAppClock extends AppClock {
  /// [_source] overrides `package:clock` (tests only).
  SystemAppClock([this._source]);

  final Clock? _source;
  Duration _offset = Duration.zero;
  bool _hasServerTime = false;
  final _offsetChanges = StreamController<Duration>.broadcast(sync: true);

  /// Emits when the offset changes, so it can be persisted for the FCM
  /// background isolate.
  Stream<Duration> get offsetChanges => _offsetChanges.stream;

  /// Restores a persisted offset at startup (until the first response).
  void seedOffset(Duration offset) {
    if (!_hasServerTime) _offset = offset;
  }

  Clock get _clock => _source ?? clock;

  @override
  DateTime deviceNowUtc() => _clock.now().toUtc();

  @override
  DateTime serverNowUtc() => deviceNowUtc().add(_offset);

  @override
  Duration get serverOffset => _offset;

  @override
  bool get hasServerTime => _hasServerTime;

  @override
  void updateServerTime(DateTime serverUtc) {
    // The HTTP Date header has 1 s resolution; ignore sub-second jitter so
    // the countdown does not jump back and forth.
    final next = serverUtc.toUtc().difference(deviceNowUtc());
    if (!_hasServerTime ||
        (next - _offset).abs() >= const Duration(seconds: 1)) {
      _offset = next;
      _offsetChanges.add(next);
    }
    _hasServerTime = true;
  }
}
