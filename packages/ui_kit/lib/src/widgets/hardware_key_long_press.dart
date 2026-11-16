import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Fires [onLongPress] when one of [androidKeyCodes] is held for [hold]
/// (WD1 II side button, doc 10.2 / 17.2). A short press does nothing, to
/// prevent accidental accepts. Only used for Terima; never for Tolak.
class HardwareKeyLongPress extends StatefulWidget {
  const HardwareKeyLongPress({
    required this.androidKeyCodes,
    required this.onLongPress,
    required this.child,
    this.enabled = true,
    this.hold = const Duration(milliseconds: 500),
    super.key,
  });

  final Set<int> androidKeyCodes;
  final VoidCallback onLongPress;
  final Widget child;
  final bool enabled;
  final Duration hold;

  /// Flutter maps known Android key codes to named logical keys and puts
  /// the rest in the Android plane.
  static LogicalKeyboardKey logicalKeyFor(int androidKeyCode) =>
      kAndroidToLogicalKey[androidKeyCode] ??
      LogicalKeyboardKey(LogicalKeyboardKey.androidPlane | androidKeyCode);

  @override
  State<HardwareKeyLongPress> createState() => _HardwareKeyLongPressState();
}

class _HardwareKeyLongPressState extends State<HardwareKeyLongPress> {
  late Set<LogicalKeyboardKey> _keys = _resolve();
  Timer? _timer;

  Set<LogicalKeyboardKey> _resolve() =>
      widget.androidKeyCodes.map(HardwareKeyLongPress.logicalKeyFor).toSet();

  @override
  void didUpdateWidget(HardwareKeyLongPress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.androidKeyCodes != widget.androidKeyCodes) _keys = _resolve();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_keys.contains(event.logicalKey)) return KeyEventResult.ignored;
    if (event is KeyDownEvent) {
      _timer?.cancel();
      if (widget.enabled) _timer = Timer(widget.hold, widget.onLongPress);
    } else if (event is KeyUpEvent) {
      _timer?.cancel();
      _timer = null;
    }
    // Repeats while held are swallowed; one long press = one accept.
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) => Focus(
    autofocus: true,
    canRequestFocus: true,
    onKeyEvent: _onKey,
    debugLabel: 'hardware-key-long-press',
    child: widget.child,
  );
}
