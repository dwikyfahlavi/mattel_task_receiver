import 'dart:convert';

import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_dtos.freezed.dart';
part 'auth_dtos.g.dart';

/// `POST /technician-auth/login`. [kpk] is 1 to 9 digits; [password] is
/// the technician's phone number (`0…` or `62…`).
@freezed
abstract class LoginRequest with _$LoginRequest {
  const factory LoginRequest({required String kpk, required String password}) =
      _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Login and watch-exchange answer.
@freezed
abstract class SessionGrantDto with _$SessionGrantDto {
  const SessionGrantDto._();

  const factory SessionGrantDto({
    required String accessToken,
    DateTime? expiresAt,
    required UserProfile technician,
  }) = _SessionGrantDto;

  factory SessionGrantDto.fromJson(Map<String, dynamic> json) =>
      _$SessionGrantDtoFromJson(json);

  AuthTokens get tokens =>
      AuthTokens(accessToken: accessToken, expiresAt: expiresAt);
}

/// `GET /technicians/me/profile`. The phone number is only ever masked (it
/// is the temporary login password).
@freezed
abstract class ProfileDto with _$ProfileDto {
  const factory ProfileDto({
    required int kpk,
    required String name,
    String? shift,
    @Default(true) bool isActive,
    DateTime? memberSince,
    String? phoneNumberMasked,
  }) = _ProfileDto;

  factory ProfileDto.fromJson(Map<String, dynamic> json) =>
      _$ProfileDtoFromJson(json);
}

/// A watch as the backend describes it.
@freezed
abstract class DeviceDto with _$DeviceDto {
  const factory DeviceDto({String? id, String? name, String? location}) =
      _DeviceDto;

  factory DeviceDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceDtoFromJson(json);
}

/// `GET /technicians/me/pairings/preview` (phone, before approving).
@freezed
abstract class PairingPreviewDto with _$PairingPreviewDto {
  const factory PairingPreviewDto({
    required DeviceDto device,
    DateTime? expiresAt,
  }) = _PairingPreviewDto;

  factory PairingPreviewDto.fromJson(Map<String, dynamic> json) =>
      _$PairingPreviewDtoFromJson(json);
}

@freezed
abstract class ApprovePairingRequest with _$ApprovePairingRequest {
  const factory ApprovePairingRequest({required String code}) =
      _ApprovePairingRequest;

  factory ApprovePairingRequest.fromJson(Map<String, dynamic> json) =>
      _$ApprovePairingRequestFromJson(json);
}

/// `POST …/approve` answer.
@freezed
abstract class DeviceEnvelopeDto with _$DeviceEnvelopeDto {
  const factory DeviceEnvelopeDto({required DeviceDto device}) =
      _DeviceEnvelopeDto;

  factory DeviceEnvelopeDto.fromJson(Map<String, dynamic> json) =>
      _$DeviceEnvelopeDtoFromJson(json);
}

/// A watch paired to the technician (`GET /technicians/me/devices`).
@freezed
abstract class PairedWatchDto with _$PairedWatchDto {
  const factory PairedWatchDto({
    required String sessionId,
    @Default(DeviceDto()) DeviceDto device,
    DateTime? pairedAt,
    DateTime? expiresAt,
  }) = _PairedWatchDto;

  factory PairedWatchDto.fromJson(Map<String, dynamic> json) =>
      _$PairedWatchDtoFromJson(json);

  /// From a `watch:paired` event.
  static PairedWatchDto fromEvent(PairedWatch w) => PairedWatchDto(
    sessionId: w.sessionId,
    device: DeviceDto(id: w.deviceId, name: w.name, location: w.location),
    pairedAt: w.pairedAt,
    expiresAt: w.expiresAt,
  );
}

/// Unpair answers: `checked_out` is false when the technician was not
/// checked in.
@freezed
abstract class UnpairDto with _$UnpairDto {
  const factory UnpairDto({@Default(false) bool checkedOut}) = _UnpairDto;

  factory UnpairDto.fromJson(Map<String, dynamic> json) =>
      _$UnpairDtoFromJson(json);
}

// ------------------------------------------------------------------ watch

/// `POST /shared-devices/enroll`.
@freezed
abstract class EnrollRequest with _$EnrollRequest {
  const factory EnrollRequest({
    required String code,
    required String publicKey,
    required String signature,
  }) = _EnrollRequest;

  factory EnrollRequest.fromJson(Map<String, dynamic> json) =>
      _$EnrollRequestFromJson(json);
}

@freezed
abstract class EnrollResponseDto with _$EnrollResponseDto {
  const factory EnrollResponseDto({
    required DeviceDto device,
    String? publicKeyFingerprint,
  }) = _EnrollResponseDto;

  factory EnrollResponseDto.fromJson(Map<String, dynamic> json) =>
      _$EnrollResponseDtoFromJson(json);
}

/// `POST /shared-devices/pairings`: valid 60 s; asking again cancels it.
@freezed
abstract class PairingDto with _$PairingDto {
  const factory PairingDto({
    required String pairingId,
    required DateTime expiresAt,

    /// Shown as the QR exactly as it is.
    required String qrPayload,
  }) = _PairingDto;

  factory PairingDto.fromJson(Map<String, dynamic> json) =>
      _$PairingDtoFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum PairingStatus { pending, approved, consumed, expired, cancelled, unknown }

@freezed
abstract class PairingStatusDto with _$PairingStatusDto {
  const factory PairingStatusDto({
    @JsonKey(unknownEnumValue: PairingStatus.unknown)
    required PairingStatus status,
  }) = _PairingStatusDto;

  factory PairingStatusDto.fromJson(Map<String, dynamic> json) =>
      _$PairingStatusDtoFromJson(json);
}

/// The watch QR: `{ "v": 1, "t": "pair", "code": "…" }`. The admin's
/// enrollment QR looks similar but has no `t`.
abstract final class PairQrPayload {
  static const type = 'pair';

  /// The pairing code, or null when [raw] is not a watch pairing QR.
  static String? pairingCode(String raw) {
    final data = _decode(raw);
    if (data == null || data['t'] != type) return null;
    final code = data['code'];
    return code is String && code.isNotEmpty ? code : null;
  }

  /// True for a well-formed QR of another kind (e.g. the enrollment QR), so
  /// the phone can say "this is not a watch pairing code".
  static bool isOtherKind(String raw) {
    final data = _decode(raw);
    return data != null && data['t'] != type;
  }

  /// Enrollment code from the admin QR `{"v":1,"code":"K7M2Q9XD4B"}` or a
  /// bare code (scanned or typed). Null for a pairing QR or anything else.
  static String? enrollmentCode(String raw) {
    final text = raw.trim();
    final data = _decode(text);
    if (data != null) {
      if (data['t'] != null) return null;
      final code = data['code'];
      return code is String ? normalizeEnrollmentCode(code) : null;
    }
    return normalizeEnrollmentCode(text);
  }

  /// Upper case letters and digits, 4 to 32 characters.
  static String? normalizeEnrollmentCode(String raw) {
    final code = raw.trim().toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
    return RegExp(r'^[A-Z0-9]{4,32}$').hasMatch(code) ? code : null;
  }

  static Map<String, Object?>? _decode(String raw) {
    if (raw.length > 512) return null;
    try {
      final data = jsonDecode(raw);
      return data is Map<String, Object?> && data['v'] == 1 ? data : null;
    } on FormatException {
      return null;
    }
  }
}
