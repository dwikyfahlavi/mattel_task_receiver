// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pair_watch_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PairWatchState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairWatchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'PairWatchState()';
}


}

/// @nodoc
class $PairWatchStateCopyWith<$Res>  {
$PairWatchStateCopyWith(PairWatchState _, $Res Function(PairWatchState) __);
}


/// Adds pattern-matching-related methods to [PairWatchState].
extension PairWatchStatePatterns on PairWatchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PairScanning value)?  scanning,TResult Function( PairChecking value)?  checking,TResult Function( PairConfirming value)?  confirming,TResult Function( PairApproving value)?  approving,TResult Function( PairSuccess value)?  success,TResult Function( PairFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PairScanning() when scanning != null:
return scanning(_that);case PairChecking() when checking != null:
return checking(_that);case PairConfirming() when confirming != null:
return confirming(_that);case PairApproving() when approving != null:
return approving(_that);case PairSuccess() when success != null:
return success(_that);case PairFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PairScanning value)  scanning,required TResult Function( PairChecking value)  checking,required TResult Function( PairConfirming value)  confirming,required TResult Function( PairApproving value)  approving,required TResult Function( PairSuccess value)  success,required TResult Function( PairFailure value)  failure,}){
final _that = this;
switch (_that) {
case PairScanning():
return scanning(_that);case PairChecking():
return checking(_that);case PairConfirming():
return confirming(_that);case PairApproving():
return approving(_that);case PairSuccess():
return success(_that);case PairFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PairScanning value)?  scanning,TResult? Function( PairChecking value)?  checking,TResult? Function( PairConfirming value)?  confirming,TResult? Function( PairApproving value)?  approving,TResult? Function( PairSuccess value)?  success,TResult? Function( PairFailure value)?  failure,}){
final _that = this;
switch (_that) {
case PairScanning() when scanning != null:
return scanning(_that);case PairChecking() when checking != null:
return checking(_that);case PairConfirming() when confirming != null:
return confirming(_that);case PairApproving() when approving != null:
return approving(_that);case PairSuccess() when success != null:
return success(_that);case PairFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ScanRejection rejection)?  scanning,TResult Function( String code)?  checking,TResult Function( String code,  DeviceDto device)?  confirming,TResult Function( String code,  DeviceDto device)?  approving,TResult Function( DeviceDto device)?  success,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PairScanning() when scanning != null:
return scanning(_that.rejection);case PairChecking() when checking != null:
return checking(_that.code);case PairConfirming() when confirming != null:
return confirming(_that.code,_that.device);case PairApproving() when approving != null:
return approving(_that.code,_that.device);case PairSuccess() when success != null:
return success(_that.device);case PairFailure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ScanRejection rejection)  scanning,required TResult Function( String code)  checking,required TResult Function( String code,  DeviceDto device)  confirming,required TResult Function( String code,  DeviceDto device)  approving,required TResult Function( DeviceDto device)  success,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case PairScanning():
return scanning(_that.rejection);case PairChecking():
return checking(_that.code);case PairConfirming():
return confirming(_that.code,_that.device);case PairApproving():
return approving(_that.code,_that.device);case PairSuccess():
return success(_that.device);case PairFailure():
return failure(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ScanRejection rejection)?  scanning,TResult? Function( String code)?  checking,TResult? Function( String code,  DeviceDto device)?  confirming,TResult? Function( String code,  DeviceDto device)?  approving,TResult? Function( DeviceDto device)?  success,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case PairScanning() when scanning != null:
return scanning(_that.rejection);case PairChecking() when checking != null:
return checking(_that.code);case PairConfirming() when confirming != null:
return confirming(_that.code,_that.device);case PairApproving() when approving != null:
return approving(_that.code,_that.device);case PairSuccess() when success != null:
return success(_that.device);case PairFailure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class PairScanning implements PairWatchState {
  const PairScanning({this.rejection = ScanRejection.none});
  

@JsonKey() final  ScanRejection rejection;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairScanningCopyWith<PairScanning> get copyWith => _$PairScanningCopyWithImpl<PairScanning>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairScanning&&(identical(other.rejection, rejection) || other.rejection == rejection));
}


@override
int get hashCode {
    return Object.hash(runtimeType,rejection);
}

@override
String toString() {
    return 'PairWatchState.scanning(rejection: $rejection)';
}


}

/// @nodoc
abstract mixin class $PairScanningCopyWith<$Res> implements $PairWatchStateCopyWith<$Res> {
  factory $PairScanningCopyWith(PairScanning value, $Res Function(PairScanning) _then) = _$PairScanningCopyWithImpl;
@useResult
$Res call({
 ScanRejection rejection
});




}
/// @nodoc
class _$PairScanningCopyWithImpl<$Res>
    implements $PairScanningCopyWith<$Res> {
  _$PairScanningCopyWithImpl(this._self, this._then);

  final PairScanning _self;
  final $Res Function(PairScanning) _then;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? rejection = null,}) {
  return _then(PairScanning(
rejection: null == rejection ? _self.rejection : rejection // ignore: cast_nullable_to_non_nullable
as ScanRejection,
  ));
}


}

