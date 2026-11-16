import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:timezone/timezone.dart' as tz;

import '../config/remote_settings.dart';
import '../logging/app_logger.dart';
import '../time/app_clock.dart';
import 'session_models.dart';

/// One shift in Asia/Jakarta wall-clock minutes since midnight. A shift whose
/// end is before its start runs past midnight (S3 23:00-07:00).
@immutable
class ShiftWindow {
  const ShiftWindow({required this.startMinutes, required this.endMinutes});

  final int startMinutes;
  final int endMinutes;

  Duration get length {
    final raw = (endMinutes - startMinutes) % (24 * 60);
    return Duration(minutes: raw == 0 ? 24 * 60 : raw);
  }

  static int? _parseTime(Object? raw) {
    if (raw is! String) return null;
    final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(raw.trim());
    if (m == null) return null;
    final h = int.parse(m[1]!);
    final min = int.parse(m[2]!);
    if (h > 23 || min > 59) return null;
    return h * 60 + min;
  }

  @override
  bool operator ==(Object other) =>
      other is ShiftWindow &&
      other.startMinutes == startMinutes &&
      other.endMinutes == endMinutes;

  @override
  int get hashCode => Object.hash(startMinutes, endMinutes);
}

/// Shift times per shift code (`S1`, `S2`, `S3`).
///
/// The backend has no shift timer (backend guide, part 2 step 7), so the app
/// ends sessions itself. The schedule comes from Remote Config / Firestore
/// (`shift_schedule`) until the backend serves it; [defaults] apply when
/// neither has a valid value. All times are Asia/Jakarta.
@immutable
class ShiftSchedule {
  const ShiftSchedule(this.windows);

  final Map<String, ShiftWindow> windows;

  /// Placeholder until the plant confirms its shift times (DECISIONS D-24).
  static const defaultJson =
      '{"S1":{"start":"07:00","end":"15:00"},'
      '"S2":{"start":"15:00","end":"23:00"},'
      '"S3":{"start":"23:00","end":"07:00"}}';

  static final ShiftSchedule defaults = parse(defaultJson)!;

  /// How early before its start a login still belongs to a shift.
  static const earlyLogin = Duration(hours: 3);

  /// Null for anything malformed (no valid shift at all).
  static ShiftSchedule? parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map) return null;
      final windows = <String, ShiftWindow>{};
      for (final entry in json.entries) {
        final v = entry.value;
        if (v is! Map) continue;
        final start = ShiftWindow._parseTime(v['start']);
        final end = ShiftWindow._parseTime(v['end']);
        if (start == null || end == null) continue;
        windows['${entry.key}'.trim().toUpperCase()] = ShiftWindow(
          startMinutes: start,
          endMinutes: end,
        );
      }
      return windows.isEmpty ? null : ShiftSchedule(windows);
    } on FormatException {
      return null;
    }
  }

  /// From remote settings, falling back to [defaults].
  static ShiftSchedule fromSettings(RemoteSettings settings) {
    final raw = settings.string(RemoteKeys.shiftSchedule);
    final parsed = parse(raw);
    if (parsed == null && raw != null) {
      AppLogger.warn('shift_schedule is invalid; using the default schedule');
    }
    return parsed ?? defaults;
  }

  /// End (UTC) of the [shift] instance that [anchorUtc] belongs to: the one
  /// running at that time, or the next one starting within [earlyLogin].
  /// Null for an unknown shift code.
  DateTime? cutoffFor(String? shift, DateTime anchorUtc) {
    final window = shift == null ? null : windows[shift.trim().toUpperCase()];
    if (window == null) return null;
    final anchor = tz.TZDateTime.from(anchorUtc.toUtc(), JakartaTime.location);
    DateTime? best;
    for (final dayOffset in const [-1, 0, 1]) {
      final day = tz.TZDateTime(
        JakartaTime.location,
        anchor.year,
        anchor.month,
        anchor.day + dayOffset,
      );
      final start = day.add(Duration(minutes: window.startMinutes));
      final end = start.add(window.length);
      final belongs =
          !anchor.isBefore(start.subtract(earlyLogin)) && anchor.isBefore(end);
      if (belongs && (best == null || end.isBefore(best))) best = end;
    }
    return best?.toUtc();
  }
}

/// Builds the [SessionPolicy] of a new or restored session.
abstract final class SessionPolicyFactory {
  /// Used when the shift is unknown and the token has no expiry.
  static const fallbackLength = Duration(hours: 12);

  static const defaultGraceMinutes = 30;

  static SessionPolicy build({
    required UserProfile user,
    required DateTime startedAtUtc,
    required ShiftSchedule schedule,
    required int graceMinutes,
    DateTime? tokenExpiresAtUtc,
  }) {
    final shiftEnd = schedule.cutoffFor(user.shift, startedAtUtc);
    final tokenEnd = tokenExpiresAtUtc?.toUtc();
    DateTime cutoff;
    if (shiftEnd != null && tokenEnd != null) {
      cutoff = shiftEnd.isBefore(tokenEnd) ? shiftEnd : tokenEnd;
    } else {
      cutoff = shiftEnd ?? tokenEnd ?? startedAtUtc.add(fallbackLength);
    }
    return SessionPolicy(
      sessionExpiresAt: cutoff,
      graceSeconds: (graceMinutes < 0 ? 0 : graceMinutes) * 60,
    );
  }

  static SessionPolicy fromSettings({
    required UserProfile user,
    required DateTime startedAtUtc,
    required RemoteSettings settings,
    DateTime? tokenExpiresAtUtc,
  }) => build(
    user: user,
    startedAtUtc: startedAtUtc,
    schedule: ShiftSchedule.fromSettings(settings),
    graceMinutes: settings.integer(
      RemoteKeys.shiftEndGraceMinutes,
      fallback: defaultGraceMinutes,
    ),
    tokenExpiresAtUtc: tokenExpiresAtUtc,
  );
}
