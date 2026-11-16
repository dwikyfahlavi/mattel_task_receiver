import 'dart:async';

import 'package:flutter/widgets.dart';

/// Listens to a plain stream for one-shot UI effects.
class StreamListener<T> extends StatefulWidget {
  const StreamListener({
    required this.stream,
    required this.onEvent,
    required this.child,
    super.key,
  });

  final Stream<T> stream;
  final void Function(BuildContext context, T event) onEvent;
  final Widget child;

  @override
  State<StreamListener<T>> createState() => _StreamListenerState<T>();
}

class _StreamListenerState<T> extends State<StreamListener<T>> {
  StreamSubscription<T>? _sub;

  @override
  void initState() {
    super.initState();
    _sub = widget.stream.listen((e) {
      if (mounted) widget.onEvent(context, e);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
