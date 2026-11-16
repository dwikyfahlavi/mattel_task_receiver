// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_dtos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      kpk: json['kpk'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{'kpk': instance.kpk, 'password': instance.password};

_SessionGrantDto _$SessionGrantDtoFromJson(Map<String, dynamic> json) =>
    _SessionGrantDto(
      accessToken: json['access_token'] as String,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      technician: UserProfile.fromJson(
        json['technician'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$SessionGrantDtoToJson(_SessionGrantDto instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_at': ?instance.expiresAt?.toIso8601String(),
      'technician': instance.technician.toJson(),
    };

_ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => _ProfileDto(
  kpk: (json['kpk'] as num).toInt(),
  name: json['name'] as String,
  shift: json['shift'] as String?,
  isActive: json['is_active'] as bool? ?? true,
  memberSince: json['member_since'] == null
      ? null
      : DateTime.parse(json['member_since'] as String),
  phoneNumberMasked: json['phone_number_masked'] as String?,
);

Map<String, dynamic> _$ProfileDtoToJson(_ProfileDto instance) =>
    <String, dynamic>{
      'kpk': instance.kpk,
      'name': instance.name,
      'shift': ?instance.shift,
      'is_active': instance.isActive,
      'member_since': ?instance.memberSince?.toIso8601String(),
      'phone_number_masked': ?instance.phoneNumberMasked,
    };

_DeviceDto _$DeviceDtoFromJson(Map<String, dynamic> json) => _DeviceDto(
  id: json['id'] as String?,
  name: json['name'] as String?,
  location: json['location'] as String?,
);

Map<String, dynamic> _$DeviceDtoToJson(_DeviceDto instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': ?instance.name,
      'location': ?instance.location,
    };

_PairingPreviewDto _$PairingPreviewDtoFromJson(Map<String, dynamic> json) =>
    _PairingPreviewDto(
      device: DeviceDto.fromJson(json['device'] as Map<String, dynamic>),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$PairingPreviewDtoToJson(_PairingPreviewDto instance) =>
    <String, dynamic>{
      'device': instance.device.toJson(),
      'expires_at': ?instance.expiresAt?.toIso8601String(),
    };

_ApprovePairingRequest _$ApprovePairingRequestFromJson(
  Map<String, dynamic> json,
) => _ApprovePairingRequest(code: json['code'] as String);

Map<String, dynamic> _$ApprovePairingRequestToJson(
  _ApprovePairingRequest instance,
) => <String, dynamic>{'code': instance.code};

_DeviceEnvelopeDto _$DeviceEnvelopeDtoFromJson(Map<String, dynamic> json) =>
    _DeviceEnvelopeDto(
      device: DeviceDto.fromJson(json['device'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DeviceEnvelopeDtoToJson(_DeviceEnvelopeDto instance) =>
    <String, dynamic>{'device': instance.device.toJson()};

_PairedWatchDto _$PairedWatchDtoFromJson(Map<String, dynamic> json) =>
    _PairedWatchDto(
      sessionId: json['session_id'] as String,
      device: json['device'] == null
          ? const DeviceDto()
          : DeviceDto.fromJson(json['device'] as Map<String, dynamic>),
      pairedAt: json['paired_at'] == null
          ? null
          : DateTime.parse(json['paired_at'] as String),
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
    );

Map<String, dynamic> _$PairedWatchDtoToJson(_PairedWatchDto instance) =>
    <String, dynamic>{
      'session_id': instance.sessionId,
      'device': instance.device.toJson(),
      'paired_at': ?instance.pairedAt?.toIso8601String(),
      'expires_at': ?instance.expiresAt?.toIso8601String(),
    };

_UnpairDto _$UnpairDtoFromJson(Map<String, dynamic> json) =>
    _UnpairDto(checkedOut: json['checked_out'] as bool? ?? false);

Map<String, dynamic> _$UnpairDtoToJson(_UnpairDto instance) =>
    <String, dynamic>{'checked_out': instance.checkedOut};

_EnrollRequest _$EnrollRequestFromJson(Map<String, dynamic> json) =>
    _EnrollRequest(
      code: json['code'] as String,
      publicKey: json['public_key'] as String,
      signature: json['signature'] as String,
    );

Map<String, dynamic> _$EnrollRequestToJson(_EnrollRequest instance) =>
    <String, dynamic>{
      'code': instance.code,
      'public_key': instance.publicKey,
      'signature': instance.signature,
    };

_EnrollResponseDto _$EnrollResponseDtoFromJson(Map<String, dynamic> json) =>
    _EnrollResponseDto(
      device: DeviceDto.fromJson(json['device'] as Map<String, dynamic>),
      publicKeyFingerprint: json['public_key_fingerprint'] as String?,
    );

Map<String, dynamic> _$EnrollResponseDtoToJson(_EnrollResponseDto instance) =>
    <String, dynamic>{
      'device': instance.device.toJson(),
      'public_key_fingerprint': ?instance.publicKeyFingerprint,
    };

_PairingDto _$PairingDtoFromJson(Map<String, dynamic> json) => _PairingDto(
  pairingId: json['pairing_id'] as String,
  expiresAt: DateTime.parse(json['expires_at'] as String),
  qrPayload: json['qr_payload'] as String,
);

Map<String, dynamic> _$PairingDtoToJson(_PairingDto instance) =>
    <String, dynamic>{
      'pairing_id': instance.pairingId,
      'expires_at': instance.expiresAt.toIso8601String(),
      'qr_payload': instance.qrPayload,
    };

_PairingStatusDto _$PairingStatusDtoFromJson(Map<String, dynamic> json) =>
    _PairingStatusDto(
      status: $enumDecode(
        _$PairingStatusEnumMap,
        json['status'],
        unknownValue: PairingStatus.unknown,
      ),
    );

Map<String, dynamic> _$PairingStatusDtoToJson(_PairingStatusDto instance) =>
    <String, dynamic>{'status': _$PairingStatusEnumMap[instance.status]!};

const _$PairingStatusEnumMap = {
  PairingStatus.pending: 'PENDING',
  PairingStatus.approved: 'APPROVED',
  PairingStatus.consumed: 'CONSUMED',
  PairingStatus.expired: 'EXPIRED',
  PairingStatus.cancelled: 'CANCELLED',
  PairingStatus.unknown: 'UNKNOWN',
};
