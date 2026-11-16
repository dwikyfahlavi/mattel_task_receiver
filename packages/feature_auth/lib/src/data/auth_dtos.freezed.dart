// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginRequest {

 String get kpk; String get password;
/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginRequestCopyWith<LoginRequest> get copyWith => _$LoginRequestCopyWithImpl<LoginRequest>(this as LoginRequest, _$identity);

  /// Serializes this LoginRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LoginRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginRequest&&(identical(other.kpk, _this.kpk) || other.kpk == _this.kpk)&&(identical(other.password, _this.password) || other.password == _this.password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LoginRequest;
  return Object.hash(runtimeType,_this.kpk,_this.password);
}

@override
String toString() {
  final _this = this as LoginRequest;
  return 'LoginRequest(kpk: ${_this.kpk}, password: ${_this.password})';
}


}

/// @nodoc
abstract mixin class $LoginRequestCopyWith<$Res>  {
  factory $LoginRequestCopyWith(LoginRequest value, $Res Function(LoginRequest) _then) = _$LoginRequestCopyWithImpl;
@useResult
$Res call({
 String kpk, String password
});




}
/// @nodoc
class _$LoginRequestCopyWithImpl<$Res>
    implements $LoginRequestCopyWith<$Res> {
  _$LoginRequestCopyWithImpl(this._self, this._then);

  final LoginRequest _self;
  final $Res Function(LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kpk = null,Object? password = null,}) {
  return _then(LoginRequest(
kpk: null == kpk ? _self.kpk : kpk // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LoginRequest].
extension LoginRequestPatterns on LoginRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginRequest value)  $default,){
final _that = this;
switch (_that) {
case _LoginRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginRequest value)?  $default,){
final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kpk,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.kpk,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kpk,  String password)  $default,) {final _that = this;
switch (_that) {
case _LoginRequest():
return $default(_that.kpk,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kpk,  String password)?  $default,) {final _that = this;
switch (_that) {
case _LoginRequest() when $default != null:
return $default(_that.kpk,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginRequest implements LoginRequest {
  const _LoginRequest({required this.kpk, required this.password});
  factory _LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

@override final  String kpk;
@override final  String password;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginRequestCopyWith<_LoginRequest> get copyWith => __$LoginRequestCopyWithImpl<_LoginRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginRequest&&(identical(other.kpk, kpk) || other.kpk == kpk)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kpk,password);
}

@override
String toString() {
    return 'LoginRequest(kpk: $kpk, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LoginRequestCopyWith<$Res> implements $LoginRequestCopyWith<$Res> {
  factory _$LoginRequestCopyWith(_LoginRequest value, $Res Function(_LoginRequest) _then) = __$LoginRequestCopyWithImpl;
@override @useResult
$Res call({
 String kpk, String password
});




}
/// @nodoc
class __$LoginRequestCopyWithImpl<$Res>
    implements _$LoginRequestCopyWith<$Res> {
  __$LoginRequestCopyWithImpl(this._self, this._then);

  final _LoginRequest _self;
  final $Res Function(_LoginRequest) _then;

/// Create a copy of LoginRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kpk = null,Object? password = null,}) {
  return _then(_LoginRequest(
kpk: null == kpk ? _self.kpk : kpk // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SessionGrantDto {

 String get accessToken; DateTime? get expiresAt; UserProfile get technician;
/// Create a copy of SessionGrantDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionGrantDtoCopyWith<SessionGrantDto> get copyWith => _$SessionGrantDtoCopyWithImpl<SessionGrantDto>(this as SessionGrantDto, _$identity);

  /// Serializes this SessionGrantDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SessionGrantDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionGrantDto&&(identical(other.accessToken, _this.accessToken) || other.accessToken == _this.accessToken)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.technician, _this.technician) || other.technician == _this.technician));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SessionGrantDto;
  return Object.hash(runtimeType,_this.accessToken,_this.expiresAt,_this.technician);
}

@override
String toString() {
  final _this = this as SessionGrantDto;
  return 'SessionGrantDto(accessToken: ${_this.accessToken}, expiresAt: ${_this.expiresAt}, technician: ${_this.technician})';
}


}

/// @nodoc
abstract mixin class $SessionGrantDtoCopyWith<$Res>  {
  factory $SessionGrantDtoCopyWith(SessionGrantDto value, $Res Function(SessionGrantDto) _then) = _$SessionGrantDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, DateTime? expiresAt, UserProfile technician
});


$UserProfileCopyWith<$Res> get technician;

}
/// @nodoc
class _$SessionGrantDtoCopyWithImpl<$Res>
    implements $SessionGrantDtoCopyWith<$Res> {
  _$SessionGrantDtoCopyWithImpl(this._self, this._then);

  final SessionGrantDto _self;
  final $Res Function(SessionGrantDto) _then;

/// Create a copy of SessionGrantDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? expiresAt = freezed,Object? technician = null,}) {
  return _then(SessionGrantDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,technician: null == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as UserProfile,
  ));
}
/// Create a copy of SessionGrantDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get technician {
  
  return $UserProfileCopyWith<$Res>(_self.technician, (value) {
    return _then(_self.copyWith(technician: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionGrantDto].
extension SessionGrantDtoPatterns on SessionGrantDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionGrantDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionGrantDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionGrantDto value)  $default,){
final _that = this;
switch (_that) {
case _SessionGrantDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionGrantDto value)?  $default,){
final _that = this;
switch (_that) {
case _SessionGrantDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  DateTime? expiresAt,  UserProfile technician)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionGrantDto() when $default != null:
return $default(_that.accessToken,_that.expiresAt,_that.technician);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  DateTime? expiresAt,  UserProfile technician)  $default,) {final _that = this;
switch (_that) {
case _SessionGrantDto():
return $default(_that.accessToken,_that.expiresAt,_that.technician);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  DateTime? expiresAt,  UserProfile technician)?  $default,) {final _that = this;
switch (_that) {
case _SessionGrantDto() when $default != null:
return $default(_that.accessToken,_that.expiresAt,_that.technician);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionGrantDto extends SessionGrantDto {
  const _SessionGrantDto({required this.accessToken, this.expiresAt, required this.technician}): super._();
  factory _SessionGrantDto.fromJson(Map<String, dynamic> json) => _$SessionGrantDtoFromJson(json);

@override final  String accessToken;
@override final  DateTime? expiresAt;
@override final  UserProfile technician;

/// Create a copy of SessionGrantDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionGrantDtoCopyWith<_SessionGrantDto> get copyWith => __$SessionGrantDtoCopyWithImpl<_SessionGrantDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionGrantDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionGrantDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.technician, technician) || other.technician == technician));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accessToken,expiresAt,technician);
}

@override
String toString() {
    return 'SessionGrantDto(accessToken: $accessToken, expiresAt: $expiresAt, technician: $technician)';
}


}

/// @nodoc
abstract mixin class _$SessionGrantDtoCopyWith<$Res> implements $SessionGrantDtoCopyWith<$Res> {
  factory _$SessionGrantDtoCopyWith(_SessionGrantDto value, $Res Function(_SessionGrantDto) _then) = __$SessionGrantDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, DateTime? expiresAt, UserProfile technician
});


@override $UserProfileCopyWith<$Res> get technician;

}
/// @nodoc
class __$SessionGrantDtoCopyWithImpl<$Res>
    implements _$SessionGrantDtoCopyWith<$Res> {
  __$SessionGrantDtoCopyWithImpl(this._self, this._then);

  final _SessionGrantDto _self;
  final $Res Function(_SessionGrantDto) _then;

/// Create a copy of SessionGrantDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? expiresAt = freezed,Object? technician = null,}) {
  return _then(_SessionGrantDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,technician: null == technician ? _self.technician : technician // ignore: cast_nullable_to_non_nullable
as UserProfile,
  ));
}

