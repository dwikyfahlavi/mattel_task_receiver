import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'auth_dtos.dart';

part 'auth_api.g.dart';

/// Auth, profile, pairing and watch-device endpoints (docs/api_contract.md).
///
/// Watch calls are signed by `DeviceSigningInterceptor`; before pairing they
/// carry no token (`skipAuth`), so their signature has an empty session id.
@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  // ------------------------------------------------------------- phone

  @POST('technician-auth/login')
  @Extra({RequestFlags.skipAuth: true, RequestFlags.unsigned: true})
  Future<SessionGrantDto> login(@Body() LoginRequest body);

  /// Who am I (session id and expiry). Used to verify a session after the
  /// socket refused the token.
  @GET('technician-auth/me')
  Future<dynamic> me();

  @POST('technician-auth/logout')
  Future<void> logout();

  @GET('technicians/me/profile')
  Future<ProfileDto> profile();

  /// Phone only: the watch to log in, before approving.
  @GET('technicians/me/pairings/preview')
  Future<PairingPreviewDto> previewPairing(@Query('code') String code);

  /// Phone only: approve; the watch then exchanges the pairing.
  @POST('technicians/me/pairings/approve')
  Future<DeviceEnvelopeDto> approvePairing(@Body() ApprovePairingRequest body);

  /// Phone only: my watches.
  @GET('technicians/me/devices')
  Future<List<PairedWatchDto>> devices();

  /// Phone only: checks the technician out and logs the watch out.
  @POST('technicians/me/devices/{sessionId}/unpair')
  Future<UnpairDto> unpairDevice(@Path('sessionId') String sessionId);

  // ------------------------------------------------------------- watch

  /// Unsigned: the proof is the signature in the body.
  @POST('shared-devices/enroll')
  @Extra({RequestFlags.skipAuth: true, RequestFlags.unsigned: true})
  Future<EnrollResponseDto> enroll(@Body() EnrollRequest body);

  /// Signed, no token. Checks that the enrollment is still valid.
  @GET('shared-devices/me')
  @Extra({RequestFlags.skipAuth: true})
  Future<dynamic> deviceMe();

  @POST('shared-devices/pairings')
  @Extra({RequestFlags.skipAuth: true})
  Future<PairingDto> createPairing();

  @GET('shared-devices/pairings/{id}')
  @Extra({RequestFlags.skipAuth: true})
  Future<PairingStatusDto> pairing(@Path('id') String pairingId);

  @POST('shared-devices/pairings/{id}/exchange')
  @Extra({RequestFlags.skipAuth: true})
  Future<SessionGrantDto> exchange(@Path('id') String pairingId);

  /// Watch, end of shift: checks out and ends the watch session.
  @POST('technicians/me/unpair')
  Future<UnpairDto> unpairSelf();

  // --------------------------------------------------- push (proposed)

  /// Not on the backend yet (DECISIONS D-21). Called only when the delivery
  /// mode uses FCM; a 404 is ignored.
  @POST('devices/fcm-token')
  Future<void> registerFcmToken(@Body() Map<String, dynamic> body);

  @DELETE('devices/fcm-token')
  Future<void> unregisterFcmToken(@Body() Map<String, dynamic> body);
}
