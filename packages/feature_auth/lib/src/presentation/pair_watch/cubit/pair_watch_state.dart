part of 'pair_watch_cubit.dart';

/// Why the last scan was not usable.
enum ScanRejection { none, unreadable, notWatchCode }

@freezed
sealed class PairWatchState with _$PairWatchState {
  const factory PairWatchState.scanning({
    @Default(ScanRejection.none) ScanRejection rejection,
  }) = PairScanning;

  /// `GET …/pairings/preview` in flight.
  const factory PairWatchState.checking(String code) = PairChecking;

  /// "Masuk ke Watch 1?" (confirm step, backend guide part 1 step 8).
  const factory PairWatchState.confirming({
    required String code,
    required DeviceDto device,
  }) = PairConfirming;

  const factory PairWatchState.approving({
    required String code,
    required DeviceDto device,
  }) = PairApproving;

  /// Approved; the watch now exchanges the pairing and logs in.
  const factory PairWatchState.success(DeviceDto device) = PairSuccess;

  const factory PairWatchState.failure(Failure failure) = PairFailure;
}