/// @nodoc


class PairChecking implements PairWatchState {
  const PairChecking(this.code);
  

 final  String code;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairCheckingCopyWith<PairChecking> get copyWith => _$PairCheckingCopyWithImpl<PairChecking>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairChecking&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code);
}

@override
String toString() {
    return 'PairWatchState.checking(code: $code)';
}


}

/// @nodoc
abstract mixin class $PairCheckingCopyWith<$Res> implements $PairWatchStateCopyWith<$Res> {
  factory $PairCheckingCopyWith(PairChecking value, $Res Function(PairChecking) _then) = _$PairCheckingCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class _$PairCheckingCopyWithImpl<$Res>
    implements $PairCheckingCopyWith<$Res> {
  _$PairCheckingCopyWithImpl(this._self, this._then);

  final PairChecking _self;
  final $Res Function(PairChecking) _then;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(PairChecking(
null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class PairConfirming implements PairWatchState {
  const PairConfirming({required this.code, required this.device});
  

 final  String code;
 final  DeviceDto device;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairConfirmingCopyWith<PairConfirming> get copyWith => _$PairConfirmingCopyWithImpl<PairConfirming>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairConfirming&&(identical(other.code, code) || other.code == code)&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,device);
}

@override
String toString() {
    return 'PairWatchState.confirming(code: $code, device: $device)';
}


}

/// @nodoc
abstract mixin class $PairConfirmingCopyWith<$Res> implements $PairWatchStateCopyWith<$Res> {
  factory $PairConfirmingCopyWith(PairConfirming value, $Res Function(PairConfirming) _then) = _$PairConfirmingCopyWithImpl;
@useResult
$Res call({
 String code, DeviceDto device
});


$DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class _$PairConfirmingCopyWithImpl<$Res>
    implements $PairConfirmingCopyWith<$Res> {
  _$PairConfirmingCopyWithImpl(this._self, this._then);

  final PairConfirming _self;
  final $Res Function(PairConfirming) _then;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? device = null,}) {
  return _then(PairConfirming(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,
  ));
}

/// Create a copy of PairWatchState
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


class PairApproving implements PairWatchState {
  const PairApproving({required this.code, required this.device});
  

 final  String code;
 final  DeviceDto device;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairApprovingCopyWith<PairApproving> get copyWith => _$PairApprovingCopyWithImpl<PairApproving>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairApproving&&(identical(other.code, code) || other.code == code)&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,code,device);
}

@override
String toString() {
    return 'PairWatchState.approving(code: $code, device: $device)';
}


}

/// @nodoc
abstract mixin class $PairApprovingCopyWith<$Res> implements $PairWatchStateCopyWith<$Res> {
  factory $PairApprovingCopyWith(PairApproving value, $Res Function(PairApproving) _then) = _$PairApprovingCopyWithImpl;
@useResult
$Res call({
 String code, DeviceDto device
});


$DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class _$PairApprovingCopyWithImpl<$Res>
    implements $PairApprovingCopyWith<$Res> {
  _$PairApprovingCopyWithImpl(this._self, this._then);

  final PairApproving _self;
  final $Res Function(PairApproving) _then;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,Object? device = null,}) {
  return _then(PairApproving(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,
  ));
}

/// Create a copy of PairWatchState
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


class PairSuccess implements PairWatchState {
  const PairSuccess(this.device);
  

 final  DeviceDto device;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairSuccessCopyWith<PairSuccess> get copyWith => _$PairSuccessCopyWithImpl<PairSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairSuccess&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode {
    return Object.hash(runtimeType,device);
}

@override
String toString() {
    return 'PairWatchState.success(device: $device)';
}


}

/// @nodoc
abstract mixin class $PairSuccessCopyWith<$Res> implements $PairWatchStateCopyWith<$Res> {
  factory $PairSuccessCopyWith(PairSuccess value, $Res Function(PairSuccess) _then) = _$PairSuccessCopyWithImpl;
@useResult
$Res call({
 DeviceDto device
});


$DeviceDtoCopyWith<$Res> get device;

}
/// @nodoc
class _$PairSuccessCopyWithImpl<$Res>
    implements $PairSuccessCopyWith<$Res> {
  _$PairSuccessCopyWithImpl(this._self, this._then);

  final PairSuccess _self;
  final $Res Function(PairSuccess) _then;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(PairSuccess(
null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as DeviceDto,
  ));
}

/// Create a copy of PairWatchState
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


class PairFailure implements PairWatchState {
  const PairFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairFailureCopyWith<PairFailure> get copyWith => _$PairFailureCopyWithImpl<PairFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'PairWatchState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $PairFailureCopyWith<$Res> implements $PairWatchStateCopyWith<$Res> {
  factory $PairFailureCopyWith(PairFailure value, $Res Function(PairFailure) _then) = _$PairFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$PairFailureCopyWithImpl<$Res>
    implements $PairFailureCopyWith<$Res> {
  _$PairFailureCopyWithImpl(this._self, this._then);

  final PairFailure _self;
  final $Res Function(PairFailure) _then;

/// Create a copy of PairWatchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(PairFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
