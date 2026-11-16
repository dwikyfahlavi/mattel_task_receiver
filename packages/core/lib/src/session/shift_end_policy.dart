import 'package:meta/meta.dart';

import 'session_models.dart';

/// Where we are relative to the shift-end cutoff (doc 4.3).
@immutable
sealed class ShiftEndPhase {
  const ShiftEndPhase();
}

/// More than [ShiftEndPolicy.warningLead] before the cutoff.
final class ShiftActive extends ShiftEndPhase {
  const ShiftActive(this.cutoff);
  final DateTime cutoff;
}

/// Non-blocking banner "Sesi berakhir pukul HH:mm".
final class ShiftEndingSoon extends ShiftEndPhase {
  const ShiftEndingSoon(this.cutoff);
  final DateTime cutoff;
}

/// Cutoff passed while a task is In Progress: blocking banner
/// "Selesaikan penugasan untuk mengakhiri sesi" until [forceAt].
final class ShiftEndBlockedByTask extends ShiftEndPhase {
  const ShiftEndBlockedByTask({required this.cutoff, required this.forceAt});
  final DateTime cutoff;
  final DateTime forceAt;
}

/// End the session now.
final class ShiftEnded extends ShiftEndPhase {
  const ShiftEnded({required this.forced});

  /// True when the grace period expired with a task still In Progress.
  final bool forced;
}

/// Pure shift-end rules, driven by the corrected server clock.
abstract final class ShiftEndPolicy {
  static const warningLead = Duration(minutes: 15);

  static ShiftEndPhase evaluate({
    required DateTime nowUtc,
    required SessionPolicy policy,
    required bool taskInProgress,
  }) {
    final cutoff = policy.sessionExpiresAt.toUtc();
    if (nowUtc.isBefore(cutoff.subtract(warningLead))) {
      return ShiftActive(cutoff);
    }
    if (nowUtc.isBefore(cutoff)) return ShiftEndingSoon(cutoff);
    final forceAt = cutoff.add(policy.grace);
    if (taskInProgress && nowUtc.isBefore(forceAt)) {
      return ShiftEndBlockedByTask(cutoff: cutoff, forceAt: forceAt);
    }
    return ShiftEnded(forced: taskInProgress);
  }

  /// When the phase can next change, for scheduling a single timer.
  static DateTime? nextTransition(ShiftEndPhase phase) => switch (phase) {
    ShiftActive(:final cutoff) => cutoff.subtract(warningLead),
    ShiftEndingSoon(:final cutoff) => cutoff,
    ShiftEndBlockedByTask(:final forceAt) => forceAt,
    ShiftEnded() => null,
  };
}
