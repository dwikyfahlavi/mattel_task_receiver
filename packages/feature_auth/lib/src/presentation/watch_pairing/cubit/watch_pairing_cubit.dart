import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/auth_dtos.dart';
import '../../../data/auth_repository.dart';

part 'watch_pairing_cubit.freezed.dart';
part 'watch_pairing_state.dart';

/// Watch QR login (backend guide, part 2 step 4).
///
/// * A new pairing about every 55 s while the QR is visible (it lives 60 s;
///   asking again cancels the previous one).
/// * Waits for `pairing:approved` on the unpaired socket, with a status poll
///   every ~2 s as the fallback, whichever comes first.
/// * Exchanges at once for the token (over HTTPS, never through push).
/// * Everything stops when the screen closes (no polling elsewhere, doc 18).
class WatchPairingCubit extends Cubit<WatchPairingState> {
  WatchPairingCubit({
    required AuthRepository repository,
    required AppClock clock,
    RealtimeService? realtime,
    this.pollInterval = const Duration(seconds: 2),
    this.refreshLead = const Duration(seconds: 5),
  }) : _repo = repository,
       _realtime = realtime,
       _clock = clock,
       super(const WatchPairingState.creating());

  final AuthRepository _repo;
  final RealtimeService? _realtime;
  final AppClock _clock;
  final Duration pollInterval;

  /// The QR is replaced this long before it expires.
  final Duration refreshLead;

  Timer? _poll;
  Timer? _refresh;
  StreamSubscription<RealtimeEvent>? _eventSub;
  bool _claimStarted = false;

  Future<void> start() async {
    final realtime = _realtime;
    if (realtime != null) {
      _eventSub ??= realtime.events.listen((e) {
        final s = state;
        if (e is PairingApprovedEvent &&
            s is PairingShowing &&
            e.pairingId == s.pairing.pairingId) {
          unawaited(_claim(s.pairing.pairingId));
        }
      });
      realtime.start(RealtimeMode.unpaired);
    }
    await regenerate();
  }

  /// "Buat Ulang QR Code" and the automatic refresh.
  Future<void> regenerate() async {
    if (_claimStarted || isClosed) return;
    _cancelTimers();
    emit(const WatchPairingState.creating());
    final r = await _repo.createPairing();
    if (isClosed || _claimStarted) return;
    final pairing = r.valueOrNull;
    if (pairing == null) {
      final f = r.failureOrNull;
      if (f is ApiFailure && f.hasCode(ApiErrorCode.invalidSignature)) {
        emit(const WatchPairingState.deviceRejected());
      } else {
        emit(WatchPairingState.expired(offline: f is NoConnectionFailure));
      }
      return;
    }
    emit(
      WatchPairingState.showing(pairing: pairing, qrData: pairing.qrPayload),
    );

    final ttl =
        pairing.expiresAt.difference(_clock.serverNowUtc()) - refreshLead;
    _refresh = Timer(
      ttl.isNegative ? Duration.zero : ttl,
      () => unawaited(regenerate()),
    );
    _poll = Timer.periodic(
      pollInterval,
      (_) => unawaited(_checkStatus(pairing.pairingId)),
    );
  }

  Future<void> _checkStatus(String pairingId) async {
    final r = await _repo.pairingStatus(pairingId);
    if (isClosed) return;
    switch (r.valueOrNull) {
      case PairingStatus.approved:
        await _claim(pairingId);
      case PairingStatus.expired ||
          PairingStatus.cancelled ||
          PairingStatus.consumed:
        await regenerate();
      case _:
        break;
    }
  }

  Future<void> _claim(String pairingId) async {
    if (_claimStarted) return;
    _claimStarted = true;
    _cancelTimers();
    emit(const WatchPairingState.claiming());
    final r = await _repo.exchangePairing(pairingId);
    if (isClosed) return;
    final info = r.valueOrNull;
    if (info != null) {
      // The paired socket replaces the unpaired one (the shell starts it).
      await _realtime?.stop();
      emit(WatchPairingState.done(info));
    } else {
      _claimStarted = false;
      emit(
        WatchPairingState.expired(
          offline: r.failureOrNull is NoConnectionFailure,
        ),
      );
    }
  }

  void _cancelTimers() {
    _poll?.cancel();
    _refresh?.cancel();
    _poll = null;
    _refresh = null;
  }

  @override
  Future<void> close() async {
    _cancelTimers();
    await _eventSub?.cancel();
    if (!_claimStarted && _realtime?.mode == RealtimeMode.unpaired) {
      await _realtime?.stop();
    }
    return super.close();
  }
}