/// Create a copy of SessionGrantDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserProfileCopyWith<$Res> get technician {
  
  return $UserProfileCopyWith<$Res>(_self.technician, (value) {
    return _then(_self.copyWith(technician: value));
  });
}
}


/// @nodoc
mixin _$ProfileDto {

 int get kpk; String get name; String? get shift; bool get isActive; DateTime? get memberSince; String? get phoneNumberMasked;
/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileDtoCopyWith<ProfileDto> get copyWith => _$ProfileDtoCopyWithImpl<ProfileDto>(this as ProfileDto, _$identity);

  /// Serializes this ProfileDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProfileDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileDto&&(identical(other.kpk, _this.kpk) || other.kpk == _this.kpk)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.memberSince, _this.memberSince) || other.memberSince == _this.memberSince)&&(identical(other.phoneNumberMasked, _this.phoneNumberMasked) || other.phoneNumberMasked == _this.phoneNumberMasked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProfileDto;
  return Object.hash(runtimeType,_this.kpk,_this.name,_this.shift,_this.isActive,_this.memberSince,_this.phoneNumberMasked);
}

@override
String toString() {
  final _this = this as ProfileDto;
  return 'ProfileDto(kpk: ${_this.kpk}, name: ${_this.name}, shift: ${_this.shift}, isActive: ${_this.isActive}, memberSince: ${_this.memberSince}, phoneNumberMasked: ${_this.phoneNumberMasked})';
}


}

