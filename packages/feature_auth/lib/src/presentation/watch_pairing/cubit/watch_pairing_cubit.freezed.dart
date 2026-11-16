// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_pairing_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchPairingState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchPairingState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WatchPairingState()';
}


}

/// @nodoc
class $WatchPairingStateCopyWith<$Res>  {
$WatchPairingStateCopyWith(WatchPairingState _, $Res Function(WatchPairingState) __);
}


/// Adds pattern-matching-related methods to [WatchPairingState].
extension WatchPairingStatePatterns on WatchPairingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PairingCreating value)?  creating,TResult Function( PairingShowing value)?  showing,TResult Function( PairingClaiming value)?  claiming,TResult Function( PairingDone value)?  done,TResult Function( PairingExpired value)?  expired,TResult Function( PairingDeviceRejected value)?  deviceRejected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PairingCreating() when creating != null:
return creating(_that);case PairingShowing() when showing != null:
return showing(_that);case PairingClaiming() when claiming != null:
return claiming(_that);case PairingDone() when done != null:
return done(_that);case PairingExpired() when expired != null:
return expired(_that);case PairingDeviceRejected() when deviceRejected != null:
return deviceRejected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PairingCreating value)  creating,required TResult Function( PairingShowing value)  showing,required TResult Function( PairingClaiming value)  claiming,required TResult Function( PairingDone value)  done,required TResult Function( PairingExpired value)  expired,required TResult Function( PairingDeviceRejected value)  deviceRejected,}){
final _that = this;
switch (_that) {
case PairingCreating():
return creating(_that);case PairingShowing():
return showing(_that);case PairingClaiming():
return claiming(_that);case PairingDone():
return done(_that);case PairingExpired():
return expired(_that);case PairingDeviceRejected():
return deviceRejected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PairingCreating value)?  creating,TResult? Function( PairingShowing value)?  showing,TResult? Function( PairingClaiming value)?  claiming,TResult? Function( PairingDone value)?  done,TResult? Function( PairingExpired value)?  expired,TResult? Function( PairingDeviceRejected value)?  deviceRejected,}){
final _that = this;
switch (_that) {
case PairingCreating() when creating != null:
return creating(_that);case PairingShowing() when showing != null:
return showing(_that);case PairingClaiming() when claiming != null:
return claiming(_that);case PairingDone() when done != null:
return done(_that);case PairingExpired() when expired != null:
return expired(_that);case PairingDeviceRejected() when deviceRejected != null:
return deviceRejected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  creating,TResult Function( PairingDto pairing,  String qrData)?  showing,TResult Function()?  claiming,TResult Function( SessionInfo info)?  done,TResult Function( bool offline)?  expired,TResult Function()?  deviceRejected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PairingCreating() when creating != null:
return creating();case PairingShowing() when showing != null:
return showing(_that.pairing,_that.qrData);case PairingClaiming() when claiming != null:
return claiming();case PairingDone() when done != null:
return done(_that.info);case PairingExpired() when expired != null:
return expired(_that.offline);case PairingDeviceRejected() when deviceRejected != null:
return deviceRejected();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  creating,required TResult Function( PairingDto pairing,  String qrData)  showing,required TResult Function()  claiming,required TResult Function( SessionInfo info)  done,required TResult Function( bool offline)  expired,required TResult Function()  deviceRejected,}) {final _that = this;
switch (_that) {
case PairingCreating():
return creating();case PairingShowing():
return showing(_that.pairing,_that.qrData);case PairingClaiming():
return claiming();case PairingDone():
return done(_that.info);case PairingExpired():
return expired(_that.offline);case PairingDeviceRejected():
return deviceRejected();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  creating,TResult? Function( PairingDto pairing,  String qrData)?  showing,TResult? Function()?  claiming,TResult? Function( SessionInfo info)?  done,TResult? Function( bool offline)?  expired,TResult? Function()?  deviceRejected,}) {final _that = this;
switch (_that) {
case PairingCreating() when creating != null:
return creating();case PairingShowing() when showing != null:
return showing(_that.pairing,_that.qrData);case PairingClaiming() when claiming != null:
return claiming();case PairingDone() when done != null:
return done(_that.info);case PairingExpired() when expired != null:
return expired(_that.offline);case PairingDeviceRejected() when deviceRejected != null:
return deviceRejected();case _:
  return null;

}
}

}

/// @nodoc


class PairingCreating implements WatchPairingState {
  const PairingCreating();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingCreating);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WatchPairingState.creating()';
}


}




/// @nodoc


class PairingShowing implements WatchPairingState {
  const PairingShowing({required this.pairing, required this.qrData});
  

