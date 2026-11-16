part of 'profile_cubit.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    ProfileDto? profile,
    @Default(true) bool loadingProfile,
    Failure? profileError,

    /// Phone only (the watch cannot list watches).
    @Default(<PairedWatchDto>[]) List<PairedWatchDto> watches,
    @Default(false) bool loadingWatches,
    Failure? watchesError,

    /// Session id being unpaired.
    String? unpairing,

    /// Increments after each successful unpair (snackbar trigger).
    @Default(0) int unpairedCount,
    Failure? actionError,
  }) = _ProfileState;
}
