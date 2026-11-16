import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../data/auth_repository.dart';

part 'login_cubit.freezed.dart';
part 'login_state.dart';

/// Sign-in with KPK and the phone-number password (doc 3.1, A.4).
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repo) : super(const LoginState());

  final AuthRepository _repo;

  /// KPK is 1 to 9 digits (backend validation).
  static final kpkPattern = RegExp(r'^\d{1,9}$');

  void kpkChanged(String v) => emit(
    state.copyWith(
      kpk: v,
      kpkError: null,
      invalidCredentials: false,
      failure: null,
    ),
  );

  void passwordChanged(String v) => emit(
    state.copyWith(password: v, invalidCredentials: false, failure: null),
  );

  void rememberChanged(bool v) => emit(state.copyWith(remember: v));

  Future<void> submit() async {
    if (!state.canSubmit) return; // also blocks double taps
    if (!kpkPattern.hasMatch(state.kpk.trim())) {
      emit(state.copyWith(kpkError: LoginFieldError.invalidKpk));
      return;
    }
    emit(
      state.copyWith(
        submitting: true,
        failure: null,
        kpkError: null,
        invalidCredentials: false,
      ),
    );
    final result = await _repo.login(
      kpk: state.kpk,
      password: state.password,
      remember: state.remember,
    );
    if (isClosed) return;
    result.fold(
      (info) => emit(state.copyWith(submitting: false, signedIn: info)),
      (f) {
        if (f is ApiFailure && f.hasCode(ApiErrorCode.invalidCredentials)) {
          emit(state.copyWith(submitting: false, invalidCredentials: true));
        } else {
          emit(state.copyWith(submitting: false, failure: f));
        }
      },
    );
  }
}
