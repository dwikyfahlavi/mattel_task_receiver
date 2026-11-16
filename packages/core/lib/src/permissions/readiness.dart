import 'dart:io' show Platform;

import 'package:device_bridge/device_bridge.dart';
import 'package:flutter/foundation.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/app_config.dart';
import '../config/task_delivery.dart';
import '../connectivity/connectivity_service.dart';
import '../logging/app_logger.dart';
import '../tasks/task_notifications.dart';
import '../time/app_clock.dart';

/// Items of the readiness checklist (doc 12). The UI maps each to copy.
enum ReadinessItem {
  network,
  deviceClock,
  notificationPermission,
  alertChannel,
  fullScreenIntent,

  /// The work-order socket is connected (socket delivery).
  realtime,

  /// Google Play Services, needed by FCM (push delivery).
  playServices,
  batteryOptimization,
}

enum ReadinessSeverity {
  /// Blocks Check In.
  block,

  /// Shown, Check In continues.
  warn,
}

/// Fix offered next to a failed item.
enum ReadinessAction {
  none,

  /// Show the explanation, then the system permission dialog.
  requestNotificationPermission,
  openAppSettings,
  openFullScreenIntentSettings,
  requestBatteryExemption,
}

@immutable
class ReadinessResult {
  const ReadinessResult({
    required this.item,
    required this.passed,
    required this.severity,
    this.action = ReadinessAction.none,
  });

  final ReadinessItem item;
  final bool passed;
  final ReadinessSeverity severity;
  final ReadinessAction action;

  bool get blocks => !passed && severity == ReadinessSeverity.block;
  bool get warns => !passed && severity == ReadinessSeverity.warn;
}

@immutable
class ReadinessReport {
  const ReadinessReport(this.results);

  final List<ReadinessResult> results;

  bool get canCheckIn => !results.any((r) => r.blocks);
  List<ReadinessResult> get failures =>
      results.where((r) => !r.passed).toList();
  bool get allPassed => results.every((r) => r.passed);
}

/// Platform access behind an interface so every failure can be tested.
abstract class ReadinessProbe {
  bool isOnline();
  bool isClockSkewed();
  Future<PermissionStatus> notificationPermission();
  Future<bool> alertChannelEnabled();
  Future<bool> canUseFullScreenIntent();
  bool isRealtimeConnected();
  Future<bool> playServicesAvailable();
  Future<bool> batteryOptimizationExempt();
}

/// Runs the checklist. Never requests permissions itself: the UI explains
/// first and then calls the matching action (doc 12: "request in context").
class ReadinessService {
  ReadinessService(this._probe, this._kind, {TaskDelivery Function()? delivery})
    : _delivery = delivery ?? (() => TaskDelivery.defaultValue);

  final ReadinessProbe _probe;
  final AppKind _kind;

  /// Current delivery mode (remote setting): decides which channel blocks.
  final TaskDelivery Function() _delivery;

