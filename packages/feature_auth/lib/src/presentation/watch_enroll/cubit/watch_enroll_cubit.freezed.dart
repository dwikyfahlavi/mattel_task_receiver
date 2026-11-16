// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_enroll_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchEnrollState {

 String get code; bool get submitting;/// The typed or scanned value is not an enrollment code.
 bool get invalidCode; Failure? get failure;/// Set once enrolled.
 DeviceDto? get device;
/// Create a copy of WatchEnrollState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchEnrollStateCopyWith<WatchEnrollState> get copyWith => _$WatchEnrollStateCopyWithImpl<WatchEnrollState>(this as WatchEnrollState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as WatchEnrollState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchEnrollState&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.invalidCode, _this.invalidCode) || other.invalidCode == _this.invalidCode)&&(identical(other.failure, _this.failure) || other.failure == _this.failure)&&(identical(other.device, _this.device) || other.device == _this.device));
}


@override
int get hashCode {
  final _this = this as WatchEnrollState;
  return Object.hash(runtimeType,_this.code,_this.submitting,_this.invalidCode,_this.failure,_this.device);
}

@override
String toString() {
  final _this = this as WatchEnrollState;
  return 'WatchEnrollState(code: ${_this.code}, submitting: ${_this.submitting}, invalidCode: ${_this.invalidCode}, failure: ${_this.failure}, device: ${_this.device})';
}


}

/// @nodoc
abstract mixin class $WatchEnrollStateCopyWith<$Res>  {
  factory $WatchEnrollStateCopyWith(WatchEnrollState value, $Res Function(WatchEnrollState) _then) = _$WatchEnrollStateCopyWithImpl;
@useResult
$Res call({
 String code, bool submitting, bool invalidCode, Failure? failure, DeviceDto? device
});


$DeviceDtoCopyWith<$Res>? get device;

}
/// @nodoc
class _$WatchEnrollStateCopyWithImpl<$Res>
    implements $WatchEnrollStateCopyWith<$Res> {
  _$WatchEnrollStateCopyWithImpl(this._self, this._then);

  final WatchEnrollState _self;
  final $Res Function(WatchEnrollState) _then;

/// Create a copy of WatchEnrollState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = null,Object? submitting = null,Object? invalidCode = null,Object? failure = freezed,Object? device = freezed,}) {
  return _then(WatchEnrollState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,invalidCode: null == invalidCode ? _self.invalidCode : invalidCode // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto?,
  ));
}
/// Create a copy of WatchEnrollState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res>? get device {
    if (_self.device == null) {
    return null;
  }

  return $DeviceDtoCopyWith<$Res>(_self.device!, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}


/// Adds pattern-matching-related methods to [WatchEnrollState].
extension WatchEnrollStatePatterns on WatchEnrollState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchEnrollState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchEnrollState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchEnrollState value)  $default,){
final _that = this;
switch (_that) {
case _WatchEnrollState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchEnrollState value)?  $default,){
final _that = this;
switch (_that) {
case _WatchEnrollState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String code,  bool submitting,  bool invalidCode,  Failure? failure,  DeviceDto? device)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchEnrollState() when $default != null:
return $default(_that.code,_that.submitting,_that.invalidCode,_that.failure,_that.device);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String code,  bool submitting,  bool invalidCode,  Failure? failure,  DeviceDto? device)  $default,) {final _that = this;
switch (_that) {
case _WatchEnrollState():
return $default(_that.code,_that.submitting,_that.invalidCode,_that.failure,_that.device);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String code,  bool submitting,  bool invalidCode,  Failure? failure,  DeviceDto? device)?  $default,) {final _that = this;
switch (_that) {
case _WatchEnrollState() when $default != null:
return $default(_that.code,_that.submitting,_that.invalidCode,_that.failure,_that.device);case _:
  return null;

}
}

}

/// @nodoc


class _WatchEnrollState extends WatchEnrollState {
  const _WatchEnrollState({this.code = '', this.submitting = false, this.invalidCode = false, this.failure, this.device}): super._();
  

@override@JsonKey() final  String code;
@override@JsonKey() final  bool submitting;
/// The typed or scanned value is not an enrollment code.
@override@JsonKey() final  bool invalidCode;
@override final  Failure? failure;
/// Set once enrolled.
@override final  DeviceDto? device;

/// Create a copy of WatchEnrollState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchEnrollStateCopyWith<_WatchEnrollState> get copyWith => __$WatchEnrollStateCopyWithImpl<_WatchEnrollState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchEnrollState&&(identical(other.code, code) || other.code == code)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.invalidCode, invalidCode) || other.invalidCode == invalidCode)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,submitting,invalidCode,failure,device);
}

@override
String toString() {
    return 'WatchEnrollState(code: $code, submitting: $submitting, invalidCode: $invalidCode, failure: $failure, device: $device)';
}


}

/// @nodoc
abstract mixin class _$WatchEnrollStateCopyWith<$Res> implements $WatchEnrollStateCopyWith<$Res> {
  factory _$WatchEnrollStateCopyWith(_WatchEnrollState value, $Res Function(_WatchEnrollState) _then) = __$WatchEnrollStateCopyWithImpl;
@override @useResult
$Res call({
 String code, bool submitting, bool invalidCode, Failure? failure, DeviceDto? device
});


@override $DeviceDtoCopyWith<$Res>? get device;

}
/// @nodoc
class __$WatchEnrollStateCopyWithImpl<$Res>
    implements _$WatchEnrollStateCopyWith<$Res> {
  __$WatchEnrollStateCopyWithImpl(this._self, this._then);

  final _WatchEnrollState _self;
  final $Res Function(_WatchEnrollState) _then;

/// Create a copy of WatchEnrollState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = null,Object? submitting = null,Object? invalidCode = null,Object? failure = freezed,Object? device = freezed,}) {
  return _then(_WatchEnrollState(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,invalidCode: null == invalidCode ? _self.invalidCode : invalidCode // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto?,
  ));
}

/// Create a copy of WatchEnrollState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DeviceDtoCopyWith<$Res>? get device {
    if (_self.device == null) {
    return null;
  }

  return $DeviceDtoCopyWith<$Res>(_self.device!, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
