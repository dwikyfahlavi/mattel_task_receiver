part of 'session_cubit.dart';

@freezed
sealed class SessionState with _$SessionState {
  const SessionState._();

  /// Startup: deciding the first route.
  const factory SessionState.unknown() = SessionUnknown;

  /// Signed out. [reason] explains why, for the "sesi berakhir" message.
  const factory SessionState.unauthenticated({SessionEndReason? reason}) =
      SessionUnauthenticated;

  const factory SessionState.authenticated(SessionInfo info) =
      SessionAuthenticated;

  SessionInfo? get infoOrNull => switch (this) {
    SessionAuthenticated(:final info) => info,
    _ => null,
  };
}
