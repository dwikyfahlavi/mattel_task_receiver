import 'package:device_bridge/device_bridge.dart';

import '../logging/app_logger.dart';

/// Foreground service that keeps the process (and the work-order socket)
/// alive with the screen off while a technician is signed in. Android only;
/// a no-op elsewhere. Never throws.
class ForegroundKeepAlive {
  ForegroundKeepAlive([this._bridge = const DeviceBridge()]);

  final DeviceBridge _bridge;
  bool _running = false;

  bool get isRunning => _running;

  Future<void> start({required String title, required String body}) async {
    if (_running) return;
    try {
      await _bridge.startKeepAlive(title: title, body: body);
      _running = true;
    } on Object catch (e) {
      AppLogger.warn('Keep-alive service could not start', error: e);
    }
  }

  Future<void> stop() async {
    if (!_running) return;
    _running = false;
    try {
      await _bridge.stopKeepAlive();
    } on Object catch (e) {
      AppLogger.warn('Keep-alive service could not stop', error: e);
    }
  }
}