/// @nodoc
abstract mixin class $ProfileDtoCopyWith<$Res>  {
  factory $ProfileDtoCopyWith(ProfileDto value, $Res Function(ProfileDto) _then) = _$ProfileDtoCopyWithImpl;
@useResult
$Res call({
 int kpk, String name, String? shift, bool isActive, DateTime? memberSince, String? phoneNumberMasked
});




}
/// @nodoc
class _$ProfileDtoCopyWithImpl<$Res>
    implements $ProfileDtoCopyWith<$Res> {
  _$ProfileDtoCopyWithImpl(this._self, this._then);

  final ProfileDto _self;
  final $Res Function(ProfileDto) _then;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kpk = null,Object? name = null,Object? shift = freezed,Object? isActive = null,Object? memberSince = freezed,Object? phoneNumberMasked = freezed,}) {
  return _then(ProfileDto(
kpk: null == kpk ? _self.kpk : kpk // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,memberSince: freezed == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumberMasked: freezed == phoneNumberMasked ? _self.phoneNumberMasked : phoneNumberMasked // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileDto].
extension ProfileDtoPatterns on ProfileDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileDto value)  $default,){
final _that = this;
switch (_that) {
case _ProfileDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int kpk,  String name,  String? shift,  bool isActive,  DateTime? memberSince,  String? phoneNumberMasked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
return $default(_that.kpk,_that.name,_that.shift,_that.isActive,_that.memberSince,_that.phoneNumberMasked);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int kpk,  String name,  String? shift,  bool isActive,  DateTime? memberSince,  String? phoneNumberMasked)  $default,) {final _that = this;
switch (_that) {
case _ProfileDto():
return $default(_that.kpk,_that.name,_that.shift,_that.isActive,_that.memberSince,_that.phoneNumberMasked);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int kpk,  String name,  String? shift,  bool isActive,  DateTime? memberSince,  String? phoneNumberMasked)?  $default,) {final _that = this;
switch (_that) {
case _ProfileDto() when $default != null:
return $default(_that.kpk,_that.name,_that.shift,_that.isActive,_that.memberSince,_that.phoneNumberMasked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileDto implements ProfileDto {
  const _ProfileDto({required this.kpk, required this.name, this.shift, this.isActive = true, this.memberSince, this.phoneNumberMasked});
  factory _ProfileDto.fromJson(Map<String, dynamic> json) => _$ProfileDtoFromJson(json);

@override final  int kpk;
@override final  String name;
@override final  String? shift;
@override@JsonKey() final  bool isActive;
@override final  DateTime? memberSince;
@override final  String? phoneNumberMasked;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileDtoCopyWith<_ProfileDto> get copyWith => __$ProfileDtoCopyWithImpl<_ProfileDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileDto&&(identical(other.kpk, kpk) || other.kpk == kpk)&&(identical(other.name, name) || other.name == name)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.memberSince, memberSince) || other.memberSince == memberSince)&&(identical(other.phoneNumberMasked, phoneNumberMasked) || other.phoneNumberMasked == phoneNumberMasked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,kpk,name,shift,isActive,memberSince,phoneNumberMasked);
}

@override
String toString() {
    return 'ProfileDto(kpk: $kpk, name: $name, shift: $shift, isActive: $isActive, memberSince: $memberSince, phoneNumberMasked: $phoneNumberMasked)';
}


}

/// @nodoc
abstract mixin class _$ProfileDtoCopyWith<$Res> implements $ProfileDtoCopyWith<$Res> {
  factory _$ProfileDtoCopyWith(_ProfileDto value, $Res Function(_ProfileDto) _then) = __$ProfileDtoCopyWithImpl;
@override @useResult
$Res call({
 int kpk, String name, String? shift, bool isActive, DateTime? memberSince, String? phoneNumberMasked
});




}
/// @nodoc
class __$ProfileDtoCopyWithImpl<$Res>
    implements _$ProfileDtoCopyWith<$Res> {
  __$ProfileDtoCopyWithImpl(this._self, this._then);

  final _ProfileDto _self;
  final $Res Function(_ProfileDto) _then;

/// Create a copy of ProfileDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kpk = null,Object? name = null,Object? shift = freezed,Object? isActive = null,Object? memberSince = freezed,Object? phoneNumberMasked = freezed,}) {
  return _then(_ProfileDto(
kpk: null == kpk ? _self.kpk : kpk // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,memberSince: freezed == memberSince ? _self.memberSince : memberSince // ignore: cast_nullable_to_non_nullable
as DateTime?,phoneNumberMasked: freezed == phoneNumberMasked ? _self.phoneNumberMasked : phoneNumberMasked // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DeviceDto {

 String? get id; String? get name; String? get location;
/// Create a copy of DeviceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<DeviceDto> get copyWith => _$DeviceDtoCopyWithImpl<DeviceDto>(this as DeviceDto, _$identity);

  /// Serializes this DeviceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.location, _this.location) || other.location == _this.location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceDto;
  return Object.hash(runtimeType,_this.id,_this.name,_this.location);
}

@override
String toString() {
  final _this = this as DeviceDto;
  return 'DeviceDto(id: ${_this.id}, name: ${_this.name}, location: ${_this.location})';
}


}

/// @nodoc
abstract mixin class $DeviceDtoCopyWith<$Res>  {
  factory $DeviceDtoCopyWith(DeviceDto value, $Res Function(DeviceDto) _then) = _$DeviceDtoCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? location
});




}
/// @nodoc
class _$DeviceDtoCopyWithImpl<$Res>
    implements $DeviceDtoCopyWith<$Res> {
  _$DeviceDtoCopyWithImpl(this._self, this._then);

  final DeviceDto _self;
  final $Res Function(DeviceDto) _then;

/// Create a copy of DeviceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? location = freezed,}) {
  return _then(DeviceDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DeviceDto].
extension DeviceDtoPatterns on DeviceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceDto value)  $default,){
final _that = this;
switch (_that) {
case _DeviceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceDto value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceDto() when $default != null:
return $default(_that.id,_that.name,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? location)  $default,) {final _that = this;
switch (_that) {
case _DeviceDto():
return $default(_that.id,_that.name,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? location)?  $default,) {final _that = this;
switch (_that) {
case _DeviceDto() when $default != null:
return $default(_that.id,_that.name,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceDto implements DeviceDto {
  const _DeviceDto({this.id, this.name, this.location});
  factory _DeviceDto.fromJson(Map<String, dynamic> json) => _$DeviceDtoFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? location;

/// Create a copy of DeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceDtoCopyWith<_DeviceDto> get copyWith => __$DeviceDtoCopyWithImpl<_DeviceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,location);
}

@override
String toString() {
    return 'DeviceDto(id: $id, name: $name, location: $location)';
}


}

/// @nodoc
abstract mixin class _$DeviceDtoCopyWith<$Res> implements $DeviceDtoCopyWith<$Res> {
  factory _$DeviceDtoCopyWith(_DeviceDto value, $Res Function(_DeviceDto) _then) = __$DeviceDtoCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? location
});




}
/// @nodoc
class __$DeviceDtoCopyWithImpl<$Res>
    implements _$DeviceDtoCopyWith<$Res> {
  __$DeviceDtoCopyWithImpl(this._self, this._then);

  final _DeviceDto _self;
  final $Res Function(_DeviceDto) _then;

/// Create a copy of DeviceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? location = freezed,}) {
  return _then(_DeviceDto(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PairingPreviewDto {

 DeviceDto get device; DateTime? get expiresAt;
/// Create a copy of PairingPreviewDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingPreviewDtoCopyWith<PairingPreviewDto> get copyWith => _$PairingPreviewDtoCopyWithImpl<PairingPreviewDto>(this as PairingPreviewDto, _$identity);

  /// Serializes this PairingPreviewDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PairingPreviewDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingPreviewDto&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PairingPreviewDto;
  return Object.hash(runtimeType,_this.device,_this.expiresAt);
}

@override
String toString() {
  final _this = this as PairingPreviewDto;
  return 'PairingPreviewDto(device: ${_this.device}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $PairingPreviewDtoCopyWith<$Res>  {
  factory $PairingPreviewDtoCopyWith(PairingPreviewDto value, $Res Function(PairingPreviewDto) _then) = _$PairingPreviewDtoCopyWithImpl;
@useResult
$Res call({
 DeviceDto device, DateTime? expiresAt
});


$DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class _$PairingPreviewDtoCopyWithImpl<$Res>
    implements $PairingPreviewDtoCopyWith<$Res> {
  _$PairingPreviewDtoCopyWithImpl(this._self, this._then);

  final PairingPreviewDto _self;
  final $Res Function(PairingPreviewDto) _then;

/// Create a copy of PairingPreviewDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? expiresAt = freezed,}) {
  return _then(PairingPreviewDto(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PairingPreviewDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [PairingPreviewDto].
extension PairingPreviewDtoPatterns on PairingPreviewDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairingPreviewDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairingPreviewDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairingPreviewDto value)  $default,){
final _that = this;
switch (_that) {
case _PairingPreviewDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairingPreviewDto value)?  $default,){
final _that = this;
switch (_that) {
case _PairingPreviewDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceDto device,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairingPreviewDto() when $default != null:
return $default(_that.device,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceDto device,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _PairingPreviewDto():
return $default(_that.device,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceDto device,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _PairingPreviewDto() when $default != null:
return $default(_that.device,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PairingPreviewDto implements PairingPreviewDto {
  const _PairingPreviewDto({required this.device, this.expiresAt});
  factory _PairingPreviewDto.fromJson(Map<String, dynamic> json) => _$PairingPreviewDtoFromJson(json);

@override final  DeviceDto device;
@override final  DateTime? expiresAt;

/// Create a copy of PairingPreviewDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairingPreviewDtoCopyWith<_PairingPreviewDto> get copyWith => __$PairingPreviewDtoCopyWithImpl<_PairingPreviewDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PairingPreviewDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairingPreviewDto&&(identical(other.device, device) || other.device == device)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,device,expiresAt);
}

@override
String toString() {
    return 'PairingPreviewDto(device: $device, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$PairingPreviewDtoCopyWith<$Res> implements $PairingPreviewDtoCopyWith<$Res> {
  factory _$PairingPreviewDtoCopyWith(_PairingPreviewDto value, $Res Function(_PairingPreviewDto) _then) = __$PairingPreviewDtoCopyWithImpl;
@override @useResult
$Res call({
 DeviceDto device, DateTime? expiresAt
});


@override $DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class __$PairingPreviewDtoCopyWithImpl<$Res>
    implements _$PairingPreviewDtoCopyWith<$Res> {
  __$PairingPreviewDtoCopyWithImpl(this._self, this._then);

  final _PairingPreviewDto _self;
  final $Res Function(_PairingPreviewDto) _then;

/// Create a copy of PairingPreviewDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? expiresAt = freezed,}) {
  return _then(_PairingPreviewDto(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PairingPreviewDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// @nodoc
mixin _$ApprovePairingRequest {

 String get code;
/// Create a copy of ApprovePairingRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovePairingRequestCopyWith<ApprovePairingRequest> get copyWith => _$ApprovePairingRequestCopyWithImpl<ApprovePairingRequest>(this as ApprovePairingRequest, _$identity);

  /// Serializes this ApprovePairingRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ApprovePairingRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovePairingRequest&&(identical(other.code, _this.code) || other.code == _this.code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ApprovePairingRequest;
  return Object.hash(runtimeType,_this.code);
}

@override
String toString() {
  final _this = this as ApprovePairingRequest;
  return 'ApprovePairingRequest(code: ${_this.code})';
}


}

/// @nodoc
abstract mixin class $ApprovePairingRequestCopyWith<$Res>  {
  factory $ApprovePairingRequestCopyWith(ApprovePairingRequest value, $Res Function(ApprovePairingRequest) _then) = _$ApprovePairingRequestCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$ApprovePairingRequestCopyWithImpl<$Res>
    implements $ApprovePairingRequestCopyWith<$Res> {
  _$ApprovePairingRequestCopyWithImpl(this._self, this._then);

  final ApprovePairingRequest _self;
  final $Res Function(ApprovePairingRequest) _then;

/// Create a copy of ApprovePairingRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,}) {
  return _then(ApprovePairingRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovePairingRequest].
extension ApprovePairingRequestPatterns on ApprovePairingRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovePairingRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovePairingRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovePairingRequest value)  $default,){
final _that = this;
switch (_that) {
case _ApprovePairingRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovePairingRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovePairingRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovePairingRequest() when $default != null:
return $default(_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code)  $default,) {final _that = this;
switch (_that) {
case _ApprovePairingRequest():
return $default(_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code)?  $default,) {final _that = this;
switch (_that) {
case _ApprovePairingRequest() when $default != null:
return $default(_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApprovePairingRequest implements ApprovePairingRequest {
  const _ApprovePairingRequest({required this.code});
  factory _ApprovePairingRequest.fromJson(Map<String, dynamic> json) => _$ApprovePairingRequestFromJson(json);

@override final  String code;

/// Create a copy of ApprovePairingRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovePairingRequestCopyWith<_ApprovePairingRequest> get copyWith => __$ApprovePairingRequestCopyWithImpl<_ApprovePairingRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovePairingRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovePairingRequest&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code);
}

@override
String toString() {
    return 'ApprovePairingRequest(code: $code)';
}


}

/// @nodoc
abstract mixin class _$ApprovePairingRequestCopyWith<$Res> implements $ApprovePairingRequestCopyWith<$Res> {
  factory _$ApprovePairingRequestCopyWith(_ApprovePairingRequest value, $Res Function(_ApprovePairingRequest) _then) = __$ApprovePairingRequestCopyWithImpl;
@override @useResult
$Res call({
 String code
});




}
/// @nodoc
class __$ApprovePairingRequestCopyWithImpl<$Res>
    implements _$ApprovePairingRequestCopyWith<$Res> {
  __$ApprovePairingRequestCopyWithImpl(this._self, this._then);

  final _ApprovePairingRequest _self;
  final $Res Function(_ApprovePairingRequest) _then;

/// Create a copy of ApprovePairingRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(_ApprovePairingRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DeviceEnvelopeDto {

 DeviceDto get device;
/// Create a copy of DeviceEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeviceEnvelopeDtoCopyWith<DeviceEnvelopeDto> get copyWith => _$DeviceEnvelopeDtoCopyWithImpl<DeviceEnvelopeDto>(this as DeviceEnvelopeDto, _$identity);

  /// Serializes this DeviceEnvelopeDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DeviceEnvelopeDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeviceEnvelopeDto&&(identical(other.device, _this.device) || other.device == _this.device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DeviceEnvelopeDto;
  return Object.hash(runtimeType,_this.device);
}

@override
String toString() {
  final _this = this as DeviceEnvelopeDto;
  return 'DeviceEnvelopeDto(device: ${_this.device})';
}


}

/// @nodoc
abstract mixin class $DeviceEnvelopeDtoCopyWith<$Res>  {
  factory $DeviceEnvelopeDtoCopyWith(DeviceEnvelopeDto value, $Res Function(DeviceEnvelopeDto) _then) = _$DeviceEnvelopeDtoCopyWithImpl;
@useResult
$Res call({
 DeviceDto device
});


$DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class _$DeviceEnvelopeDtoCopyWithImpl<$Res>
    implements $DeviceEnvelopeDtoCopyWith<$Res> {
  _$DeviceEnvelopeDtoCopyWithImpl(this._self, this._then);

  final DeviceEnvelopeDto _self;
  final $Res Function(DeviceEnvelopeDto) _then;

/// Create a copy of DeviceEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,}) {
  return _then(DeviceEnvelopeDto(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,
  ));
}
/// Create a copy of DeviceEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [DeviceEnvelopeDto].
extension DeviceEnvelopeDtoPatterns on DeviceEnvelopeDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DeviceEnvelopeDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DeviceEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DeviceEnvelopeDto value)  $default,){
final _that = this;
switch (_that) {
case _DeviceEnvelopeDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DeviceEnvelopeDto value)?  $default,){
final _that = this;
switch (_that) {
case _DeviceEnvelopeDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceDto device)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DeviceEnvelopeDto() when $default != null:
return $default(_that.device);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceDto device)  $default,) {final _that = this;
switch (_that) {
case _DeviceEnvelopeDto():
return $default(_that.device);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceDto device)?  $default,) {final _that = this;
switch (_that) {
case _DeviceEnvelopeDto() when $default != null:
return $default(_that.device);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DeviceEnvelopeDto implements DeviceEnvelopeDto {
  const _DeviceEnvelopeDto({required this.device});
  factory _DeviceEnvelopeDto.fromJson(Map<String, dynamic> json) => _$DeviceEnvelopeDtoFromJson(json);

@override final  DeviceDto device;

/// Create a copy of DeviceEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DeviceEnvelopeDtoCopyWith<_DeviceEnvelopeDto> get copyWith => __$DeviceEnvelopeDtoCopyWithImpl<_DeviceEnvelopeDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DeviceEnvelopeDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DeviceEnvelopeDto&&(identical(other.device, device) || other.device == device));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,device);
}

@override
String toString() {
    return 'DeviceEnvelopeDto(device: $device)';
}


}

/// @nodoc
abstract mixin class _$DeviceEnvelopeDtoCopyWith<$Res> implements $DeviceEnvelopeDtoCopyWith<$Res> {
  factory _$DeviceEnvelopeDtoCopyWith(_DeviceEnvelopeDto value, $Res Function(_DeviceEnvelopeDto) _then) = __$DeviceEnvelopeDtoCopyWithImpl;
@override @useResult
$Res call({
 DeviceDto device
});


@override $DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class __$DeviceEnvelopeDtoCopyWithImpl<$Res>
    implements _$DeviceEnvelopeDtoCopyWith<$Res> {
  __$DeviceEnvelopeDtoCopyWithImpl(this._self, this._then);

  final _DeviceEnvelopeDto _self;
  final $Res Function(_DeviceEnvelopeDto) _then;

/// Create a copy of DeviceEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(_DeviceEnvelopeDto(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,
  ));
}

/// Create a copy of DeviceEnvelopeDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// @nodoc
mixin _$PairedWatchDto {

 String get sessionId; DeviceDto get device; DateTime? get pairedAt; DateTime? get expiresAt;
/// Create a copy of PairedWatchDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairedWatchDtoCopyWith<PairedWatchDto> get copyWith => _$PairedWatchDtoCopyWithImpl<PairedWatchDto>(this as PairedWatchDto, _$identity);

  /// Serializes this PairedWatchDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PairedWatchDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairedWatchDto&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.pairedAt, _this.pairedAt) || other.pairedAt == _this.pairedAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PairedWatchDto;
  return Object.hash(runtimeType,_this.sessionId,_this.device,_this.pairedAt,_this.expiresAt);
}

@override
String toString() {
  final _this = this as PairedWatchDto;
  return 'PairedWatchDto(sessionId: ${_this.sessionId}, device: ${_this.device}, pairedAt: ${_this.pairedAt}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $PairedWatchDtoCopyWith<$Res>  {
  factory $PairedWatchDtoCopyWith(PairedWatchDto value, $Res Function(PairedWatchDto) _then) = _$PairedWatchDtoCopyWithImpl;
@useResult
$Res call({
 String sessionId, DeviceDto device, DateTime? pairedAt, DateTime? expiresAt
});


$DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class _$PairedWatchDtoCopyWithImpl<$Res>
    implements $PairedWatchDtoCopyWith<$Res> {
  _$PairedWatchDtoCopyWithImpl(this._self, this._then);

  final PairedWatchDto _self;
  final $Res Function(PairedWatchDto) _then;

/// Create a copy of PairedWatchDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? device = null,Object? pairedAt = freezed,Object? expiresAt = freezed,}) {
  return _then(PairedWatchDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,pairedAt: freezed == pairedAt ? _self.pairedAt : pairedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of PairedWatchDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [PairedWatchDto].
extension PairedWatchDtoPatterns on PairedWatchDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairedWatchDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairedWatchDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairedWatchDto value)  $default,){
final _that = this;
switch (_that) {
case _PairedWatchDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairedWatchDto value)?  $default,){
final _that = this;
switch (_that) {
case _PairedWatchDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  DeviceDto device,  DateTime? pairedAt,  DateTime? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairedWatchDto() when $default != null:
return $default(_that.sessionId,_that.device,_that.pairedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  DeviceDto device,  DateTime? pairedAt,  DateTime? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _PairedWatchDto():
return $default(_that.sessionId,_that.device,_that.pairedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  DeviceDto device,  DateTime? pairedAt,  DateTime? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _PairedWatchDto() when $default != null:
return $default(_that.sessionId,_that.device,_that.pairedAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PairedWatchDto implements PairedWatchDto {
  const _PairedWatchDto({required this.sessionId, this.device = const DeviceDto(), this.pairedAt, this.expiresAt});
  factory _PairedWatchDto.fromJson(Map<String, dynamic> json) => _$PairedWatchDtoFromJson(json);

@override final  String sessionId;
@override@JsonKey() final  DeviceDto device;
@override final  DateTime? pairedAt;
@override final  DateTime? expiresAt;

/// Create a copy of PairedWatchDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairedWatchDtoCopyWith<_PairedWatchDto> get copyWith => __$PairedWatchDtoCopyWithImpl<_PairedWatchDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PairedWatchDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairedWatchDto&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.device, device) || other.device == device)&&(identical(other.pairedAt, pairedAt) || other.pairedAt == pairedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,sessionId,device,pairedAt,expiresAt);
}

@override
String toString() {
    return 'PairedWatchDto(sessionId: $sessionId, device: $device, pairedAt: $pairedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$PairedWatchDtoCopyWith<$Res> implements $PairedWatchDtoCopyWith<$Res> {
  factory _$PairedWatchDtoCopyWith(_PairedWatchDto value, $Res Function(_PairedWatchDto) _then) = __$PairedWatchDtoCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, DeviceDto device, DateTime? pairedAt, DateTime? expiresAt
});


@override $DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class __$PairedWatchDtoCopyWithImpl<$Res>
    implements _$PairedWatchDtoCopyWith<$Res> {
  __$PairedWatchDtoCopyWithImpl(this._self, this._then);

  final _PairedWatchDto _self;
  final $Res Function(_PairedWatchDto) _then;

/// Create a copy of PairedWatchDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? device = null,Object? pairedAt = freezed,Object? expiresAt = freezed,}) {
  return _then(_PairedWatchDto(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,pairedAt: freezed == pairedAt ? _self.pairedAt : pairedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of PairedWatchDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// @nodoc
mixin _$UnpairDto {

 bool get checkedOut;
/// Create a copy of UnpairDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnpairDtoCopyWith<UnpairDto> get copyWith => _$UnpairDtoCopyWithImpl<UnpairDto>(this as UnpairDto, _$identity);

  /// Serializes this UnpairDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UnpairDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnpairDto&&(identical(other.checkedOut, _this.checkedOut) || other.checkedOut == _this.checkedOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UnpairDto;
  return Object.hash(runtimeType,_this.checkedOut);
}

@override
String toString() {
  final _this = this as UnpairDto;
  return 'UnpairDto(checkedOut: ${_this.checkedOut})';
}


}

/// @nodoc
abstract mixin class $UnpairDtoCopyWith<$Res>  {
  factory $UnpairDtoCopyWith(UnpairDto value, $Res Function(UnpairDto) _then) = _$UnpairDtoCopyWithImpl;
@useResult
$Res call({
 bool checkedOut
});




}
/// @nodoc
class _$UnpairDtoCopyWithImpl<$Res>
    implements $UnpairDtoCopyWith<$Res> {
  _$UnpairDtoCopyWithImpl(this._self, this._then);

  final UnpairDto _self;
  final $Res Function(UnpairDto) _then;

/// Create a copy of UnpairDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkedOut = null,}) {
  return _then(UnpairDto(
checkedOut: null == checkedOut ? _self.checkedOut : checkedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UnpairDto].
extension UnpairDtoPatterns on UnpairDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnpairDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnpairDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnpairDto value)  $default,){
final _that = this;
switch (_that) {
case _UnpairDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnpairDto value)?  $default,){
final _that = this;
switch (_that) {
case _UnpairDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool checkedOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnpairDto() when $default != null:
return $default(_that.checkedOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool checkedOut)  $default,) {final _that = this;
switch (_that) {
case _UnpairDto():
return $default(_that.checkedOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool checkedOut)?  $default,) {final _that = this;
switch (_that) {
case _UnpairDto() when $default != null:
return $default(_that.checkedOut);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnpairDto implements UnpairDto {
  const _UnpairDto({this.checkedOut = false});
  factory _UnpairDto.fromJson(Map<String, dynamic> json) => _$UnpairDtoFromJson(json);

@override@JsonKey() final  bool checkedOut;

/// Create a copy of UnpairDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnpairDtoCopyWith<_UnpairDto> get copyWith => __$UnpairDtoCopyWithImpl<_UnpairDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnpairDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnpairDto&&(identical(other.checkedOut, checkedOut) || other.checkedOut == checkedOut));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,checkedOut);
}

@override
String toString() {
    return 'UnpairDto(checkedOut: $checkedOut)';
}


}

/// @nodoc
abstract mixin class _$UnpairDtoCopyWith<$Res> implements $UnpairDtoCopyWith<$Res> {
  factory _$UnpairDtoCopyWith(_UnpairDto value, $Res Function(_UnpairDto) _then) = __$UnpairDtoCopyWithImpl;
@override @useResult
$Res call({
 bool checkedOut
});




}
/// @nodoc
class __$UnpairDtoCopyWithImpl<$Res>
    implements _$UnpairDtoCopyWith<$Res> {
  __$UnpairDtoCopyWithImpl(this._self, this._then);

  final _UnpairDto _self;
  final $Res Function(_UnpairDto) _then;

/// Create a copy of UnpairDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkedOut = null,}) {
  return _then(_UnpairDto(
checkedOut: null == checkedOut ? _self.checkedOut : checkedOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EnrollRequest {

 String get code; String get publicKey; String get signature;
/// Create a copy of EnrollRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrollRequestCopyWith<EnrollRequest> get copyWith => _$EnrollRequestCopyWithImpl<EnrollRequest>(this as EnrollRequest, _$identity);

  /// Serializes this EnrollRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnrollRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrollRequest&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.publicKey, _this.publicKey) || other.publicKey == _this.publicKey)&&(identical(other.signature, _this.signature) || other.signature == _this.signature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnrollRequest;
  return Object.hash(runtimeType,_this.code,_this.publicKey,_this.signature);
}

@override
String toString() {
  final _this = this as EnrollRequest;
  return 'EnrollRequest(code: ${_this.code}, publicKey: ${_this.publicKey}, signature: ${_this.signature})';
}


}

/// @nodoc
abstract mixin class $EnrollRequestCopyWith<$Res>  {
  factory $EnrollRequestCopyWith(EnrollRequest value, $Res Function(EnrollRequest) _then) = _$EnrollRequestCopyWithImpl;
@useResult
$Res call({
 String code, String publicKey, String signature
});




}
/// @nodoc
class _$EnrollRequestCopyWithImpl<$Res>
    implements $EnrollRequestCopyWith<$Res> {
  _$EnrollRequestCopyWithImpl(this._self, this._then);

  final EnrollRequest _self;
  final $Res Function(EnrollRequest) _then;

/// Create a copy of EnrollRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? publicKey = null,Object? signature = null,}) {
  return _then(EnrollRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,signature: null == signature ? _self.signature : signature // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EnrollRequest].
extension EnrollRequestPatterns on EnrollRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrollRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrollRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrollRequest value)  $default,){
final _that = this;
switch (_that) {
case _EnrollRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrollRequest value)?  $default,){
final _that = this;
switch (_that) {
case _EnrollRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  String publicKey,  String signature)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrollRequest() when $default != null:
return $default(_that.code,_that.publicKey,_that.signature);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  String publicKey,  String signature)  $default,) {final _that = this;
switch (_that) {
case _EnrollRequest():
return $default(_that.code,_that.publicKey,_that.signature);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  String publicKey,  String signature)?  $default,) {final _that = this;
switch (_that) {
case _EnrollRequest() when $default != null:
return $default(_that.code,_that.publicKey,_that.signature);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnrollRequest implements EnrollRequest {
  const _EnrollRequest({required this.code, required this.publicKey, required this.signature});
  factory _EnrollRequest.fromJson(Map<String, dynamic> json) => _$EnrollRequestFromJson(json);

@override final  String code;
@override final  String publicKey;
@override final  String signature;

/// Create a copy of EnrollRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrollRequestCopyWith<_EnrollRequest> get copyWith => __$EnrollRequestCopyWithImpl<_EnrollRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnrollRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrollRequest&&(identical(other.code, code) || other.code == code)&&(identical(other.publicKey, publicKey) || other.publicKey == publicKey)&&(identical(other.signature, signature) || other.signature == signature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,code,publicKey,signature);
}

@override
String toString() {
    return 'EnrollRequest(code: $code, publicKey: $publicKey, signature: $signature)';
}


}

/// @nodoc
abstract mixin class _$EnrollRequestCopyWith<$Res> implements $EnrollRequestCopyWith<$Res> {
  factory _$EnrollRequestCopyWith(_EnrollRequest value, $Res Function(_EnrollRequest) _then) = __$EnrollRequestCopyWithImpl;
@override @useResult
$Res call({
 String code, String publicKey, String signature
});




}
/// @nodoc
class __$EnrollRequestCopyWithImpl<$Res>
    implements _$EnrollRequestCopyWith<$Res> {
  __$EnrollRequestCopyWithImpl(this._self, this._then);

  final _EnrollRequest _self;
  final $Res Function(_EnrollRequest) _then;

/// Create a copy of EnrollRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? publicKey = null,Object? signature = null,}) {
  return _then(_EnrollRequest(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,publicKey: null == publicKey ? _self.publicKey : publicKey // ignore: cast_nullable_to_non_nullable
as String,signature: null == signature ? _self.signature : signature // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$EnrollResponseDto {

 DeviceDto get device; String? get publicKeyFingerprint;
/// Create a copy of EnrollResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnrollResponseDtoCopyWith<EnrollResponseDto> get copyWith => _$EnrollResponseDtoCopyWithImpl<EnrollResponseDto>(this as EnrollResponseDto, _$identity);

  /// Serializes this EnrollResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnrollResponseDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnrollResponseDto&&(identical(other.device, _this.device) || other.device == _this.device)&&(identical(other.publicKeyFingerprint, _this.publicKeyFingerprint) || other.publicKeyFingerprint == _this.publicKeyFingerprint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnrollResponseDto;
  return Object.hash(runtimeType,_this.device,_this.publicKeyFingerprint);
}

@override
String toString() {
  final _this = this as EnrollResponseDto;
  return 'EnrollResponseDto(device: ${_this.device}, publicKeyFingerprint: ${_this.publicKeyFingerprint})';
}


}

/// @nodoc
abstract mixin class $EnrollResponseDtoCopyWith<$Res>  {
  factory $EnrollResponseDtoCopyWith(EnrollResponseDto value, $Res Function(EnrollResponseDto) _then) = _$EnrollResponseDtoCopyWithImpl;
@useResult
$Res call({
 DeviceDto device, String? publicKeyFingerprint
});


$DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class _$EnrollResponseDtoCopyWithImpl<$Res>
    implements $EnrollResponseDtoCopyWith<$Res> {
  _$EnrollResponseDtoCopyWithImpl(this._self, this._then);

  final EnrollResponseDto _self;
  final $Res Function(EnrollResponseDto) _then;

/// Create a copy of EnrollResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? device = null,Object? publicKeyFingerprint = freezed,}) {
  return _then(EnrollResponseDto(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,publicKeyFingerprint: freezed == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of EnrollResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [EnrollResponseDto].
extension EnrollResponseDtoPatterns on EnrollResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnrollResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnrollResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnrollResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _EnrollResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnrollResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _EnrollResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DeviceDto device,  String? publicKeyFingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnrollResponseDto() when $default != null:
return $default(_that.device,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DeviceDto device,  String? publicKeyFingerprint)  $default,) {final _that = this;
switch (_that) {
case _EnrollResponseDto():
return $default(_that.device,_that.publicKeyFingerprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DeviceDto device,  String? publicKeyFingerprint)?  $default,) {final _that = this;
switch (_that) {
case _EnrollResponseDto() when $default != null:
return $default(_that.device,_that.publicKeyFingerprint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnrollResponseDto implements EnrollResponseDto {
  const _EnrollResponseDto({required this.device, this.publicKeyFingerprint});
  factory _EnrollResponseDto.fromJson(Map<String, dynamic> json) => _$EnrollResponseDtoFromJson(json);

@override final  DeviceDto device;
@override final  String? publicKeyFingerprint;

/// Create a copy of EnrollResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnrollResponseDtoCopyWith<_EnrollResponseDto> get copyWith => __$EnrollResponseDtoCopyWithImpl<_EnrollResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnrollResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnrollResponseDto&&(identical(other.device, device) || other.device == device)&&(identical(other.publicKeyFingerprint, publicKeyFingerprint) || other.publicKeyFingerprint == publicKeyFingerprint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,device,publicKeyFingerprint);
}

@override
String toString() {
    return 'EnrollResponseDto(device: $device, publicKeyFingerprint: $publicKeyFingerprint)';
}


}

/// @nodoc
abstract mixin class _$EnrollResponseDtoCopyWith<$Res> implements $EnrollResponseDtoCopyWith<$Res> {
  factory _$EnrollResponseDtoCopyWith(_EnrollResponseDto value, $Res Function(_EnrollResponseDto) _then) = __$EnrollResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 DeviceDto device, String? publicKeyFingerprint
});


@override $DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class __$EnrollResponseDtoCopyWithImpl<$Res>
    implements _$EnrollResponseDtoCopyWith<$Res> {
  __$EnrollResponseDtoCopyWithImpl(this._self, this._then);

  final _EnrollResponseDto _self;
  final $Res Function(_EnrollResponseDto) _then;

/// Create a copy of EnrollResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? device = null,Object? publicKeyFingerprint = freezed,}) {
  return _then(_EnrollResponseDto(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,publicKeyFingerprint: freezed == publicKeyFingerprint ? _self.publicKeyFingerprint : publicKeyFingerprint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of EnrollResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res> get device {
  
  return $DeviceDtoCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// @nodoc
mixin _$PairingDto {

 String get pairingId; DateTime get expiresAt;/// Shown as the QR exactly as it is.
 String get qrPayload;
/// Create a copy of PairingDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingDtoCopyWith<PairingDto> get copyWith => _$PairingDtoCopyWithImpl<PairingDto>(this as PairingDto, _$identity);

  /// Serializes this PairingDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PairingDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingDto&&(identical(other.pairingId, _this.pairingId) || other.pairingId == _this.pairingId)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt)&&(identical(other.qrPayload, _this.qrPayload) || other.qrPayload == _this.qrPayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PairingDto;
  return Object.hash(runtimeType,_this.pairingId,_this.expiresAt,_this.qrPayload);
}

@override
String toString() {
  final _this = this as PairingDto;
  return 'PairingDto(pairingId: ${_this.pairingId}, expiresAt: ${_this.expiresAt}, qrPayload: ${_this.qrPayload})';
}


}

/// @nodoc
abstract mixin class $PairingDtoCopyWith<$Res>  {
  factory $PairingDtoCopyWith(PairingDto value, $Res Function(PairingDto) _then) = _$PairingDtoCopyWithImpl;
@useResult
$Res call({
 String pairingId, DateTime expiresAt, String qrPayload
});




}
/// @nodoc
class _$PairingDtoCopyWithImpl<$Res>
    implements $PairingDtoCopyWith<$Res> {
  _$PairingDtoCopyWithImpl(this._self, this._then);

  final PairingDto _self;
  final $Res Function(PairingDto) _then;

/// Create a copy of PairingDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pairingId = null,Object? expiresAt = null,Object? qrPayload = null,}) {
  return _then(PairingDto(
pairingId: null == pairingId ? _self.pairingId : pairingId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,qrPayload: null == qrPayload ? _self.qrPayload : qrPayload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PairingDto].
extension PairingDtoPatterns on PairingDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairingDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairingDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairingDto value)  $default,){
final _that = this;
switch (_that) {
case _PairingDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairingDto value)?  $default,){
final _that = this;
switch (_that) {
case _PairingDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String pairingId,  DateTime expiresAt,  String qrPayload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairingDto() when $default != null:
return $default(_that.pairingId,_that.expiresAt,_that.qrPayload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String pairingId,  DateTime expiresAt,  String qrPayload)  $default,) {final _that = this;
switch (_that) {
case _PairingDto():
return $default(_that.pairingId,_that.expiresAt,_that.qrPayload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String pairingId,  DateTime expiresAt,  String qrPayload)?  $default,) {final _that = this;
switch (_that) {
case _PairingDto() when $default != null:
return $default(_that.pairingId,_that.expiresAt,_that.qrPayload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PairingDto implements PairingDto {
  const _PairingDto({required this.pairingId, required this.expiresAt, required this.qrPayload});
  factory _PairingDto.fromJson(Map<String, dynamic> json) => _$PairingDtoFromJson(json);

@override final  String pairingId;
@override final  DateTime expiresAt;
/// Shown as the QR exactly as it is.
@override final  String qrPayload;

/// Create a copy of PairingDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairingDtoCopyWith<_PairingDto> get copyWith => __$PairingDtoCopyWithImpl<_PairingDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PairingDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairingDto&&(identical(other.pairingId, pairingId) || other.pairingId == pairingId)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.qrPayload, qrPayload) || other.qrPayload == qrPayload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pairingId,expiresAt,qrPayload);
}

@override
String toString() {
    return 'PairingDto(pairingId: $pairingId, expiresAt: $expiresAt, qrPayload: $qrPayload)';
}


}

/// @nodoc
abstract mixin class _$PairingDtoCopyWith<$Res> implements $PairingDtoCopyWith<$Res> {
  factory _$PairingDtoCopyWith(_PairingDto value, $Res Function(_PairingDto) _then) = __$PairingDtoCopyWithImpl;
@override @useResult
$Res call({
 String pairingId, DateTime expiresAt, String qrPayload
});




}
/// @nodoc
class __$PairingDtoCopyWithImpl<$Res>
    implements _$PairingDtoCopyWith<$Res> {
  __$PairingDtoCopyWithImpl(this._self, this._then);

  final _PairingDto _self;
  final $Res Function(_PairingDto) _then;

/// Create a copy of PairingDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pairingId = null,Object? expiresAt = null,Object? qrPayload = null,}) {
  return _then(_PairingDto(
pairingId: null == pairingId ? _self.pairingId : pairingId // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,qrPayload: null == qrPayload ? _self.qrPayload : qrPayload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PairingStatusDto {

@JsonKey(unknownEnumValue: PairingStatus.unknown) PairingStatus get status;
/// Create a copy of PairingStatusDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingStatusDtoCopyWith<PairingStatusDto> get copyWith => _$PairingStatusDtoCopyWithImpl<PairingStatusDto>(this as PairingStatusDto, _$identity);

  /// Serializes this PairingStatusDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PairingStatusDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingStatusDto&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PairingStatusDto;
  return Object.hash(runtimeType,_this.status);
}

@override
String toString() {
  final _this = this as PairingStatusDto;
  return 'PairingStatusDto(status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $PairingStatusDtoCopyWith<$Res>  {
  factory $PairingStatusDtoCopyWith(PairingStatusDto value, $Res Function(PairingStatusDto) _then) = _$PairingStatusDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(unknownEnumValue: PairingStatus.unknown) PairingStatus status
});




}
/// @nodoc
class _$PairingStatusDtoCopyWithImpl<$Res>
    implements $PairingStatusDtoCopyWith<$Res> {
  _$PairingStatusDtoCopyWithImpl(this._self, this._then);

  final PairingStatusDto _self;
  final $Res Function(PairingStatusDto) _then;

/// Create a copy of PairingStatusDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(PairingStatusDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PairingStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [PairingStatusDto].
extension PairingStatusDtoPatterns on PairingStatusDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PairingStatusDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PairingStatusDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PairingStatusDto value)  $default,){
final _that = this;
switch (_that) {
case _PairingStatusDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PairingStatusDto value)?  $default,){
final _that = this;
switch (_that) {
case _PairingStatusDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: PairingStatus.unknown)  PairingStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PairingStatusDto() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(unknownEnumValue: PairingStatus.unknown)  PairingStatus status)  $default,) {final _that = this;
switch (_that) {
case _PairingStatusDto():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(unknownEnumValue: PairingStatus.unknown)  PairingStatus status)?  $default,) {final _that = this;
switch (_that) {
case _PairingStatusDto() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PairingStatusDto implements PairingStatusDto {
  const _PairingStatusDto({@JsonKey(unknownEnumValue: PairingStatus.unknown) required this.status});
  factory _PairingStatusDto.fromJson(Map<String, dynamic> json) => _$PairingStatusDtoFromJson(json);

@override@JsonKey(unknownEnumValue: PairingStatus.unknown) final  PairingStatus status;

/// Create a copy of PairingStatusDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PairingStatusDtoCopyWith<_PairingStatusDto> get copyWith => __$PairingStatusDtoCopyWithImpl<_PairingStatusDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PairingStatusDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PairingStatusDto&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,status);
}

@override
String toString() {
    return 'PairingStatusDto(status: $status)';
}


}

/// @nodoc
abstract mixin class _$PairingStatusDtoCopyWith<$Res> implements $PairingStatusDtoCopyWith<$Res> {
  factory _$PairingStatusDtoCopyWith(_PairingStatusDto value, $Res Function(_PairingStatusDto) _then) = __$PairingStatusDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(unknownEnumValue: PairingStatus.unknown) PairingStatus status
});




}
/// @nodoc
class __$PairingStatusDtoCopyWithImpl<$Res>
    implements _$PairingStatusDtoCopyWith<$Res> {
  __$PairingStatusDtoCopyWithImpl(this._self, this._then);

  final _PairingStatusDto _self;
  final $Res Function(_PairingStatusDto) _then;

/// Create a copy of PairingStatusDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_PairingStatusDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PairingStatus,
  ));
}


}

// dart format on
