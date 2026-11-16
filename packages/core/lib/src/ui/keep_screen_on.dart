import 'package:flutter/widgets.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../logging/app_logger.dart';

/// Keeps the screen awake only while mounted: the QR screens and the
/// visible task popup (doc 17.2 / 18 battery rules).
class KeepScreenOn extends StatefulWidget {
  const KeepScreenOn({required this.child, super.key});

  final Widget child;

  @override
  State<KeepScreenOn> createState() => _KeepScreenOnState();
}

class _KeepScreenOnState extends State<KeepScreenOn> {
  @override
  void initState() {
    super.initState();
    _set(true);
  }

  @override
  void dispose() {
    _set(false);
    super.dispose();
  }

  Future<void> _set(bool on) async {
    try {
      await WakelockPlus.toggle(enable: on);
    } on Object catch (e) {
      AppLogger.warn('Wakelock toggle failed', error: e);
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
