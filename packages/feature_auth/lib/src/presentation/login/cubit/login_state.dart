part of 'login_cubit.dart';

enum LoginFieldError { invalidKpk }

@freezed
abstract class LoginState with _$LoginState {
  const LoginState._();

  const factory LoginState({
    @Default('') String kpk,
    @Default('') String password,
    @Default(true) bool remember,
    @Default(false) bool submitting,
    LoginFieldError? kpkError,

    /// "KPK atau password salah!" (the backend never says which).
    @Default(false) bool invalidCredentials,

    /// Non-field failure: network, device clock, lockout.
    Failure? failure,
    SessionInfo? signedIn,
  }) = _LoginState;

  /// Masuk is disabled until both fields are filled (doc 3.1).
  bool get canSubmit =>
      kpk.trim().isNotEmpty && password.trim().isNotEmpty && !submitting;
}
