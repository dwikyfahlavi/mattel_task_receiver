import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Online state for the offline banner, action gating and queue flush (doc 16).
///
/// A network interface alone does not mean the backend is reachable (plant
/// Wi-Fi dead spots), so the state also drops to offline when requests fail
/// with connection errors, and returns to online on the next response.
abstract class ConnectivityService {
  bool get isOnline;
  Stream<bool> get onlineChanges;

  Future<void> start();

  /// Called by the network layer.
  void reportReachable();
  void reportUnreachable();

  Future<void> dispose();
}

class PlatformConnectivityService implements ConnectivityService {
  PlatformConnectivityService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;
  final _changes = StreamController<bool>.broadcast();
  StreamSubscription<List<ConnectivityResult>>? _sub;

  bool _hasInterface = true;
  bool _reachable = true;
  bool _last = true;

  @override
  bool get isOnline => _hasInterface && _reachable;

  @override
  Stream<bool> get onlineChanges => _changes.stream;

  @override
  Future<void> start() async {
    if (_sub != null) return;
    _apply(await _connectivity.checkConnectivity());
    _sub = _connectivity.onConnectivityChanged.listen(_apply);
  }

  void _apply(List<ConnectivityResult> results) {
    _hasInterface = results.any((r) => r != ConnectivityResult.none);
    // A new interface deserves a fresh chance before we call it unreachable.
    if (_hasInterface) _reachable = true;
    _emit();
  }

  @override
  void reportReachable() {
    _reachable = true;
    _emit();
  }

  @override
  void reportUnreachable() {
    _reachable = false;
    _emit();
  }

  void _emit() {
    final now = isOnline;
    if (now == _last) return;
    _last = now;
    if (!_changes.isClosed) _changes.add(now);
  }

  @override
  Future<void> dispose() async {
    await _sub?.cancel();
    await _changes.close();
  }
}
