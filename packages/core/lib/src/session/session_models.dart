import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_models.freezed.dart';
part 'session_models.g.dart';

/// The technician token. The backend has no refresh token: a phone token
/// lives up to 30 days, a watch token up to 12 hours, and any `401` ends the
/// session. Only ever stored in secure storage (doc 8.1).
@freezed
abstract class AuthTokens with _$AuthTokens {
  const AuthTokens._();

  const factory AuthTokens({
    required String accessToken,

    /// From the login / exchange answer, when sent.
    DateTime? expiresAt,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);

  /// `session_id` claim of the JWT: part of every watch signature after
  /// pairing (backend guide, part 2 step 3). Null when absent or unreadable.
  String? get sessionId => JwtClaims.read(accessToken)['session_id'] as String?;
}

/// Reads JWT claims without verifying them (the server verifies; the app
/// only needs the session id). Never throws.
abstract final class JwtClaims {
  static Map<String, Object?> read(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return const {};
    try {
      final payload = utf8.decode(
        base64Url.decode(base64Url.normalize(parts[1])),
      );
      final json = jsonDecode(payload);
      return json is Map<String, dynamic> ? json : const {};
    } on FormatException {
      return const {};
    }
  }
}

/// Roles. Only technicians exist in this phase; the field is kept so the
/// Vendor Technician flow (feature flag) can be added without reworking auth.
@JsonEnum(fieldRename: FieldRename.snake)
enum UserRole { technician, vendorTechnician, unknown }

/// The signed-in technician (`technician` in the login / exchange answer).
@freezed
abstract class UserProfile with _$UserProfile {
  const UserProfile._();

  const factory UserProfile({
    /// Technician KPK (employee number).
    required int kpk,
    required String name,

    /// Shift code from the backend (`S1`, `S2`, `S3`).
    String? shift,
    @JsonKey(unknownEnumValue: UserRole.unknown)
    @Default(UserRole.technician)
    UserRole role,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  String get id => '$kpk';

  /// Up to two initials for the avatar ("Budi Andika" -> "BA").
  String get initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts
        .take(2)
        .map((p) => String.fromCharCode(p.runes.first).toUpperCase());
    final result = letters.join();
    return result.isEmpty ? '?' : result;
  }

  String get firstName => name.trim().split(RegExp(r'\s+')).first;
}

/// Shift-end policy (doc 4.3). The backend has no shift timer, so the app
/// computes the cutoff from the shift schedule (Remote Config / Firestore,
/// Asia/Jakarta) and the token expiry, whichever comes first.
@freezed
abstract class SessionPolicy with _$SessionPolicy {
  const SessionPolicy._();

  const factory SessionPolicy({
    /// UTC instant at which the app ends the session.
    required DateTime sessionExpiresAt,
    @Default(0) int graceSeconds,
  }) = _SessionPolicy;

  factory SessionPolicy.fromJson(Map<String, dynamic> json) =>
      _$SessionPolicyFromJson(json);

  Duration get grace => Duration(seconds: graceSeconds);
}

/// Everything persisted about the signed-in user except the token.
@freezed
abstract class SessionInfo with _$SessionInfo {
  const factory SessionInfo({
    required UserProfile user,
    required SessionPolicy policy,

    /// When the session started (login or watch exchange), UTC. The shift
    /// cutoff is recomputed from it when the schedule changes.
    DateTime? startedAt,
  }) = _SessionInfo;

  factory SessionInfo.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoFromJson(json);
}
