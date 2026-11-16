// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'availability_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CheckInDto {

 String get outcome; String? get shift; String? get date; DateTime? get checkedInAt;
/// Create a copy of CheckInDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckInDtoCopyWith<CheckInDto> get copyWith => _$CheckInDtoCopyWithImpl<CheckInDto>(this as CheckInDto, _$identity);

  /// Serializes this CheckInDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CheckInDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckInDto&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CheckInDto;
  return Object.hash(runtimeType,_this.outcome,_this.shift,_this.date,_this.checkedInAt);
}

@override
String toString() {
  final _this = this as CheckInDto;
  return 'CheckInDto(outcome: ${_this.outcome}, shift: ${_this.shift}, date: ${_this.date}, checkedInAt: ${_this.checkedInAt})';
}


}

/// @nodoc
abstract mixin class $CheckInDtoCopyWith<$Res>  {
  factory $CheckInDtoCopyWith(CheckInDto value, $Res Function(CheckInDto) _then) = _$CheckInDtoCopyWithImpl;
@useResult
$Res call({
 String outcome, String? shift, String? date, DateTime? checkedInAt
});




}
/// @nodoc
class _$CheckInDtoCopyWithImpl<$Res>
    implements $CheckInDtoCopyWith<$Res> {
  _$CheckInDtoCopyWithImpl(this._self, this._then);

  final CheckInDto _self;
  final $Res Function(CheckInDto) _then;

/// Create a copy of CheckInDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outcome = null,Object? shift = freezed,Object? date = freezed,Object? checkedInAt = freezed,}) {
  return _then(CheckInDto(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckInDto].
extension CheckInDtoPatterns on CheckInDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckInDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckInDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckInDto value)  $default,){
final _that = this;
switch (_that) {
case _CheckInDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckInDto value)?  $default,){
final _that = this;
switch (_that) {
case _CheckInDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String outcome,  String? shift,  String? date,  DateTime? checkedInAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckInDto() when $default != null:
return $default(_that.outcome,_that.shift,_that.date,_that.checkedInAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String outcome,  String? shift,  String? date,  DateTime? checkedInAt)  $default,) {final _that = this;
switch (_that) {
case _CheckInDto():
return $default(_that.outcome,_that.shift,_that.date,_that.checkedInAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String outcome,  String? shift,  String? date,  DateTime? checkedInAt)?  $default,) {final _that = this;
switch (_that) {
case _CheckInDto() when $default != null:
return $default(_that.outcome,_that.shift,_that.date,_that.checkedInAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckInDto implements CheckInDto {
  const _CheckInDto({required this.outcome, this.shift, this.date, this.checkedInAt});
  factory _CheckInDto.fromJson(Map<String, dynamic> json) => _$CheckInDtoFromJson(json);

@override final  String outcome;
@override final  String? shift;
@override final  String? date;
@override final  DateTime? checkedInAt;

/// Create a copy of CheckInDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckInDtoCopyWith<_CheckInDto> get copyWith => __$CheckInDtoCopyWithImpl<_CheckInDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckInDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckInDto&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.date, date) || other.date == date)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,outcome,shift,date,checkedInAt);
}

@override
String toString() {
    return 'CheckInDto(outcome: $outcome, shift: $shift, date: $date, checkedInAt: $checkedInAt)';
}


}

/// @nodoc
abstract mixin class _$CheckInDtoCopyWith<$Res> implements $CheckInDtoCopyWith<$Res> {
  factory _$CheckInDtoCopyWith(_CheckInDto value, $Res Function(_CheckInDto) _then) = __$CheckInDtoCopyWithImpl;
@override @useResult
$Res call({
 String outcome, String? shift, String? date, DateTime? checkedInAt
});




}
/// @nodoc
class __$CheckInDtoCopyWithImpl<$Res>
    implements _$CheckInDtoCopyWith<$Res> {
  __$CheckInDtoCopyWithImpl(this._self, this._then);

  final _CheckInDto _self;
  final $Res Function(_CheckInDto) _then;

/// Create a copy of CheckInDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outcome = null,Object? shift = freezed,Object? date = freezed,Object? checkedInAt = freezed,}) {
  return _then(_CheckInDto(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String?,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CheckOutDto {

 String get outcome; String? get shift; DateTime? get checkedInAt;
/// Create a copy of CheckOutDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckOutDtoCopyWith<CheckOutDto> get copyWith => _$CheckOutDtoCopyWithImpl<CheckOutDto>(this as CheckOutDto, _$identity);

  /// Serializes this CheckOutDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CheckOutDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CheckOutDto&&(identical(other.outcome, _this.outcome) || other.outcome == _this.outcome)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CheckOutDto;
  return Object.hash(runtimeType,_this.outcome,_this.shift,_this.checkedInAt);
}

@override
String toString() {
  final _this = this as CheckOutDto;
  return 'CheckOutDto(outcome: ${_this.outcome}, shift: ${_this.shift}, checkedInAt: ${_this.checkedInAt})';
}


}

/// @nodoc
abstract mixin class $CheckOutDtoCopyWith<$Res>  {
  factory $CheckOutDtoCopyWith(CheckOutDto value, $Res Function(CheckOutDto) _then) = _$CheckOutDtoCopyWithImpl;
@useResult
$Res call({
 String outcome, String? shift, DateTime? checkedInAt
});




}
/// @nodoc
class _$CheckOutDtoCopyWithImpl<$Res>
    implements $CheckOutDtoCopyWith<$Res> {
  _$CheckOutDtoCopyWithImpl(this._self, this._then);

  final CheckOutDto _self;
  final $Res Function(CheckOutDto) _then;

/// Create a copy of CheckOutDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? outcome = null,Object? shift = freezed,Object? checkedInAt = freezed,}) {
  return _then(CheckOutDto(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CheckOutDto].
extension CheckOutDtoPatterns on CheckOutDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CheckOutDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CheckOutDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CheckOutDto value)  $default,){
final _that = this;
switch (_that) {
case _CheckOutDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CheckOutDto value)?  $default,){
final _that = this;
switch (_that) {
case _CheckOutDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String outcome,  String? shift,  DateTime? checkedInAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CheckOutDto() when $default != null:
return $default(_that.outcome,_that.shift,_that.checkedInAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String outcome,  String? shift,  DateTime? checkedInAt)  $default,) {final _that = this;
switch (_that) {
case _CheckOutDto():
return $default(_that.outcome,_that.shift,_that.checkedInAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String outcome,  String? shift,  DateTime? checkedInAt)?  $default,) {final _that = this;
switch (_that) {
case _CheckOutDto() when $default != null:
return $default(_that.outcome,_that.shift,_that.checkedInAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CheckOutDto implements CheckOutDto {
  const _CheckOutDto({required this.outcome, this.shift, this.checkedInAt});
  factory _CheckOutDto.fromJson(Map<String, dynamic> json) => _$CheckOutDtoFromJson(json);

@override final  String outcome;
@override final  String? shift;
@override final  DateTime? checkedInAt;

/// Create a copy of CheckOutDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckOutDtoCopyWith<_CheckOutDto> get copyWith => __$CheckOutDtoCopyWithImpl<_CheckOutDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckOutDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckOutDto&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,outcome,shift,checkedInAt);
}

@override
String toString() {
    return 'CheckOutDto(outcome: $outcome, shift: $shift, checkedInAt: $checkedInAt)';
}


}

/// @nodoc
abstract mixin class _$CheckOutDtoCopyWith<$Res> implements $CheckOutDtoCopyWith<$Res> {
  factory _$CheckOutDtoCopyWith(_CheckOutDto value, $Res Function(_CheckOutDto) _then) = __$CheckOutDtoCopyWithImpl;
@override @useResult
$Res call({
 String outcome, String? shift, DateTime? checkedInAt
});




}
/// @nodoc
class __$CheckOutDtoCopyWithImpl<$Res>
    implements _$CheckOutDtoCopyWith<$Res> {
  __$CheckOutDtoCopyWithImpl(this._self, this._then);

  final _CheckOutDto _self;
  final $Res Function(_CheckOutDto) _then;

/// Create a copy of CheckOutDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? outcome = null,Object? shift = freezed,Object? checkedInAt = freezed,}) {
  return _then(_CheckOutDto(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AttendanceDto {

 String get id;/// `YYYY-MM-DD`, the shift date.
 String get date; String? get shift;/// `OPEN` while still checked in, else `CLOSED`.
 String get status; DateTime? get checkedInAt; DateTime? get checkedOutAt; int? get workedMinutes; bool get isAvailable; bool get isOnBreak;
/// Create a copy of AttendanceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceDtoCopyWith<AttendanceDto> get copyWith => _$AttendanceDtoCopyWithImpl<AttendanceDto>(this as AttendanceDto, _$identity);

  /// Serializes this AttendanceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendanceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.checkedInAt, _this.checkedInAt) || other.checkedInAt == _this.checkedInAt)&&(identical(other.checkedOutAt, _this.checkedOutAt) || other.checkedOutAt == _this.checkedOutAt)&&(identical(other.workedMinutes, _this.workedMinutes) || other.workedMinutes == _this.workedMinutes)&&(identical(other.isAvailable, _this.isAvailable) || other.isAvailable == _this.isAvailable)&&(identical(other.isOnBreak, _this.isOnBreak) || other.isOnBreak == _this.isOnBreak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendanceDto;
  return Object.hash(runtimeType,_this.id,_this.date,_this.shift,_this.status,_this.checkedInAt,_this.checkedOutAt,_this.workedMinutes,_this.isAvailable,_this.isOnBreak);
}

@override
String toString() {
  final _this = this as AttendanceDto;
  return 'AttendanceDto(id: ${_this.id}, date: ${_this.date}, shift: ${_this.shift}, status: ${_this.status}, checkedInAt: ${_this.checkedInAt}, checkedOutAt: ${_this.checkedOutAt}, workedMinutes: ${_this.workedMinutes}, isAvailable: ${_this.isAvailable}, isOnBreak: ${_this.isOnBreak})';
}


}

/// @nodoc
abstract mixin class $AttendanceDtoCopyWith<$Res>  {
  factory $AttendanceDtoCopyWith(AttendanceDto value, $Res Function(AttendanceDto) _then) = _$AttendanceDtoCopyWithImpl;
@useResult
$Res call({
 String id, String date, String? shift, String status, DateTime? checkedInAt, DateTime? checkedOutAt, int? workedMinutes, bool isAvailable, bool isOnBreak
});




}
/// @nodoc
class _$AttendanceDtoCopyWithImpl<$Res>
    implements $AttendanceDtoCopyWith<$Res> {
  _$AttendanceDtoCopyWithImpl(this._self, this._then);

  final AttendanceDto _self;
  final $Res Function(AttendanceDto) _then;

/// Create a copy of AttendanceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? shift = freezed,Object? status = null,Object? checkedInAt = freezed,Object? checkedOutAt = freezed,Object? workedMinutes = freezed,Object? isAvailable = null,Object? isOnBreak = null,}) {
  return _then(AttendanceDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedOutAt: freezed == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isOnBreak: null == isOnBreak ? _self.isOnBreak : isOnBreak // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceDto].
extension AttendanceDtoPatterns on AttendanceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceDto value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceDto value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String date,  String? shift,  String status,  DateTime? checkedInAt,  DateTime? checkedOutAt,  int? workedMinutes,  bool isAvailable,  bool isOnBreak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceDto() when $default != null:
return $default(_that.id,_that.date,_that.shift,_that.status,_that.checkedInAt,_that.checkedOutAt,_that.workedMinutes,_that.isAvailable,_that.isOnBreak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String date,  String? shift,  String status,  DateTime? checkedInAt,  DateTime? checkedOutAt,  int? workedMinutes,  bool isAvailable,  bool isOnBreak)  $default,) {final _that = this;
switch (_that) {
case _AttendanceDto():
return $default(_that.id,_that.date,_that.shift,_that.status,_that.checkedInAt,_that.checkedOutAt,_that.workedMinutes,_that.isAvailable,_that.isOnBreak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String date,  String? shift,  String status,  DateTime? checkedInAt,  DateTime? checkedOutAt,  int? workedMinutes,  bool isAvailable,  bool isOnBreak)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceDto() when $default != null:
return $default(_that.id,_that.date,_that.shift,_that.status,_that.checkedInAt,_that.checkedOutAt,_that.workedMinutes,_that.isAvailable,_that.isOnBreak);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceDto extends AttendanceDto {
  const _AttendanceDto({required this.id, required this.date, this.shift, this.status = 'CLOSED', this.checkedInAt, this.checkedOutAt, this.workedMinutes, this.isAvailable = false, this.isOnBreak = false}): super._();
  factory _AttendanceDto.fromJson(Map<String, dynamic> json) => _$AttendanceDtoFromJson(json);

@override final  String id;
/// `YYYY-MM-DD`, the shift date.
@override final  String date;
@override final  String? shift;
/// `OPEN` while still checked in, else `CLOSED`.
@override@JsonKey() final  String status;
@override final  DateTime? checkedInAt;
@override final  DateTime? checkedOutAt;
@override final  int? workedMinutes;
@override@JsonKey() final  bool isAvailable;
@override@JsonKey() final  bool isOnBreak;

/// Create a copy of AttendanceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceDtoCopyWith<_AttendanceDto> get copyWith => __$AttendanceDtoCopyWithImpl<_AttendanceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceDto&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.status, status) || other.status == status)&&(identical(other.checkedInAt, checkedInAt) || other.checkedInAt == checkedInAt)&&(identical(other.checkedOutAt, checkedOutAt) || other.checkedOutAt == checkedOutAt)&&(identical(other.workedMinutes, workedMinutes) || other.workedMinutes == workedMinutes)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isOnBreak, isOnBreak) || other.isOnBreak == isOnBreak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,date,shift,status,checkedInAt,checkedOutAt,workedMinutes,isAvailable,isOnBreak);
}

@override
String toString() {
    return 'AttendanceDto(id: $id, date: $date, shift: $shift, status: $status, checkedInAt: $checkedInAt, checkedOutAt: $checkedOutAt, workedMinutes: $workedMinutes, isAvailable: $isAvailable, isOnBreak: $isOnBreak)';
}


}

/// @nodoc
abstract mixin class _$AttendanceDtoCopyWith<$Res> implements $AttendanceDtoCopyWith<$Res> {
  factory _$AttendanceDtoCopyWith(_AttendanceDto value, $Res Function(_AttendanceDto) _then) = __$AttendanceDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String date, String? shift, String status, DateTime? checkedInAt, DateTime? checkedOutAt, int? workedMinutes, bool isAvailable, bool isOnBreak
});




}
/// @nodoc
class __$AttendanceDtoCopyWithImpl<$Res>
    implements _$AttendanceDtoCopyWith<$Res> {
  __$AttendanceDtoCopyWithImpl(this._self, this._then);

  final _AttendanceDto _self;
  final $Res Function(_AttendanceDto) _then;

/// Create a copy of AttendanceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? shift = freezed,Object? status = null,Object? checkedInAt = freezed,Object? checkedOutAt = freezed,Object? workedMinutes = freezed,Object? isAvailable = null,Object? isOnBreak = null,}) {
  return _then(_AttendanceDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,checkedInAt: freezed == checkedInAt ? _self.checkedInAt : checkedInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,checkedOutAt: freezed == checkedOutAt ? _self.checkedOutAt : checkedOutAt // ignore: cast_nullable_to_non_nullable
as DateTime?,workedMinutes: freezed == workedMinutes ? _self.workedMinutes : workedMinutes // ignore: cast_nullable_to_non_nullable
as int?,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isOnBreak: null == isOnBreak ? _self.isOnBreak : isOnBreak // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$AttendancePageDto {

 List<AttendanceDto> get items; PaginationDto get pagination;
/// Create a copy of AttendancePageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendancePageDtoCopyWith<AttendancePageDto> get copyWith => _$AttendancePageDtoCopyWithImpl<AttendancePageDto>(this as AttendancePageDto, _$identity);

  /// Serializes this AttendancePageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttendancePageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendancePageDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.pagination, _this.pagination) || other.pagination == _this.pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttendancePageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.pagination);
}

@override
String toString() {
  final _this = this as AttendancePageDto;
  return 'AttendancePageDto(items: ${_this.items}, pagination: ${_this.pagination})';
}


}

/// @nodoc
abstract mixin class $AttendancePageDtoCopyWith<$Res>  {
  factory $AttendancePageDtoCopyWith(AttendancePageDto value, $Res Function(AttendancePageDto) _then) = _$AttendancePageDtoCopyWithImpl;
@useResult
$Res call({
 List<AttendanceDto> items, PaginationDto pagination
});


$PaginationDtoCopyWith<$Res> get pagination;

}
/// @nodoc
class _$AttendancePageDtoCopyWithImpl<$Res>
    implements $AttendancePageDtoCopyWith<$Res> {
  _$AttendancePageDtoCopyWithImpl(this._self, this._then);

  final AttendancePageDto _self;
  final $Res Function(AttendancePageDto) _then;

/// Create a copy of AttendancePageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(AttendancePageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceDto>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationDto,
  ));
}
/// Create a copy of AttendancePageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationDtoCopyWith<$Res> get pagination {
  
  return $PaginationDtoCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttendancePageDto].
extension AttendancePageDtoPatterns on AttendancePageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendancePageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendancePageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendancePageDto value)  $default,){
final _that = this;
switch (_that) {
case _AttendancePageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendancePageDto value)?  $default,){
final _that = this;
switch (_that) {
case _AttendancePageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AttendanceDto> items,  PaginationDto pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendancePageDto() when $default != null:
return $default(_that.items,_that.pagination);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AttendanceDto> items,  PaginationDto pagination)  $default,) {final _that = this;
switch (_that) {
case _AttendancePageDto():
return $default(_that.items,_that.pagination);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AttendanceDto> items,  PaginationDto pagination)?  $default,) {final _that = this;
switch (_that) {
case _AttendancePageDto() when $default != null:
return $default(_that.items,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendancePageDto implements AttendancePageDto {
  const _AttendancePageDto({ List<AttendanceDto> items = const <AttendanceDto>[], this.pagination = const PaginationDto()}): _items = items;
  factory _AttendancePageDto.fromJson(Map<String, dynamic> json) => _$AttendancePageDtoFromJson(json);

 final  List<AttendanceDto> _items;
@override@JsonKey() List<AttendanceDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  PaginationDto pagination;

/// Create a copy of AttendancePageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendancePageDtoCopyWith<_AttendancePageDto> get copyWith => __$AttendancePageDtoCopyWithImpl<_AttendancePageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendancePageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendancePageDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pagination);
}

@override
String toString() {
    return 'AttendancePageDto(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$AttendancePageDtoCopyWith<$Res> implements $AttendancePageDtoCopyWith<$Res> {
  factory _$AttendancePageDtoCopyWith(_AttendancePageDto value, $Res Function(_AttendancePageDto) _then) = __$AttendancePageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<AttendanceDto> items, PaginationDto pagination
});


@override $PaginationDtoCopyWith<$Res> get pagination;

}
/// @nodoc
class __$AttendancePageDtoCopyWithImpl<$Res>
    implements _$AttendancePageDtoCopyWith<$Res> {
  __$AttendancePageDtoCopyWithImpl(this._self, this._then);

  final _AttendancePageDto _self;
  final $Res Function(_AttendancePageDto) _then;

/// Create a copy of AttendancePageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_AttendancePageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<AttendanceDto>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationDto,
  ));
}

/// Create a copy of AttendancePageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationDtoCopyWith<$Res> get pagination {
  
  return $PaginationDtoCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}

// dart format on
