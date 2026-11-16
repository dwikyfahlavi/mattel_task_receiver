part of 'watch_pairing_cubit.dart';

@freezed
sealed class WatchPairingState with _$WatchPairingState {
  const factory WatchPairingState.creating() = PairingCreating;

  /// QR visible. [qrData] is the backend's `qr_payload`, shown as it is.
  const factory WatchPairingState.showing({
    required PairingDto pairing,
    required String qrData,
  }) = PairingShowing;

  /// Approved by the phone; exchanging for the technician token.
  const factory WatchPairingState.claiming() = PairingClaiming;
  const factory WatchPairingState.done(SessionInfo info) = PairingDone;

  /// "Buat Ulang QR Code". [offline] explains why.
  const factory WatchPairingState.expired({@Default(false) bool offline}) =
      PairingExpired;

  /// The device signature was refused: the admin disabled or reset this
  /// watch, so it must be enrolled again.
  const factory WatchPairingState.deviceRejected() = PairingDeviceRejected;
}
