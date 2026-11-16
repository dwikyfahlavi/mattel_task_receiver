// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AvailabilityState {

 bool get available; DateTime? get checkedInAt; AvailabilityBusy get busy;/// Set when Check In was blocked or warned by the readiness check, or a
/// background check found a blocking problem.
 ReadinessReport? get readiness;/// True when [readiness] came from a Check In tap: only then may the
/// checklist offer "Tetap Check In".
 bool get readinessForCheckIn; Failure? get error;/// Increments each time a Check Out was queued offline (snackbar trigger).
 int get checkOutQueuedCount;/// Check Out tapped while a task is In Progress (doc 4.2 rule 6).
 int get checkOutBlockedCount;/// Increments when the server refused a queued Check Out (doc 16).
 int get checkOutConflictCount;
/// Create a copy of AvailabilityState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AvailabilityStateCopyWith<AvailabilityState> get copyWith => _$AvailabilityStateCopyWithImpl<AvailabilityState>(this as AvailabilityState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AvailabilityState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AvailabilityState&&(identical(other.available, _this.available) || other.available == _this.available)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt)&&(identical(other.busy, _this.busy) || other.busy == _this.busy)&&(identical(other.readiness, _this.readiness) || other.readiness == _this.readiness)&&(identical(other.readinessForCheckIn, _this.readinessForCheckIn) || other.readinessForCheckIn == _this.readinessForCheckIn)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.checkOutQueuedCount, _this.checkOutQueuedCount) || other.checkOutQueuedCount == _this.checkOutQueuedCount)&&(identical(other.checkOutBlockedCount, _this.checkOutBlockedCount) || other.checkOutBlockedCount == _this.checkOutBlockedCount)&&(identical(other.checkOutConflictCount, _this.checkOutConflictCount) || other.checkOutConflictCount == _this.checkOutConflictCount));
}


@override
int get hashCode {
  final _this = this as AvailabilityState;
  return Object.hash(runtimeType,_this.available,_this.checkedInAt,_this.busy,_this.readiness,_this.readinessForCheckIn,_this.error,_this.checkOutQueuedCount,_this.checkOutBlockedCount,_this.checkOutConflictCount);
}

@override
String toString() {
  final _this = this as AvailabilityState;
  return 'AvailabilityState(available: ${_this.available}, checkedInAt: ${_this.checkedInAt}, busy: ${_this.busy}, readiness: ${_this.readiness}, readinessForCheckIn: ${_this.readinessForCheckIn}, error: ${_this.error}, checkOutQueuedCount: ${_this.checkOutQueuedCount}, checkOutBlockedCount: ${_this.checkOutBlockedCount}, checkOutConflictCount: ${_this.checkOutConflictCount})';
}


}

