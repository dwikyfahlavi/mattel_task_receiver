import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/auth_dtos.dart';
import '../../../data/auth_repository.dart';

part 'pair_watch_cubit.freezed.dart';
part 'pair_watch_state.dart';

/// Phone side of watch pairing (backend guide, part 1 step 8): scan the
/// watch QR, preview the watch, confirm, approve. The phone never sends a
/// user id; the server takes it from the token.
class PairWatchCubit extends Cubit<PairWatchState> {
  PairWatchCubit({
    required AuthRepository repository,
    required ConnectivityService connectivity,
  }) : _repo = repository,
       _connectivity = connectivity,
       super(const PairWatchState.scanning());

  final AuthRepository _repo;
  final ConnectivityService _connectivity;

  /// Called for every detected barcode; ignored unless scanning.
  Future<void> scanned(String raw) async {
    if (state is! PairScanning) return;
    final code = PairQrPayload.pairingCode(raw);
    if (code == null) {
      emit(
        PairWatchState.scanning(
          rejection: PairQrPayload.isOtherKind(raw)
              ? ScanRejection.notWatchCode
              : ScanRejection.unreadable,
        ),
      );
      return;
    }
    // Pairing always requires network (doc 16).
    if (!_connectivity.isOnline) {
      emit(const PairWatchState.failure(NoConnectionFailure()));
      return;
    }
    emit(PairWatchState.checking(code));
    final r = await _repo.previewPairing(code);
    if (isClosed || state is! PairChecking) return;
    emit(
      r.fold(
        (p) => PairWatchState.confirming(code: code, device: p.device),
        PairWatchState.failure,
      ),
    );
  }

  void cancel() => emit(const PairWatchState.scanning());

  Future<void> confirm() async {
    final s = state;
    if (s is! PairConfirming) return;
    if (!_connectivity.isOnline) {
      emit(const PairWatchState.failure(NoConnectionFailure()));
      return;
    }
    emit(PairWatchState.approving(code: s.code, device: s.device));
    final r = await _repo.approvePairing(s.code);
    if (isClosed) return;
    emit(
      r.fold(
        // The answer names the watch; keep the preview's name if it is empty.
        (d) => PairWatchState.success(d.name == null ? s.device : d),
        PairWatchState.failure,
      ),
    );
  }
}
