// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthTokens _$AuthTokensFromJson(Map<String, dynamic> json) => _AuthTokens(
  accessToken: json['access_token'] as String,
  expiresAt: json['expires_at'] == null
      ? null
      : DateTime.parse(json['expires_at'] as String),
);

Map<String, dynamic> _$AuthTokensToJson(_AuthTokens instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expires_at': ?instance.expiresAt?.toIso8601String(),
    };

_UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => _UserProfile(
  kpk: (json['kpk'] as num).toInt(),
  name: json['name'] as String,
  shift: json['shift'] as String?,
  role:
      $enumDecodeNullable(
        _$UserRoleEnumMap,
        json['role'],
        unknownValue: UserRole.unknown,
      ) ??
      UserRole.technician,
);

Map<String, dynamic> _$UserProfileToJson(_UserProfile instance) =>
    <String, dynamic>{
      'kpk': instance.kpk,
      'name': instance.name,
      'shift': ?instance.shift,
      'role': _$UserRoleEnumMap[instance.role]!,
    };

const _$UserRoleEnumMap = {
  UserRole.technician: 'technician',
  UserRole.vendorTechnician: 'vendor_technician',
  UserRole.unknown: 'unknown',
};

_SessionPolicy _$SessionPolicyFromJson(Map<String, dynamic> json) =>
    _SessionPolicy(
      sessionExpiresAt: DateTime.parse(json['session_expires_at'] as String),
      graceSeconds: (json['grace_seconds'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SessionPolicyToJson(_SessionPolicy instance) =>
    <String, dynamic>{
      'session_expires_at': instance.sessionExpiresAt.toIso8601String(),
      'grace_seconds': instance.graceSeconds,
    };

_SessionInfo _$SessionInfoFromJson(Map<String, dynamic> json) => _SessionInfo(
  user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
  policy: SessionPolicy.fromJson(json['policy'] as Map<String, dynamic>),
  startedAt: json['started_at'] == null
      ? null
      : DateTime.parse(json['started_at'] as String),
);

Map<String, dynamic> _$SessionInfoToJson(_SessionInfo instance) =>
    <String, dynamic>{
      'user': instance.user.toJson(),
      'policy': instance.policy.toJson(),
      'started_at': ?instance.startedAt?.toIso8601String(),
    };
