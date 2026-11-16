import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler/permission_handler.dart';

class _Probe implements ReadinessProbe {
  bool online = true;
  bool skewed = false;
  PermissionStatus notification = PermissionStatus.granted;
  bool channel = true;
  bool fullScreen = true;
  bool playServices = true;
  bool realtime = true;
  bool battery = true;
  bool throwOnChannel = false;

  @override
  bool isOnline() => online;
  @override
  bool isClockSkewed() => skewed;
  @override
  Future<PermissionStatus> notificationPermission() async => notification;
  @override
  Future<bool> alertChannelEnabled() async {
    if (throwOnChannel) throw Exception('platform');
    return channel;
  }

  @override
  Future<bool> canUseFullScreenIntent() async => fullScreen;
  @override
  Future<bool> playServicesAvailable() async => playServices;
  @override
  bool isRealtimeConnected() => realtime;
  @override
  Future<bool> batteryOptimizationExempt() async => battery;
}

void main() {
  late _Probe probe;
  late ReadinessService service;

  setUp(() {
    probe = _Probe();
    service = ReadinessService(probe, AppKind.mobile);
  });

  test('everything fine allows Check In', () async {
    final r = await service.check();
    expect(r.canCheckIn, isTrue);
    expect(r.allPassed, isTrue);
  });

  final critical = <String, void Function(_Probe)>{
    'network': (p) => p.online = false,
    'device clock': (p) => p.skewed = true,
    'notification permission': (p) => p.notification = PermissionStatus.denied,
    'alert channel': (p) => p.channel = false,
    'work-order socket': (p) => p.realtime = false,
  };

  for (final entry in critical.entries) {
    test('blocks Check In when ${entry.key} fails (doc 20 case 9)', () async {
      entry.value(probe);
      final r = await service.check();
      expect(r.canCheckIn, isFalse);
      expect(r.failures, hasLength(1));
    });
  }

  group('delivery mode (D-21)', () {
    test('socket mode: Play Services only warns', () async {
      probe.playServices = false;
      final r = await service.check();
      expect(r.canCheckIn, isTrue);
      expect(r.failures.single.item, ReadinessItem.playServices);
    });

    test('FCM mode: Play Services blocks, the socket is not checked', () async {
      probe
        ..playServices = false
        ..realtime = false;
      final r = await ReadinessService(
        probe,
        AppKind.mobile,
        delivery: () => TaskDelivery.fcm,
      ).check();
      expect(r.canCheckIn, isFalse);
      expect(r.failures.single.item, ReadinessItem.playServices);
    });

    test('offline: the socket item does not fail twice', () async {
      probe
        ..online = false
        ..realtime = false;
      final r = await service.check();
      expect(r.failures.single.item, ReadinessItem.network);
    });
  });

  test('full-screen intent and battery only warn', () async {
    probe
      ..fullScreen = false
      ..battery = false;
    final r = await service.check();
    expect(r.canCheckIn, isTrue);
    expect(r.failures.every((f) => f.warns), isTrue);
  });

  test('a probe that throws fails closed for blocking items', () async {
    probe.throwOnChannel = true;
    expect((await service.check()).canCheckIn, isFalse);
  });

  test('permanently denied notifications offer app settings', () async {
    probe.notification = PermissionStatus.permanentlyDenied;
    final failure = (await service.check()).failures.single;
    expect(failure.action, ReadinessAction.openAppSettings);
  });

  test('watch never shows the permission dialog (MDM grants it)', () async {
    probe.notification = PermissionStatus.denied;
    final r = await ReadinessService(probe, AppKind.watch).check();
    expect(r.failures.single.action, ReadinessAction.openAppSettings);
  });
}
