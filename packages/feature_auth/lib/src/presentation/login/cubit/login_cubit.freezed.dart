// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginState {

 String get kpk; String get password; bool get remember; bool get submitting; LoginFieldError? get kpkError;/// "KPK atau password salah!" (the backend never says which).
 bool get invalidCredentials;/// Non-field failure: network, device clock, lockout.
 Failure? get failure; SessionInfo? get signedIn;
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginStateCopyWith<LoginState> get copyWith => _$LoginStateCopyWithImpl<LoginState>(this as LoginState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LoginState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginState&&(identical(other.kpk, _this.kpk) || other.kpk == _this.kpk)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.remember, _this.remember) || other.remember == _this.remember)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.kpkError, _this.kpkError) || other.kpkError == _this.kpkError)&&(identical(other.invalidCredentials, _this.invalidCredentials) || other.invalidCredentials == _this.invalidCredentials)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.signedIn, _this.signedIn) || other.signedIn == _this.signedIn));
}


@override
int get hashCode {
  final _this = this as LoginState;
  return Object.hash(runtimeType,_this.kpk,_this.password,_this.remember,_this.submitting,_this.kpkError,_this.invalidCredentials,_this.failure,_this.signedIn);
}

@override
String toString() {
  final _this = this as LoginState;
  return 'LoginState(kpk: ${_this.kpk}, password: ${_this.password}, remember: ${_this.remember}, submitting: ${_this.submitting}, kpkError: ${_this.kpkError}, invalidCredentials: ${_this.invalidCredentials}, failure: ${_this.failure}, signedIn: ${_this.signedIn})';
}


}

/// @nodoc
abstract mixin class $LoginStateCopyWith<$Res>  {
  factory $LoginStateCopyWith(LoginState value, $Res Function(LoginState) _then) = _$LoginStateCopyWithImpl;
@useResult
$Res call({
 String kpk, String password, bool remember, bool submitting, LoginFieldError? kpkError, bool invalidCredentials, Failure? failure, SessionInfo? signedIn
});


$SessionInfoCopyWith<$Res>? get signedIn;

}
/// @nodoc
class _$LoginStateCopyWithImpl<$Res>
    implements $LoginStateCopyWith<$Res> {
  _$LoginStateCopyWithImpl(this._self, this._then);

  final LoginState _self;
  final $Res Function(LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kpk = null,Object? password = null,Object? remember = null,Object? submitting = null,Object? kpkError = freezed,Object? invalidCredentials = null,Object? failure = freezed,Object? signedIn = freezed,}) {
  return _then(LoginState(
kpk: null == kpk ? _self.kpk : kpk // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,remember: null == remember ? _self.remember : remember // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,kpkError: freezed == kpkError ? _self.kpkError : kpkError // ignore: cast_nullable_to_non_nullable
as LoginFieldError?,invalidCredentials: null == invalidCredentials ? _self.invalidCredentials : invalidCredentials // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,signedIn: freezed == signedIn ? _self.signedIn : signedIn // ignore: cast_nullable_to_non_nullable
as SessionInfo?,
  ));
}
/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionInfoCopyWith<$Res>? get signedIn {
    if (_self.signedIn == null) {
    return null;
  }

  return $SessionInfoCopyWith<$Res>(_self.signedIn!, (value) {
    return _then(_self.copyWith(signedIn: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginState].
extension LoginStatePatterns on LoginState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginState value)  $default,){
final _that = this;
switch (_that) {
case _LoginState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginState value)?  $default,){
final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kpk,  String password,  bool remember,  bool submitting,  LoginFieldError? kpkError,  bool invalidCredentials,  Failure? failure,  SessionInfo? signedIn)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.kpk,_that.password,_that.remember,_that.submitting,_that.kpkError,_that.invalidCredentials,_that.failure,_that.signedIn);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kpk,  String password,  bool remember,  bool submitting,  LoginFieldError? kpkError,  bool invalidCredentials,  Failure? failure,  SessionInfo? signedIn)  $default,) {final _that = this;
switch (_that) {
case _LoginState():
return $default(_that.kpk,_that.password,_that.remember,_that.submitting,_that.kpkError,_that.invalidCredentials,_that.failure,_that.signedIn);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kpk,  String password,  bool remember,  bool submitting,  LoginFieldError? kpkError,  bool invalidCredentials,  Failure? failure,  SessionInfo? signedIn)?  $default,) {final _that = this;
switch (_that) {
case _LoginState() when $default != null:
return $default(_that.kpk,_that.password,_that.remember,_that.submitting,_that.kpkError,_that.invalidCredentials,_that.failure,_that.signedIn);case _:
  return null;

}
}

}

