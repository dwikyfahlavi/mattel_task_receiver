/// Camera QR scanning for the watch and mobile apps (DECISIONS D-25).
///
/// Only the apps depend on this package; feature packages receive a
/// "scan with camera" callback, so they stay free of camera plugins.
library;

export 'src/qr_camera_scanner.dart';
export 'src/scan_qr_page.dart';
