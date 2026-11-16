import 'package:vibration/vibration.dart';

import '../logging/app_logger.dart';

/// Foreground alert loop (doc 10.1). In the background the notification
/// carries the pattern; in the foreground this service loops it.
///
/// Vibration is the primary signal on the plant floor. [escalate] switches
/// to a faster pattern for the last 10 seconds. [stop] must be called on
/// Terima, Tolak, timeout and `task.resolved` (the task cubit does this in
/// every exit path and in `close()`).
abstract class AlertService {
  Future<void> start();
  Future<void> escalate();
  Future<void> stop();
}

class VibrationAlertService implements AlertService {
  /// 600 on, 300 off, 600 on, 1200 pause.
  static const normalPattern = [0, 600, 300, 600, 1200];

  /// Faster pattern for the last 10 seconds.
  static const urgentPattern = [0, 300, 150, 300, 150, 300, 400];

  bool _running = false;
  bool _escalated = false;
  bool? _hasVibrator;

  Future<bool> _canVibrate() async {
    try {
      return _hasVibrator ??= await Vibration.hasVibrator();
    } on Object catch (e) {
      AppLogger.warn('Vibration unavailable', error: e);
      return _hasVibrator = false;
    }
  }

  @override
  Future<void> start() async {
    if (_running) return;
    _running = true;
    _escalated = false;
    await _play(normalPattern);
  }

  @override
  Future<void> escalate() async {
    if (!_running || _escalated) return;
    _escalated = true;
    await _play(urgentPattern);
  }

  @override
  Future<void> stop() async {
    if (!_running) return;
    _running = false;
    _escalated = false;
    try {
      await Vibration.cancel();
    } on Object catch (e) {
      AppLogger.warn('Vibration cancel failed', error: e);
    }
  }

  Future<void> _play(List<int> pattern) async {
    if (!await _canVibrate()) return;
    try {
      // repeat: 0 loops the whole pattern until cancel().
      await Vibration.vibrate(pattern: pattern, repeat: 0);
    } on Object catch (e) {
      AppLogger.warn('Vibration failed', error: e);
    }
  }
}

/// For tests and platforms without a vibrator.
class SilentAlertService implements AlertService {
  int starts = 0;
  int escalations = 0;
  int stops = 0;
  bool running = false;

  @override
  Future<void> start() async {
    starts++;
    running = true;
  }

  @override
  Future<void> escalate() async {
    if (running) escalations++;
  }

  @override
  Future<void> stop() async {
    if (running) stops++;
    running = false;
  }
}