 final  PairingDto pairing;
 final  String qrData;

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingShowingCopyWith<PairingShowing> get copyWith => _$PairingShowingCopyWithImpl<PairingShowing>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingShowing&&(identical(other.pairing, pairing) || other.pairing == pairing)&&(identical(other.qrData, qrData) || other.qrData == qrData));
}


@override
int get hashCode {
    return Object.hash(runtimeType,pairing,qrData);
}

@override
String toString() {
    return 'WatchPairingState.showing(pairing: $pairing, qrData: $qrData)';
}


}

/// @nodoc
abstract mixin class $PairingShowingCopyWith<$Res> implements $WatchPairingStateCopyWith<$Res> {
  factory $PairingShowingCopyWith(PairingShowing value, $Res Function(PairingShowing) _then) = _$PairingShowingCopyWithImpl;
@useResult
$Res call({
 PairingDto pairing, String qrData
});


$PairingDtoCopyWith<$Res> get pairing;

}
/// @nodoc
class _$PairingShowingCopyWithImpl<$Res>
    implements $PairingShowingCopyWith<$Res> {
  _$PairingShowingCopyWithImpl(this._self, this._then);

  final PairingShowing _self;
  final $Res Function(PairingShowing) _then;

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? pairing = null,Object? qrData = null,}) {
  return _then(PairingShowing(
pairing: null == pairing ? _self.pairing : pairing // ignore: cast_nullable_to_non_nullable
as PairingDto,qrData: null == qrData ? _self.qrData : qrData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PairingDtoCopyWith<$Res> get pairing {
  
  return $PairingDtoCopyWith<$Res>(_self.pairing, (value) {
    return _then(_self.copyWith(pairing: value));
  });
}
}

/// @nodoc


class PairingClaiming implements WatchPairingState {
  const PairingClaiming();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingClaiming);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WatchPairingState.claiming()';
}


}




/// @nodoc


class PairingDone implements WatchPairingState {
  const PairingDone(this.info);
  

 final  SessionInfo info;

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingDoneCopyWith<PairingDone> get copyWith => _$PairingDoneCopyWithImpl<PairingDone>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingDone&&(identical(other.info, info) || other.info == info));
}


@override
int get hashCode {
    return Object.hash(runtimeType,info);
}

@override
String toString() {
    return 'WatchPairingState.done(info: $info)';
}


}

/// @nodoc
abstract mixin class $PairingDoneCopyWith<$Res> implements $WatchPairingStateCopyWith<$Res> {
  factory $PairingDoneCopyWith(PairingDone value, $Res Function(PairingDone) _then) = _$PairingDoneCopyWithImpl;
@useResult
$Res call({
 SessionInfo info
});


$SessionInfoCopyWith<$Res> get info;

}
/// @nodoc
class _$PairingDoneCopyWithImpl<$Res>
    implements $PairingDoneCopyWith<$Res> {
  _$PairingDoneCopyWithImpl(this._self, this._then);

  final PairingDone _self;
  final $Res Function(PairingDone) _then;

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? info = null,}) {
  return _then(PairingDone(
null == info ? _self.info : info // ignore: cast_nullable_to_non_nullable
as SessionInfo,
  ));
}

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionInfoCopyWith<$Res> get info {
  
  return $SessionInfoCopyWith<$Res>(_self.info, (value) {
    return _then(_self.copyWith(info: value));
  });
}
}

/// @nodoc


class PairingExpired implements WatchPairingState {
  const PairingExpired({this.offline = false});
  

@JsonKey() final  bool offline;

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PairingExpiredCopyWith<PairingExpired> get copyWith => _$PairingExpiredCopyWithImpl<PairingExpired>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingExpired&&(identical(other.offline, offline) || other.offline == offline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,offline);
}

@override
String toString() {
    return 'WatchPairingState.expired(offline: $offline)';
}


}

/// @nodoc
abstract mixin class $PairingExpiredCopyWith<$Res> implements $WatchPairingStateCopyWith<$Res> {
  factory $PairingExpiredCopyWith(PairingExpired value, $Res Function(PairingExpired) _then) = _$PairingExpiredCopyWithImpl;
@useResult
$Res call({
 bool offline
});




}
/// @nodoc
class _$PairingExpiredCopyWithImpl<$Res>
    implements $PairingExpiredCopyWith<$Res> {
  _$PairingExpiredCopyWithImpl(this._self, this._then);

  final PairingExpired _self;
  final $Res Function(PairingExpired) _then;

/// Create a copy of WatchPairingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? offline = null,}) {
  return _then(PairingExpired(
offline: null == offline ? _self.offline : offline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class PairingDeviceRejected implements WatchPairingState {
  const PairingDeviceRejected();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is PairingDeviceRejected);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WatchPairingState.deviceRejected()';
}


}




// dart format on
