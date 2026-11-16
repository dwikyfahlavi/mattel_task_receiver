part of 'watch_enroll_cubit.dart';

@freezed
abstract class WatchEnrollState with _$WatchEnrollState {
  const WatchEnrollState._();

  const factory WatchEnrollState({
    @Default('') String code,
    @Default(false) bool submitting,

    /// The typed or scanned value is not an enrollment code.
    @Default(false) bool invalidCode,
    Failure? failure,

    /// Set once enrolled.
    DeviceDto? device,
  }) = _WatchEnrollState;

  bool get canSubmit => code.trim().isNotEmpty && !submitting;
}