/// @nodoc


class _LoginState extends LoginState {
  const _LoginState({this.kpk = '', this.password = '', this.remember = true, this.submitting = false, this.kpkError, this.invalidCredentials = false, this.failure, this.signedIn}): super._();
  

@override@JsonKey() final  String kpk;
@override@JsonKey() final  String password;
@override@JsonKey() final  bool remember;
@override@JsonKey() final  bool submitting;
@override final  LoginFieldError? kpkError;
/// "KPK atau password salah!" (the backend never says which).
@override@JsonKey() final  bool invalidCredentials;
/// Non-field failure: network, device clock, lockout.
@override final  Failure? failure;
@override final  SessionInfo? signedIn;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginStateCopyWith<_LoginState> get copyWith => __$LoginStateCopyWithImpl<_LoginState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginState&&(identical(other.kpk, kpk) || other.kpk == kpk)&&(identical(other.password, password) || other.password == password)&&(identical(other.remember, remember) || other.remember == remember)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.kpkError, kpkError) || other.kpkError == kpkError)&&(identical(other.invalidCredentials, invalidCredentials) || other.invalidCredentials == invalidCredentials)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.signedIn, signedIn) || other.signedIn == signedIn));
}


@override
int get hashCode {
    return Object.hash(runtimeType,kpk,password,remember,submitting,kpkError,invalidCredentials,failure,signedIn);
}

@override
String toString() {
    return 'LoginState(kpk: $kpk, password: $password, remember: $remember, submitting: $submitting, kpkError: $kpkError, invalidCredentials: $invalidCredentials, failure: $failure, signedIn: $signedIn)';
}


}

/// @nodoc
abstract mixin class _$LoginStateCopyWith<$Res> implements $LoginStateCopyWith<$Res> {
  factory _$LoginStateCopyWith(_LoginState value, $Res Function(_LoginState) _then) = __$LoginStateCopyWithImpl;
@override @useResult
$Res call({
 String kpk, String password, bool remember, bool submitting, LoginFieldError? kpkError, bool invalidCredentials, Failure? failure, SessionInfo? signedIn
});


@override $SessionInfoCopyWith<$Res>? get signedIn;

}
/// @nodoc
class __$LoginStateCopyWithImpl<$Res>
    implements _$LoginStateCopyWith<$Res> {
  __$LoginStateCopyWithImpl(this._self, this._then);

  final _LoginState _self;
  final $Res Function(_LoginState) _then;

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kpk = null,Object? password = null,Object? remember = null,Object? submitting = null,Object? kpkError = freezed,Object? invalidCredentials = null,Object? failure = freezed,Object? signedIn = freezed,}) {
  return _then(_LoginState(
kpk: null == kpk ? _self.kpk : kpk // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,remember: null == remember ? _self.remember : remember // ignore: cast_nullable_to_non_nullable
as bool,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,kpkError: freezed == kpkError ? _self.kpkError : kpkError // ignore: cast_nullable_to_non_nullable
as LoginFieldError?,invalidCredentials: null == invalidCredentials ? _self.invalidCredentials : invalidCredentials // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,signedIn: freezed == signedIn ? _self.signedIn : signedIn // ignore: cast_nullable_to_non_nullable
as SessionInfo?,
  ));
}

/// Create a copy of LoginState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionInfoCopyWith<$Res>? get signedIn {
    if (_self.signedIn == null) {
    return null;
  }

  return $SessionInfoCopyWith<$Res>(_self.signedIn!, (value) {
    return _then(_self.copyWith(signedIn: value));
  });
}
}

// dart format on
