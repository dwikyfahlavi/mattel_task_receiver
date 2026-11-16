import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/auth_repository.dart';

part 'session_cubit.freezed.dart';
part 'session_state.dart';

/// App-scoped session owner. The only place that ends a session, so the
/// wipe runs exactly once no matter how many triggers fire (401, socket or
/// push `session:ended`, shift end, manual Keluar).
class SessionCubit extends Cubit<SessionState> {
  SessionCubit({
    required AuthRepository repository,
    required SessionEventBus events,
    required AppClock clock,
    required AppConfig config,
    required FeatureFlags flags,
    required TaskEventStore taskStore,
    required KeyValueStore keyValues,
    RealtimeService? realtime,
    PushService? push,
  }) : _repo = repository,
       _clock = clock,
       _config = config,
       _flags = flags,
       _taskStore = taskStore,
       _kv = keyValues,
       super(const SessionState.unknown()) {
    _subs = [
      events.endRequests.listen((r) => unawaited(end(r))),
      if (realtime != null) realtime.events.listen(_onServerEvent),
      if (push != null) push.messages.listen((m) => _onServerEvent(m.event)),
    ];
  }

  final AuthRepository _repo;
  final AppClock _clock;
  final AppConfig _config;
  final FeatureFlags _flags;
  final TaskEventStore _taskStore;
  final KeyValueStore _kv;
  late final List<StreamSubscription<Object?>> _subs;
  Future<void>? _ending;
  Future<void>? _verifying;

  /// Maps `session:ended` reasons (backend guide, part 2 step 8).
  static SessionEndReason reasonFromServer(String? raw) => switch (raw) {
    'REPLACED' => SessionEndReason.replaced,
    'EXPIRED' => SessionEndReason.expired,
    'DEVICE_DISABLED' => SessionEndReason.deviceDisabled,
    'LOGOUT' || 'CHECK_OUT' || 'UNPAIRED' => SessionEndReason.unpaired,
    _ => SessionEndReason.revoked,
  };

  void _onServerEvent(RealtimeEvent e) {
    if (state is! SessionAuthenticated) return;
    switch (e) {
      case SessionEndedEvent(:final reason):
        unawaited(end(reasonFromServer(reason)));
      case RealtimeAuthRejected():
        // The socket refused the token. Only an HTTP 401 proves the session
        // is over (a watch clock problem also gives "Unauthorized").
        _verifying ??= _repo.verifySession().whenComplete(
          () => _verifying = null,
        );
      case _:
        break;
    }
  }

  /// Restores the session at startup and drops it **before any screen is
  /// shown** when the shift already ended (doc 4.3, device was off).
  Future<void> restore() async {
    final info = await _repo.restore();
    if (info == null) {
      emit(const SessionState.unauthenticated());
      return;
    }
    final endedInBackground = await _kv.read(sessionEndedKey);
    if (endedInBackground != null) {
      await _kv.remove(sessionEndedKey);
      await _wipe(reasonFromServer(endedInBackground), callServer: false);
      return;
    }
    if (_logsOutAtShiftEnd) {
      final active = await _taskStore.activeTask();
      final phase = ShiftEndPolicy.evaluate(
        nowUtc: _clock.serverNowUtc(),
        policy: info.policy,
        taskInProgress: active?.isInProgress ?? false,
      );
      if (phase is ShiftEnded) {
        // Best effort: unpair / logout so the next worker starts clean.
        await _wipe(SessionEndReason.shiftEnd, callServer: true);
        return;
      }
    }
    emit(SessionState.authenticated(info));
  }

  /// The watch always logs out at shift end; phones and tablets only with
  /// the `auto_logout_mobile` flag (doc 4.3).
  bool get _logsOutAtShiftEnd =>
      _config.isWatch || _flags.isEnabled(FeatureFlag.autoLogoutMobile);

  bool get logsOutAtShiftEnd => _logsOutAtShiftEnd;

  void signedIn(SessionInfo info) {
    if (!isClosed) emit(SessionState.authenticated(info));
  }

  /// Ends the session once. Concurrent calls share the same run. When the
  /// server already ended it, no logout call is made (the token is dead).
  Future<void> end(SessionEndReason reason) => _ending ??= _wipe(
    reason,
    callServer: !reason.endedByServer,
  ).whenComplete(() => _ending = null);

  Future<void> _wipe(
    SessionEndReason reason, {
    required bool callServer,
  }) async {
    if (state is SessionUnauthenticated) return;
    await _repo.endSession(callServer: callServer);
    if (reason == SessionEndReason.deviceDisabled) {
      // Signed requests fail until the admin re-enables or resets the watch.
      AppLogger.warn('Watch disabled by the admin');
    }
    if (!isClosed) emit(SessionState.unauthenticated(reason: reason));
  }

  @override
  Future<void> close() async {
    for (final s in _subs) {
      await s.cancel();
    }
    return super.close();
  }
}
