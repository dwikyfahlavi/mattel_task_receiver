import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Amber corner brackets and an animated scan line drawn over the camera
/// preview (A.2). The camera itself lives in the mobile app so the watch
/// never ships camera dependencies (doc 6).
class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({this.windowSize = 260, super.key});

  final double windowSize;

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _line = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _line.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.of(context).scanAccent;
    return IgnorePointer(
      child: Center(
        child: SizedBox.square(
          dimension: widget.windowSize,
          child: AnimatedBuilder(
            animation: _line,
            builder: (context, _) => CustomPaint(
              painter: _OverlayPainter(color: accent, progress: _line.value),
            ),
          ),
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({required this.color, required this.progress});

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const arm = 36.0;
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(0, arm)
      ..lineTo(0, 0)
      ..lineTo(arm, 0)
      ..moveTo(w - arm, 0)
      ..lineTo(w, 0)
      ..lineTo(w, arm)
      ..moveTo(w, h - arm)
      ..lineTo(w, h)
      ..lineTo(w - arm, h)
      ..moveTo(arm, h)
      ..lineTo(0, h)
      ..lineTo(0, h - arm);
    canvas.drawPath(path, paint);

    final y = 12 + (h - 24) * progress;
    canvas.drawLine(
      Offset(12, y),
      Offset(w - 12, y),
      Paint()
        ..color = color.withValues(alpha: 0.9)
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_OverlayPainter old) =>
      old.progress != progress || old.color != color;
}
