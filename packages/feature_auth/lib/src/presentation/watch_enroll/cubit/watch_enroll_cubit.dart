import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/auth_dtos.dart';
import '../../../data/auth_repository.dart';

part 'watch_enroll_cubit.freezed.dart';
part 'watch_enroll_state.dart';

/// One-time watch enrollment (backend guide, part 2 steps 1-2): the code
/// from the admin is typed, scanned with the camera, or read by the built-in
/// scanner; the key pair is created on first use.
class WatchEnrollCubit extends Cubit<WatchEnrollState> {
  WatchEnrollCubit({
    required AuthRepository repository,
    required ConnectivityService connectivity,
    Stream<String> hardwareScans = const Stream.empty(),
  }) : _repo = repository,
       _connectivity = connectivity,
       super(const WatchEnrollState()) {
    _scanSub = hardwareScans.listen(scanned);
  }

  final AuthRepository _repo;
  final ConnectivityService _connectivity;
  late final StreamSubscription<String> _scanSub;

  void codeChanged(String raw) =>
      emit(state.copyWith(code: raw, invalidCode: false, failure: null));

  /// A QR from the camera or the hardware scanner: fills the code and
  /// enrolls at once.
  Future<void> scanned(String raw) async {
    if (state.submitting || state.device != null) return;
    final code = PairQrPayload.enrollmentCode(raw);
    if (code == null) {
      emit(state.copyWith(invalidCode: true, failure: null));
      return;
    }
    emit(state.copyWith(code: code, invalidCode: false, failure: null));
    await submit();
  }

  Future<void> submit() async {
    if (state.submitting || state.device != null) return;
    final code = PairQrPayload.normalizeEnrollmentCode(state.code);
    if (code == null) {
      emit(state.copyWith(invalidCode: true));
      return;
    }
    if (!_connectivity.isOnline) {
      emit(state.copyWith(failure: const NoConnectionFailure()));
      return;
    }
    emit(state.copyWith(submitting: true, failure: null, invalidCode: false));
    final r = await _repo.enroll(code);
    if (isClosed) return;
    emit(
      r.fold(
        (device) => state.copyWith(submitting: false, device: device),
        (f) => state.copyWith(submitting: false, failure: f),
      ),
    );
  }

  @override
  Future<void> close() async {
    await _scanSub.cancel();
    return super.close();
  }
}
