import 'package:flutter/material.dart';

import 'qr_camera_scanner.dart';

/// Opens the camera, returns the first QR value (null when closed).
Future<String?> scanQrWithCamera(
  BuildContext context, {
  required String title,
  required String hint,
}) => Navigator.of(context).push<String>(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => _ScanOncePage(title: title, hint: hint),
  ),
);

class _ScanOncePage extends StatefulWidget {
  const _ScanOncePage({required this.title, required this.hint});

  final String title;
  final String hint;

  @override
  State<_ScanOncePage> createState() => _ScanOncePageState();
}

class _ScanOncePageState extends State<_ScanOncePage> {
  bool _done = false;

  @override
  Widget build(BuildContext context) => QrCameraScanner(
    title: widget.title,
    hint: widget.hint,
    paused: _done,
    onDetect: (raw) {
      if (_done) return;
      setState(() => _done = true);
      Navigator.of(context).pop(raw);
    },
    onClose: () => Navigator.of(context).pop(),
  );
}
