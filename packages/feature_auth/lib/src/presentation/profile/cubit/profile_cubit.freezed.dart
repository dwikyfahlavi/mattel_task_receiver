// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState {

 ProfileDto? get profile; bool get loadingProfile; Failure? get profileError;/// Phone only (the watch cannot list watches).
 List<PairedWatchDto> get watches; bool get loadingWatches; Failure? get watchesError;/// Session id being unpaired.
 String? get unpairing;/// Increments after each successful unpair (snackbar trigger).
 int get unpairedCount; Failure? get actionError;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProfileState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.loadingProfile, _this.loadingProfile) || other.loadingProfile == _this.loadingProfile)&&(identical(other.profileError, _this.profileError) || other.profileError == _this.profileError)&&const DeepCollectionEquality().equals(other.watches, _this.watches)&&(identical(other.loadingWatches, _this.loadingWatches) || other.loadingWatches == _this.loadingWatches)&&(identical(other.watchesError, _this.watchesError) || other.watchesError == _this.watchesError)&&(identical(other.unpairing, _this.unpairing) || other.unpairing == _this.unpairing)&&(identical(other.unpairedCount, _this.unpairedCount) || other.unpairedCount == _this.unpairedCount)&&(identical(other.actionError, _this.actionError) || other.actionError == _this.actionError));
}


@override
int get hashCode {
  final _this = this as ProfileState;
  return Object.hash(runtimeType,_this.profile,_this.loadingProfile,_this.profileError,const DeepCollectionEquality().hash(_this.watches),_this.loadingWatches,_this.watchesError,_this.unpairing,_this.unpairedCount,_this.actionError);
}

@override
String toString() {
  final _this = this as ProfileState;
  return 'ProfileState(profile: ${_this.profile}, loadingProfile: ${_this.loadingProfile}, profileError: ${_this.profileError}, watches: ${_this.watches}, loadingWatches: ${_this.loadingWatches}, watchesError: ${_this.watchesError}, unpairing: ${_this.unpairing}, unpairedCount: ${_this.unpairedCount}, actionError: ${_this.actionError})';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 ProfileDto? profile, bool loadingProfile, Failure? profileError, List<PairedWatchDto> watches, bool loadingWatches, Failure? watchesError, String? unpairing, int unpairedCount, Failure? actionError
});


$ProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? loadingProfile = null,Object? profileError = freezed,Object? watches = null,Object? loadingWatches = null,Object? watchesError = freezed,Object? unpairing = freezed,Object? unpairedCount = null,Object? actionError = freezed,}) {
  return _then(ProfileState(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileDto?,loadingProfile: null == loadingProfile ? _self.loadingProfile : loadingProfile // ignore: cast_nullable_to_non_nullable
as bool,profileError: freezed == profileError ? _self.profileError : profileError // ignore: cast_nullable_to_non_nullable
as Failure?,watches: null == watches ? _self.watches : watches // ignore: cast_nullable_to_non_nullable
as List<PairedWatchDto>,loadingWatches: null == loadingWatches ? _self.loadingWatches : loadingWatches // ignore: cast_nullable_to_non_nullable
as bool,watchesError: freezed == watchesError ? _self.watchesError : watchesError // ignore: cast_nullable_to_non_nullable
as Failure?,unpairing: freezed == unpairing ? _self.unpairing : unpairing // ignore: cast_nullable_to_non_nullable
as String?,unpairedCount: null == unpairedCount ? _self.unpairedCount : unpairedCount // ignore: cast_nullable_to_non_nullable
as int,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileDto? profile,  bool loadingProfile,  Failure? profileError,  List<PairedWatchDto> watches,  bool loadingWatches,  Failure? watchesError,  String? unpairing,  int unpairedCount,  Failure? actionError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.profile,_that.loadingProfile,_that.profileError,_that.watches,_that.loadingWatches,_that.watchesError,_that.unpairing,_that.unpairedCount,_that.actionError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileDto? profile,  bool loadingProfile,  Failure? profileError,  List<PairedWatchDto> watches,  bool loadingWatches,  Failure? watchesError,  String? unpairing,  int unpairedCount,  Failure? actionError)  $default,) {final _that = this;
switch (_that) {
case _ProfileState():
return $default(_that.profile,_that.loadingProfile,_that.profileError,_that.watches,_that.loadingWatches,_that.watchesError,_that.unpairing,_that.unpairedCount,_that.actionError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileDto? profile,  bool loadingProfile,  Failure? profileError,  List<PairedWatchDto> watches,  bool loadingWatches,  Failure? watchesError,  String? unpairing,  int unpairedCount,  Failure? actionError)?  $default,) {final _that = this;
switch (_that) {
case _ProfileState() when $default != null:
return $default(_that.profile,_that.loadingProfile,_that.profileError,_that.watches,_that.loadingWatches,_that.watchesError,_that.unpairing,_that.unpairedCount,_that.actionError);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileState implements ProfileState {
  const _ProfileState({this.profile, this.loadingProfile = true, this.profileError,  List<PairedWatchDto> watches = const <PairedWatchDto>[], this.loadingWatches = false, this.watchesError, this.unpairing, this.unpairedCount = 0, this.actionError}): _watches = watches;
  

@override final  ProfileDto? profile;
@override@JsonKey() final  bool loadingProfile;
@override final  Failure? profileError;
/// Phone only (the watch cannot list watches).
 final  List<PairedWatchDto> _watches;
/// Phone only (the watch cannot list watches).
@override@JsonKey() List<PairedWatchDto> get watches {
  if (_watches is EqualUnmodifiableListView) return _watches;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_watches);
}

@override@JsonKey() final  bool loadingWatches;
@override final  Failure? watchesError;
/// Session id being unpaired.
@override final  String? unpairing;
/// Increments after each successful unpair (snackbar trigger).
@override@JsonKey() final  int unpairedCount;
@override final  Failure? actionError;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileStateCopyWith<_ProfileState> get copyWith => __$ProfileStateCopyWithImpl<_ProfileState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileState&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.loadingProfile, loadingProfile) || other.loadingProfile == loadingProfile)&&(identical(other.profileError, profileError) || other.profileError == profileError)&&const DeepCollectionEquality().equals(other.watches, _watches)&&(identical(other.loadingWatches, loadingWatches) || other.loadingWatches == loadingWatches)&&(identical(other.watchesError, watchesError) || other.watchesError == watchesError)&&(identical(other.unpairing, unpairing) || other.unpairing == unpairing)&&(identical(other.unpairedCount, unpairedCount) || other.unpairedCount == unpairedCount)&&(identical(other.actionError, actionError) || other.actionError == actionError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,profile,loadingProfile,profileError,const DeepCollectionEquality().hash(_watches),loadingWatches,watchesError,unpairing,unpairedCount,actionError);
}

@override
String toString() {
    return 'ProfileState(profile: $profile, loadingProfile: $loadingProfile, profileError: $profileError, watches: $watches, loadingWatches: $loadingWatches, watchesError: $watchesError, unpairing: $unpairing, unpairedCount: $unpairedCount, actionError: $actionError)';
}


}

/// @nodoc
abstract mixin class _$ProfileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory _$ProfileStateCopyWith(_ProfileState value, $Res Function(_ProfileState) _then) = __$ProfileStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileDto? profile, bool loadingProfile, Failure? profileError, List<PairedWatchDto> watches, bool loadingWatches, Failure? watchesError, String? unpairing, int unpairedCount, Failure? actionError
});


@override $ProfileDtoCopyWith<$Res>? get profile;

}
/// @nodoc
class __$ProfileStateCopyWithImpl<$Res>
    implements _$ProfileStateCopyWith<$Res> {
  __$ProfileStateCopyWithImpl(this._self, this._then);

  final _ProfileState _self;
  final $Res Function(_ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? loadingProfile = null,Object? profileError = freezed,Object? watches = null,Object? loadingWatches = null,Object? watchesError = freezed,Object? unpairing = freezed,Object? unpairedCount = null,Object? actionError = freezed,}) {
  return _then(_ProfileState(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProfileDto?,loadingProfile: null == loadingProfile ? _self.loadingProfile : loadingProfile // ignore: cast_nullable_to_non_nullable
as bool,profileError: freezed == profileError ? _self.profileError : profileError // ignore: cast_nullable_to_non_nullable
as Failure?,watches: null == watches ? _self._watches : watches // ignore: cast_nullable_to_non_nullable
as List<PairedWatchDto>,loadingWatches: null == loadingWatches ? _self.loadingWatches : loadingWatches // ignore: cast_nullable_to_non_nullable
as bool,watchesError: freezed == watchesError ? _self.watchesError : watchesError // ignore: cast_nullable_to_non_nullable
as Failure?,unpairing: freezed == unpairing ? _self.unpairing : unpairing // ignore: cast_nullable_to_non_nullable
as String?,unpairedCount: null == unpairedCount ? _self.unpairedCount : unpairedCount // ignore: cast_nullable_to_non_nullable
as int,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileDtoCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProfileDtoCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
