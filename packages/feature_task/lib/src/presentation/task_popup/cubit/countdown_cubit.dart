import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Monotonic countdown (doc 7.3).
///
/// The remaining time is captured once from `expires_at` and the corrected
/// server clock, then counted with a [Stopwatch]. Changing the device clock
/// afterwards has no effect. `emit` ignores equal states, so listeners
/// rebuild once per second although the timer ticks every 250 ms.
class CountdownCubit extends Cubit<int> {
  CountdownCubit({
    required AppClock clock,
    required DateTime expiresAtUtc,
    Stopwatch Function()? stopwatchFactory,
    this.maxSeconds = 60,
  }) : _initial = expiresAtUtc.difference(clock.serverNowUtc()),
       _watch = (stopwatchFactory ?? Stopwatch.new)(),
       super(0) {
    _watch.start();
    _tick();
    if (state > 0) {
      _timer = Timer.periodic(
        const Duration(milliseconds: 250),
        (_) => _tick(),
      );
    }
  }

  final int maxSeconds;
  final Duration _initial;
  final Stopwatch _watch;
  Timer? _timer;

  bool get isExpired => state == 0;

  void _tick() {
    final remaining = _initial - _watch.elapsed;
    // Round up so "00:01" shows until the window really closes.
    final ms = remaining.inMilliseconds;
    final secs = (ms <= 0 ? 0 : (ms + 999) ~/ 1000).clamp(0, maxSeconds);
    if (!isClosed) emit(secs);
    if (secs == 0) {
      _timer?.cancel();
      _watch.stop();
    }
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    _watch.stop();
    return super.close();
  }
}
