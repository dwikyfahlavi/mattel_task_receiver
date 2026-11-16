import 'dart:async';

import 'package:core/core.dart' show AppColors;
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui_kit/ui_kit.dart';

/// Full-screen QR camera: asks for the camera permission in context (after
/// a short explanation, doc 12), scans QR codes only (doc 18) and reports
/// every value through [onDetect]. Values are never logged (doc 17.1).
///
/// [paused] stops the camera (e.g. while a confirm dialog is open).
class QrCameraScanner extends StatefulWidget {
  const QrCameraScanner({
    required this.title,
    required this.hint,
    required this.onDetect,
    required this.onClose,
    this.paused = false,
    this.busy = false,
    super.key,
  });

  final String title;

  /// Text under the scan window (also used for "invalid code" feedback).
  final String hint;
  final ValueChanged<String> onDetect;
  final VoidCallback onClose;
  final bool paused;

  /// Shows a progress overlay.
  final bool busy;

  @override
  State<QrCameraScanner> createState() => _QrCameraScannerState();
}

class _QrCameraScannerState extends State<QrCameraScanner>
    with WidgetsBindingObserver {
  PermissionStatus? _status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_refresh());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(_refresh());
  }

  Future<void> _refresh() async {
    final s = await Permission.camera.status;
    if (mounted) setState(() => _status = s);
  }

  Future<void> _request() async {
    final s = _status;
    if (s != null && s.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }
    final next = await Permission.camera.request();
    if (mounted) setState(() => _status = next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final status = _status;
    if (status == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (status.isGranted || status.isLimited) {
      return _Camera(
        title: widget.title,
        hint: widget.hint,
        onDetect: widget.onDetect,
        onClose: widget.onClose,
        paused: widget.paused,
        busy: widget.busy,
      );
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: widget.onClose,
        ),
      ),
      body: MaxWidth(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                LucideIcons.scan,
                size: 48,
                color: AppColors.of(context).primary,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.cameraPermissionTitle,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(l10n.cameraPermissionBody, textAlign: TextAlign.center),
              const SizedBox(height: 24),
              AppButton(
                label: status.isPermanentlyDenied
                    ? l10n.actionOpenSettings
                    : l10n.actionAllow,
                onPressed: _request,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Camera extends StatefulWidget {
  const _Camera({
    required this.title,
    required this.hint,
    required this.onDetect,
    required this.onClose,
    required this.paused,
    required this.busy,
  });

  final String title;
  final String hint;
  final ValueChanged<String> onDetect;
  final VoidCallback onClose;
  final bool paused;
  final bool busy;

  @override
  State<_Camera> createState() => _CameraState();
}

class _CameraState extends State<_Camera> {
  // QR only (doc 18).
  final _controller = MobileScannerController(
    formats: const [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  double _zoom = 0;

  @override
  void didUpdateWidget(_Camera old) {
    super.didUpdateWidget(old);
    if (old.paused != widget.paused) {
      unawaited(widget.paused ? _controller.stop() : _controller.start());
    }
  }

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  void _setZoom(double v) {
    setState(() => _zoom = v.clamp(0, 1));
    unawaited(_controller.setZoomScale(_zoom));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final watch = context.isWatch;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        toolbarHeight: watch ? 40 : null,
        title: Text(widget.title),
        leading: IconButton(
          tooltip: l10n.actionBack,
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: widget.onClose,
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (widget.paused) return;
              for (final code in capture.barcodes) {
                final raw = code.rawValue;
                if (raw != null) {
                  widget.onDetect(raw);
                  break;
                }
              }
            },
          ),
          const ScannerOverlay(),
          if (widget.busy)
            const ColoredBox(
              color: Colors.black54,
              child: Center(child: CircularProgressIndicator()),
            ),
          Positioned(
            left: 12,
            right: 12,
            bottom: watch ? 6 : 24,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.hint,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: Colors.white),
                  ),
                  // The watch screen is too small for a zoom slider.
                  if (!watch) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          tooltip: l10n.scannerZoomOut,
                          color: Colors.white,
                          icon: const Icon(LucideIcons.minus),
                          onPressed: () => _setZoom(_zoom - 0.1),
                        ),
                        Expanded(
                          child: Slider(
                            value: _zoom,
                            label: l10n.scannerZoom,
                            activeColor: AppColors.of(context).scanAccent,
                            onChanged: _setZoom,
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.scannerZoomIn,
                          color: Colors.white,
                          icon: const Icon(LucideIcons.plus),
                          onPressed: () => _setZoom(_zoom + 0.1),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