/// @nodoc
abstract mixin class $AvailabilityStateCopyWith<$Res>  {
  factory $AvailabilityStateCopyWith(AvailabilityState value, $Res Function(AvailabilityState) _then) = _$AvailabilityStateCopyWithImpl;
@useResult
$Res call({
 bool available, DateTime? checkedInAt, AvailabilityBusy busy, ReadinessReport? readiness, bool readinessForCheckIn, Failure? error, int checkOutQueuedCount, int checkOutBlockedCount, int checkOutConflictCount
});




}
/// @nodoc
class _$AvailabilityStateCopyWithImpl<$Res>
    implements $AvailabilityStateCopyWith<$Res> {
  _$AvailabilityStateCopyWithImpl(this._self, this._then);

  final AvailabilityState _self;
  final $Res Function(AvailabilityState) _then;

/// Create a copy of AvailabilityState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? available = null,Object? checkedInAt = freezed,Object? busy = null,Object? readiness = freezed,Object? readinessForCheckIn = null,Object? error = freezed,Object? checkOutQueuedCount = null,Object? checkOutBlockedCount = null,Object? checkOutConflictCount = null,}) {
  return _then(AvailabilityState(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as AvailabilityBusy,readiness: freezed == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as ReadinessReport?,readinessForCheckIn: null == readinessForCheckIn ? _self.readinessForCheckIn : readinessForCheckIn // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,checkOutQueuedCount: null == checkOutQueuedCount ? _self.checkOutQueuedCount : checkOutQueuedCount // ignore: cast_nullable_to_non_nullable
as int,checkOutBlockedCount: null == checkOutBlockedCount ? _self.checkOutBlockedCount : checkOutBlockedCount // ignore: cast_nullable_to_non_nullable
as int,checkOutConflictCount: null == checkOutConflictCount ? _self.checkOutConflictCount : checkOutConflictCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AvailabilityState].
extension AvailabilityStatePatterns on AvailabilityState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AvailabilityState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AvailabilityState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AvailabilityState value)  $default,){
final _that = this;
switch (_that) {
case _AvailabilityState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AvailabilityState value)?  $default,){
final _that = this;
switch (_that) {
case _AvailabilityState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool available,  DateTime? checkedInAt,  AvailabilityBusy busy,  ReadinessReport? readiness,  bool readinessForCheckIn,  Failure? error,  int checkOutQueuedCount,  int checkOutBlockedCount,  int checkOutConflictCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AvailabilityState() when $default != null:
return $default(_that.available,_that.checkedInAt,_that.busy,_that.readiness,_that.readinessForCheckIn,_that.error,_that.checkOutQueuedCount,_that.checkOutBlockedCount,_that.checkOutConflictCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool available,  DateTime? checkedInAt,  AvailabilityBusy busy,  ReadinessReport? readiness,  bool readinessForCheckIn,  Failure? error,  int checkOutQueuedCount,  int checkOutBlockedCount,  int checkOutConflictCount)  $default,) {final _that = this;
switch (_that) {
case _AvailabilityState():
return $default(_that.available,_that.checkedInAt,_that.busy,_that.readiness,_that.readinessForCheckIn,_that.error,_that.checkOutQueuedCount,_that.checkOutBlockedCount,_that.checkOutConflictCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool available,  DateTime? checkedInAt,  AvailabilityBusy busy,  ReadinessReport? readiness,  bool readinessForCheckIn,  Failure? error,  int checkOutQueuedCount,  int checkOutBlockedCount,  int checkOutConflictCount)?  $default,) {final _that = this;
switch (_that) {
case _AvailabilityState() when $default != null:
return $default(_that.available,_that.checkedInAt,_that.busy,_that.readiness,_that.readinessForCheckIn,_that.error,_that.checkOutQueuedCount,_that.checkOutBlockedCount,_that.checkOutConflictCount);case _:
  return null;

}
}

}

/// @nodoc


class _AvailabilityState extends AvailabilityState {
  const _AvailabilityState({this.available = false, this.checkedInAt, this.busy = AvailabilityBusy.none, this.readiness, this.readinessForCheckIn = false, this.error, this.checkOutQueuedCount = 0, this.checkOutBlockedCount = 0, this.checkOutConflictCount = 0}): super._();
  

@override@JsonKey() final  bool available;
@override final  DateTime? checkedInAt;
@override@JsonKey() final  AvailabilityBusy busy;
/// Set when Check In was blocked or warned by the readiness check, or a
/// background check found a blocking problem.
@override final  ReadinessReport? readiness;
/// True when [readiness] came from a Check In tap: only then may the
/// checklist offer "Tetap Check In".
@override@JsonKey() final  bool readinessForCheckIn;
@override final  Failure? error;
/// Increments each time a Check Out was queued offline (snackbar trigger).
@override@JsonKey() final  int checkOutQueuedCount;
/// Check Out tapped while a task is In Progress (doc 4.2 rule 6).
@override@JsonKey() final  int checkOutBlockedCount;
/// Increments when the server refused a queued Check Out (doc 16).
@override@JsonKey() final  int checkOutConflictCount;

/// Create a copy of AvailabilityState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvailabilityStateCopyWith<_AvailabilityState> get copyWith => __$AvailabilityStateCopyWithImpl<_AvailabilityState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvailabilityState&&(identical(other.available, available) || other.available == available)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.readiness, readiness) || other.readiness == readiness)&&(identical(other.readinessForCheckIn, readinessForCheckIn) || other.readinessForCheckIn == readinessForCheckIn)&&(identical(other.error, error) || other.error == error)&&(identical(other.checkOutQueuedCount, checkOutQueuedCount) || other.checkOutQueuedCount == checkOutQueuedCount)&&(identical(other.checkOutBlockedCount, checkOutBlockedCount) || other.checkOutBlockedCount == checkOutBlockedCount)&&(identical(other.checkOutConflictCount, checkOutConflictCount) || other.checkOutConflictCount == checkOutConflictCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,available,checkedInAt,busy,readiness,readinessForCheckIn,error,checkOutQueuedCount,checkOutBlockedCount,checkOutConflictCount);
}

@override
String toString() {
    return 'AvailabilityState(available: $available, checkedInAt: $checkedInAt, busy: $busy, readiness: $readiness, readinessForCheckIn: $readinessForCheckIn, error: $error, checkOutQueuedCount: $checkOutQueuedCount, checkOutBlockedCount: $checkOutBlockedCount, checkOutConflictCount: $checkOutConflictCount)';
}


}

/// @nodoc
abstract mixin class _$AvailabilityStateCopyWith<$Res> implements $AvailabilityStateCopyWith<$Res> {
  factory _$AvailabilityStateCopyWith(_AvailabilityState value, $Res Function(_AvailabilityState) _then) = __$AvailabilityStateCopyWithImpl;
@override @useResult
$Res call({
 bool available, DateTime? checkedInAt, AvailabilityBusy busy, ReadinessReport? readiness, bool readinessForCheckIn, Failure? error, int checkOutQueuedCount, int checkOutBlockedCount, int checkOutConflictCount
});




}
/// @nodoc
class __$AvailabilityStateCopyWithImpl<$Res>
    implements _$AvailabilityStateCopyWith<$Res> {
  __$AvailabilityStateCopyWithImpl(this._self, this._then);

  final _AvailabilityState _self;
  final $Res Function(_AvailabilityState) _then;

/// Create a copy of AvailabilityState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? available = null,Object? checkedInAt = freezed,Object? busy = null,Object? readiness = freezed,Object? readinessForCheckIn = null,Object? error = freezed,Object? checkOutQueuedCount = null,Object? checkOutBlockedCount = null,Object? checkOutConflictCount = null,}) {
  return _then(_AvailabilityState(
available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,busy: null == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as AvailabilityBusy,readiness: freezed == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as ReadinessReport?,readinessForCheckIn: null == readinessForCheckIn ? _self.readinessForCheckIn : readinessForCheckIn // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,checkOutQueuedCount: null == checkOutQueuedCount ? _self.checkOutQueuedCount : checkOutQueuedCount // ignore: cast_nullable_to_non_nullable
as int,checkOutBlockedCount: null == checkOutBlockedCount ? _self.checkOutBlockedCount : checkOutBlockedCount // ignore: cast_nullable_to_non_nullable
as int,checkOutConflictCount: null == checkOutConflictCount ? _self.checkOutConflictCount : checkOutConflictCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
