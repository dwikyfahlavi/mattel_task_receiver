part of 'shift_end_cubit.dart';

/// Banner state for the home screen.
sealed class ShiftBanner {
  const ShiftBanner();
}

final class NoShiftBanner extends ShiftBanner {
  const NoShiftBanner();
  @override
  bool operator ==(Object other) => other is NoShiftBanner;
  @override
  int get hashCode => 0;
}

/// "Sesi berakhir pukul HH:mm" (non-blocking).
final class ShiftEndingBanner extends ShiftBanner {
  const ShiftEndingBanner(this.cutoff);
  final DateTime cutoff;
  @override
  bool operator ==(Object other) =>
      other is ShiftEndingBanner && other.cutoff == cutoff;
  @override
  int get hashCode => cutoff.hashCode;
}

/// "Selesaikan penugasan untuk mengakhiri sesi" (blocking).
final class ShiftBlockedBanner extends ShiftBanner {
  const ShiftBlockedBanner(this.forceAt);
  final DateTime forceAt;
  @override
  bool operator ==(Object other) =>
      other is ShiftBlockedBanner && other.forceAt == forceAt;
  @override
  int get hashCode => forceAt.hashCode;
}