  Future<ReadinessReport> check() async {
    final delivery = _delivery();
    final notification = await _safe(
      _probe.notificationPermission,
      PermissionStatus.denied,
    );
    final notificationsOk =
        notification.isGranted || notification.isProvisional;
    final results = <ReadinessResult>[
      ReadinessResult(
        item: ReadinessItem.network,
        passed: _probe.isOnline(),
        severity: ReadinessSeverity.block,
      ),
      ReadinessResult(
        item: ReadinessItem.deviceClock,
        passed: !_probe.isClockSkewed(),
        severity: ReadinessSeverity.block,
      ),
      ReadinessResult(
        item: ReadinessItem.notificationPermission,
        passed: notificationsOk,
        severity: ReadinessSeverity.block,
        action: notification.isPermanentlyDenied || _kind == AppKind.watch
            ? ReadinessAction.openAppSettings
            : ReadinessAction.requestNotificationPermission,
      ),
      ReadinessResult(
        item: ReadinessItem.alertChannel,
        // Without notification permission the channel check is meaningless.
        passed:
            !notificationsOk || await _safe(_probe.alertChannelEnabled, false),
        severity: ReadinessSeverity.block,
        action: ReadinessAction.openAppSettings,
      ),
      ReadinessResult(
        item: ReadinessItem.fullScreenIntent,
        passed: await _safe(_probe.canUseFullScreenIntent, true),
        severity: ReadinessSeverity.warn,
        action: ReadinessAction.openFullScreenIntentSettings,
      ),
      if (delivery.usesSocket)
        ReadinessResult(
          item: ReadinessItem.realtime,
          // Only meaningful online; offline is already the network item.
          passed: !_probe.isOnline() || _probe.isRealtimeConnected(),
          severity: ReadinessSeverity.block,
        ),
      ReadinessResult(
        item: ReadinessItem.playServices,
        passed: await _safe(_probe.playServicesAvailable, false),
        // Blocks only when push is the only channel.
        severity: delivery == TaskDelivery.fcm
            ? ReadinessSeverity.block
            : ReadinessSeverity.warn,
      ),
      ReadinessResult(
        item: ReadinessItem.batteryOptimization,
        passed: await _safe(_probe.batteryOptimizationExempt, true),
        severity: ReadinessSeverity.warn,
        action: ReadinessAction.requestBatteryExemption,
      ),
    ];
    return ReadinessReport(results);
  }

  Future<T> _safe<T>(Future<T> Function() probe, T fallback) async {
    try {
      return await probe();
    } on Object catch (e) {
      AppLogger.warn('Readiness probe failed', error: e);
      return fallback;
    }
  }
}

class PlatformReadinessProbe implements ReadinessProbe {
  PlatformReadinessProbe({
    required ConnectivityService connectivity,
    required AppClock clock,
    required bool Function() realtimeConnected,
    DeviceBridge bridge = const DeviceBridge(),
  }) : _connectivity = connectivity,
       _clock = clock,
       _realtimeConnected = realtimeConnected,
       _bridge = bridge;

  final ConnectivityService _connectivity;
  final AppClock _clock;
  final bool Function() _realtimeConnected;
  final DeviceBridge _bridge;

  @override
  bool isRealtimeConnected() => _realtimeConnected();

  bool get _android => !kIsWeb && Platform.isAndroid;

  @override
  bool isOnline() => _connectivity.isOnline;

  @override
  bool isClockSkewed() => _clock.isDeviceClockSkewed;

  @override
  Future<PermissionStatus> notificationPermission() =>
      Permission.notification.status;

  @override
  Future<bool> alertChannelEnabled() =>
      _bridge.isNotificationChannelEnabled(TaskNotifications.channelId);

  @override
  Future<bool> canUseFullScreenIntent() => _bridge.canUseFullScreenIntent();

  @override
  Future<bool> playServicesAvailable() async {
    if (!_android) return true;
    final status = await GoogleApiAvailability.instance
        .checkGooglePlayServicesAvailability();
    return status == GooglePlayServicesAvailability.success;
  }

  @override
  Future<bool> batteryOptimizationExempt() async {
    if (!_android) return true;
    return Permission.ignoreBatteryOptimizations.status.isGranted;
  }
}

/// Executes the fix for a failed item.
class ReadinessActions {
  const ReadinessActions({
    required TaskNotifications notifications,
    DeviceBridge bridge = const DeviceBridge(),
  }) : _notifications = notifications,
       _bridge = bridge;

  final TaskNotifications _notifications;
  final DeviceBridge _bridge;

  Future<void> run(ReadinessAction action) async {
    switch (action) {
      case ReadinessAction.none:
        return;
      case ReadinessAction.requestNotificationPermission:
        final granted = await _notifications.requestPermission();
        if (!granted && await Permission.notification.isPermanentlyDenied) {
          await openAppSettings();
        }
      case ReadinessAction.openAppSettings:
        await openAppSettings();
      case ReadinessAction.openFullScreenIntentSettings:
        await _bridge.openFullScreenIntentSettings();
      case ReadinessAction.requestBatteryExemption:
        await Permission.ignoreBatteryOptimizations.request();
    }
  }
}
