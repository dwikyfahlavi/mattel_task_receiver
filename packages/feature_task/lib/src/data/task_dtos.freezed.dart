// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_dtos.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MachineDto {

 String get id; String? get cellPosition;/// Detail endpoint only.
 String? get type;
/// Create a copy of MachineDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MachineDtoCopyWith<MachineDto> get copyWith => _$MachineDtoCopyWithImpl<MachineDto>(this as MachineDto, _$identity);

  /// Serializes this MachineDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MachineDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MachineDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.cellPosition, _this.cellPosition) || other.cellPosition == _this.cellPosition)&&(identical(other.type, _this.type) || other.type == _this.type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MachineDto;
  return Object.hash(runtimeType,_this.id,_this.cellPosition,_this.type);
}

@override
String toString() {
  final _this = this as MachineDto;
  return 'MachineDto(id: ${_this.id}, cellPosition: ${_this.cellPosition}, type: ${_this.type})';
}


}

/// @nodoc
abstract mixin class $MachineDtoCopyWith<$Res>  {
  factory $MachineDtoCopyWith(MachineDto value, $Res Function(MachineDto) _then) = _$MachineDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? cellPosition, String? type
});




}
/// @nodoc
class _$MachineDtoCopyWithImpl<$Res>
    implements $MachineDtoCopyWith<$Res> {
  _$MachineDtoCopyWithImpl(this._self, this._then);

  final MachineDto _self;
  final $Res Function(MachineDto) _then;

/// Create a copy of MachineDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? cellPosition = freezed,Object? type = freezed,}) {
  return _then(MachineDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cellPosition: freezed == cellPosition ? _self.cellPosition : cellPosition // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MachineDto].
extension MachineDtoPatterns on MachineDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MachineDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MachineDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MachineDto value)  $default,){
final _that = this;
switch (_that) {
case _MachineDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MachineDto value)?  $default,){
final _that = this;
switch (_that) {
case _MachineDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? cellPosition,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MachineDto() when $default != null:
return $default(_that.id,_that.cellPosition,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? cellPosition,  String? type)  $default,) {final _that = this;
switch (_that) {
case _MachineDto():
return $default(_that.id,_that.cellPosition,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? cellPosition,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _MachineDto() when $default != null:
return $default(_that.id,_that.cellPosition,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MachineDto implements MachineDto {
  const _MachineDto({required this.id, this.cellPosition, this.type});
  factory _MachineDto.fromJson(Map<String, dynamic> json) => _$MachineDtoFromJson(json);

@override final  String id;
@override final  String? cellPosition;
/// Detail endpoint only.
@override final  String? type;

/// Create a copy of MachineDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MachineDtoCopyWith<_MachineDto> get copyWith => __$MachineDtoCopyWithImpl<_MachineDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MachineDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MachineDto&&(identical(other.id, id) || other.id == id)&&(identical(other.cellPosition, cellPosition) || other.cellPosition == cellPosition)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,cellPosition,type);
}

@override
String toString() {
    return 'MachineDto(id: $id, cellPosition: $cellPosition, type: $type)';
}


}

/// @nodoc
abstract mixin class _$MachineDtoCopyWith<$Res> implements $MachineDtoCopyWith<$Res> {
  factory _$MachineDtoCopyWith(_MachineDto value, $Res Function(_MachineDto) _then) = __$MachineDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? cellPosition, String? type
});




}
/// @nodoc
class __$MachineDtoCopyWithImpl<$Res>
    implements _$MachineDtoCopyWith<$Res> {
  __$MachineDtoCopyWithImpl(this._self, this._then);

  final _MachineDto _self;
  final $Res Function(_MachineDto) _then;

/// Create a copy of MachineDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? cellPosition = freezed,Object? type = freezed,}) {
  return _then(_MachineDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,cellPosition: freezed == cellPosition ? _self.cellPosition : cellPosition // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RepairDto {

 String? get reason; DateTime? get problemStartedAt; DateTime? get actionStartedAt; DateTime? get finishedAt;
/// Create a copy of RepairDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RepairDtoCopyWith<RepairDto> get copyWith => _$RepairDtoCopyWithImpl<RepairDto>(this as RepairDto, _$identity);

  /// Serializes this RepairDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RepairDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RepairDto&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.problemStartedAt, _this.problemStartedAt) || other.problemStartedAt == _this.problemStartedAt)&&(identical(other.actionStartedAt, _this.actionStartedAt) || other.actionStartedAt == _this.actionStartedAt)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RepairDto;
  return Object.hash(runtimeType,_this.reason,_this.problemStartedAt,_this.actionStartedAt,_this.finishedAt);
}

@override
String toString() {
  final _this = this as RepairDto;
  return 'RepairDto(reason: ${_this.reason}, problemStartedAt: ${_this.problemStartedAt}, actionStartedAt: ${_this.actionStartedAt}, finishedAt: ${_this.finishedAt})';
}


}

/// @nodoc
abstract mixin class $RepairDtoCopyWith<$Res>  {
  factory $RepairDtoCopyWith(RepairDto value, $Res Function(RepairDto) _then) = _$RepairDtoCopyWithImpl;
@useResult
$Res call({
 String? reason, DateTime? problemStartedAt, DateTime? actionStartedAt, DateTime? finishedAt
});




}
/// @nodoc
class _$RepairDtoCopyWithImpl<$Res>
    implements $RepairDtoCopyWith<$Res> {
  _$RepairDtoCopyWithImpl(this._self, this._then);

  final RepairDto _self;
  final $Res Function(RepairDto) _then;

/// Create a copy of RepairDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = freezed,Object? problemStartedAt = freezed,Object? actionStartedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(RepairDto(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,problemStartedAt: freezed == problemStartedAt ? _self.problemStartedAt : problemStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actionStartedAt: freezed == actionStartedAt ? _self.actionStartedAt : actionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RepairDto].
extension RepairDtoPatterns on RepairDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RepairDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RepairDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RepairDto value)  $default,){
final _that = this;
switch (_that) {
case _RepairDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RepairDto value)?  $default,){
final _that = this;
switch (_that) {
case _RepairDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? reason,  DateTime? problemStartedAt,  DateTime? actionStartedAt,  DateTime? finishedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RepairDto() when $default != null:
return $default(_that.reason,_that.problemStartedAt,_that.actionStartedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? reason,  DateTime? problemStartedAt,  DateTime? actionStartedAt,  DateTime? finishedAt)  $default,) {final _that = this;
switch (_that) {
case _RepairDto():
return $default(_that.reason,_that.problemStartedAt,_that.actionStartedAt,_that.finishedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? reason,  DateTime? problemStartedAt,  DateTime? actionStartedAt,  DateTime? finishedAt)?  $default,) {final _that = this;
switch (_that) {
case _RepairDto() when $default != null:
return $default(_that.reason,_that.problemStartedAt,_that.actionStartedAt,_that.finishedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RepairDto implements RepairDto {
  const _RepairDto({this.reason, this.problemStartedAt, this.actionStartedAt, this.finishedAt});
  factory _RepairDto.fromJson(Map<String, dynamic> json) => _$RepairDtoFromJson(json);

@override final  String? reason;
@override final  DateTime? problemStartedAt;
@override final  DateTime? actionStartedAt;
@override final  DateTime? finishedAt;

/// Create a copy of RepairDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RepairDtoCopyWith<_RepairDto> get copyWith => __$RepairDtoCopyWithImpl<_RepairDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RepairDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RepairDto&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.problemStartedAt, problemStartedAt) || other.problemStartedAt == problemStartedAt)&&(identical(other.actionStartedAt, actionStartedAt) || other.actionStartedAt == actionStartedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,reason,problemStartedAt,actionStartedAt,finishedAt);
}

@override
String toString() {
    return 'RepairDto(reason: $reason, problemStartedAt: $problemStartedAt, actionStartedAt: $actionStartedAt, finishedAt: $finishedAt)';
}


}

/// @nodoc
abstract mixin class _$RepairDtoCopyWith<$Res> implements $RepairDtoCopyWith<$Res> {
  factory _$RepairDtoCopyWith(_RepairDto value, $Res Function(_RepairDto) _then) = __$RepairDtoCopyWithImpl;
@override @useResult
$Res call({
 String? reason, DateTime? problemStartedAt, DateTime? actionStartedAt, DateTime? finishedAt
});




}
/// @nodoc
class __$RepairDtoCopyWithImpl<$Res>
    implements _$RepairDtoCopyWith<$Res> {
  __$RepairDtoCopyWithImpl(this._self, this._then);

  final _RepairDto _self;
  final $Res Function(_RepairDto) _then;

/// Create a copy of RepairDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = freezed,Object? problemStartedAt = freezed,Object? actionStartedAt = freezed,Object? finishedAt = freezed,}) {
  return _then(_RepairDto(
reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,problemStartedAt: freezed == problemStartedAt ? _self.problemStartedAt : problemStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,actionStartedAt: freezed == actionStartedAt ? _self.actionStartedAt : actionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,finishedAt: freezed == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WorkOrderDto {

 String get id; String? get requestId; String? get status; String? get shift; DateTime get createdAt; DateTime? get respondBy; MachineDto get machine; String get issue;/// Detail endpoint only.
 String? get issueAction; String? get repairId;@JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown) WorkOrderDisplayStatus get displayStatus; DateTime? get updatedAt; RepairDto? get repair;
/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderDtoCopyWith<WorkOrderDto> get copyWith => _$WorkOrderDtoCopyWithImpl<WorkOrderDto>(this as WorkOrderDto, _$identity);

  /// Serializes this WorkOrderDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkOrderDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderDto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.respondBy, _this.respondBy) || other.respondBy == _this.respondBy)&&(identical(other.machine, _this.machine) || other.machine == _this.machine)&&(identical(other.issue, _this.issue) || other.issue == _this.issue)&&(identical(other.issueAction, _this.issueAction) || other.issueAction == _this.issueAction)&&(identical(other.repairId, _this.repairId) || other.repairId == _this.repairId)&&(identical(other.displayStatus, _this.displayStatus) || other.displayStatus == _this.displayStatus)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.repair, _this.repair) || other.repair == _this.repair));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkOrderDto;
  return Object.hash(runtimeType,_this.id,_this.requestId,_this.status,_this.shift,_this.createdAt,_this.respondBy,_this.machine,_this.issue,_this.issueAction,_this.repairId,_this.displayStatus,_this.updatedAt,_this.repair);
}

@override
String toString() {
  final _this = this as WorkOrderDto;
  return 'WorkOrderDto(id: ${_this.id}, requestId: ${_this.requestId}, status: ${_this.status}, shift: ${_this.shift}, createdAt: ${_this.createdAt}, respondBy: ${_this.respondBy}, machine: ${_this.machine}, issue: ${_this.issue}, issueAction: ${_this.issueAction}, repairId: ${_this.repairId}, displayStatus: ${_this.displayStatus}, updatedAt: ${_this.updatedAt}, repair: ${_this.repair})';
}


}

/// @nodoc
abstract mixin class $WorkOrderDtoCopyWith<$Res>  {
  factory $WorkOrderDtoCopyWith(WorkOrderDto value, $Res Function(WorkOrderDto) _then) = _$WorkOrderDtoCopyWithImpl;
@useResult
$Res call({
 String id, String? requestId, String? status, String? shift, DateTime createdAt, DateTime? respondBy, MachineDto machine, String issue, String? issueAction, String? repairId,@JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown) WorkOrderDisplayStatus displayStatus, DateTime? updatedAt, RepairDto? repair
});


$MachineDtoCopyWith<$Res> get machine;$RepairDtoCopyWith<$Res>? get repair;

}
/// @nodoc
class _$WorkOrderDtoCopyWithImpl<$Res>
    implements $WorkOrderDtoCopyWith<$Res> {
  _$WorkOrderDtoCopyWithImpl(this._self, this._then);

  final WorkOrderDto _self;
  final $Res Function(WorkOrderDto) _then;

/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? requestId = freezed,Object? status = freezed,Object? shift = freezed,Object? createdAt = null,Object? respondBy = freezed,Object? machine = null,Object? issue = null,Object? issueAction = freezed,Object? repairId = freezed,Object? displayStatus = null,Object? updatedAt = freezed,Object? repair = freezed,}) {
  return _then(WorkOrderDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondBy: freezed == respondBy ? _self.respondBy : respondBy // ignore: cast_nullable_to_non_nullable
as DateTime?,machine: null == machine ? _self.machine : machine // ignore: cast_nullable_to_non_nullable
as MachineDto,issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as String,issueAction: freezed == issueAction ? _self.issueAction : issueAction // ignore: cast_nullable_to_non_nullable
as String?,repairId: freezed == repairId ? _self.repairId : repairId // ignore: cast_nullable_to_non_nullable
as String?,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as WorkOrderDisplayStatus,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,repair: freezed == repair ? _self.repair : repair // ignore: cast_nullable_to_non_nullable
as RepairDto?,
  ));
}
/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MachineDtoCopyWith<$Res> get machine {
  
  return $MachineDtoCopyWith<$Res>(_self.machine, (value) {
    return _then(_self.copyWith(machine: value));
  });
}/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RepairDtoCopyWith<$Res>? get repair {
    if (_self.repair == null) {
    return null;
  }

  return $RepairDtoCopyWith<$Res>(_self.repair!, (value) {
    return _then(_self.copyWith(repair: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkOrderDto].
extension WorkOrderDtoPatterns on WorkOrderDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrderDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrderDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrderDto value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrderDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrderDto value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrderDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? requestId,  String? status,  String? shift,  DateTime createdAt,  DateTime? respondBy,  MachineDto machine,  String issue,  String? issueAction,  String? repairId, @JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown)  WorkOrderDisplayStatus displayStatus,  DateTime? updatedAt,  RepairDto? repair)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrderDto() when $default != null:
return $default(_that.id,_that.requestId,_that.status,_that.shift,_that.createdAt,_that.respondBy,_that.machine,_that.issue,_that.issueAction,_that.repairId,_that.displayStatus,_that.updatedAt,_that.repair);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? requestId,  String? status,  String? shift,  DateTime createdAt,  DateTime? respondBy,  MachineDto machine,  String issue,  String? issueAction,  String? repairId, @JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown)  WorkOrderDisplayStatus displayStatus,  DateTime? updatedAt,  RepairDto? repair)  $default,) {final _that = this;
switch (_that) {
case _WorkOrderDto():
return $default(_that.id,_that.requestId,_that.status,_that.shift,_that.createdAt,_that.respondBy,_that.machine,_that.issue,_that.issueAction,_that.repairId,_that.displayStatus,_that.updatedAt,_that.repair);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? requestId,  String? status,  String? shift,  DateTime createdAt,  DateTime? respondBy,  MachineDto machine,  String issue,  String? issueAction,  String? repairId, @JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown)  WorkOrderDisplayStatus displayStatus,  DateTime? updatedAt,  RepairDto? repair)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrderDto() when $default != null:
return $default(_that.id,_that.requestId,_that.status,_that.shift,_that.createdAt,_that.respondBy,_that.machine,_that.issue,_that.issueAction,_that.repairId,_that.displayStatus,_that.updatedAt,_that.repair);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrderDto extends WorkOrderDto {
  const _WorkOrderDto({required this.id, this.requestId, this.status, this.shift, required this.createdAt, this.respondBy, required this.machine, this.issue = '', this.issueAction, this.repairId, @JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown) this.displayStatus = WorkOrderDisplayStatus.unknown, this.updatedAt, this.repair}): super._();
  factory _WorkOrderDto.fromJson(Map<String, dynamic> json) => _$WorkOrderDtoFromJson(json);

@override final  String id;
@override final  String? requestId;
@override final  String? status;
@override final  String? shift;
@override final  DateTime createdAt;
@override final  DateTime? respondBy;
@override final  MachineDto machine;
@override@JsonKey() final  String issue;
/// Detail endpoint only.
@override final  String? issueAction;
@override final  String? repairId;
@override@JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown) final  WorkOrderDisplayStatus displayStatus;
@override final  DateTime? updatedAt;
@override final  RepairDto? repair;

/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderDtoCopyWith<_WorkOrderDto> get copyWith => __$WorkOrderDtoCopyWithImpl<_WorkOrderDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrderDto&&(identical(other.id, id) || other.id == id)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.status, status) || other.status == status)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.respondBy, respondBy) || other.respondBy == respondBy)&&(identical(other.machine, machine) || other.machine == machine)&&(identical(other.issue, issue) || other.issue == issue)&&(identical(other.issueAction, issueAction) || other.issueAction == issueAction)&&(identical(other.repairId, repairId) || other.repairId == repairId)&&(identical(other.displayStatus, displayStatus) || other.displayStatus == displayStatus)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.repair, repair) || other.repair == repair));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,requestId,status,shift,createdAt,respondBy,machine,issue,issueAction,repairId,displayStatus,updatedAt,repair);
}

@override
String toString() {
    return 'WorkOrderDto(id: $id, requestId: $requestId, status: $status, shift: $shift, createdAt: $createdAt, respondBy: $respondBy, machine: $machine, issue: $issue, issueAction: $issueAction, repairId: $repairId, displayStatus: $displayStatus, updatedAt: $updatedAt, repair: $repair)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderDtoCopyWith<$Res> implements $WorkOrderDtoCopyWith<$Res> {
  factory _$WorkOrderDtoCopyWith(_WorkOrderDto value, $Res Function(_WorkOrderDto) _then) = __$WorkOrderDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String? requestId, String? status, String? shift, DateTime createdAt, DateTime? respondBy, MachineDto machine, String issue, String? issueAction, String? repairId,@JsonKey(unknownEnumValue: WorkOrderDisplayStatus.unknown) WorkOrderDisplayStatus displayStatus, DateTime? updatedAt, RepairDto? repair
});


@override $MachineDtoCopyWith<$Res> get machine;@override $RepairDtoCopyWith<$Res>? get repair;

}
/// @nodoc
class __$WorkOrderDtoCopyWithImpl<$Res>
    implements _$WorkOrderDtoCopyWith<$Res> {
  __$WorkOrderDtoCopyWithImpl(this._self, this._then);

  final _WorkOrderDto _self;
  final $Res Function(_WorkOrderDto) _then;

/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? requestId = freezed,Object? status = freezed,Object? shift = freezed,Object? createdAt = null,Object? respondBy = freezed,Object? machine = null,Object? issue = null,Object? issueAction = freezed,Object? repairId = freezed,Object? displayStatus = null,Object? updatedAt = freezed,Object? repair = freezed,}) {
  return _then(_WorkOrderDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,respondBy: freezed == respondBy ? _self.respondBy : respondBy // ignore: cast_nullable_to_non_nullable
as DateTime?,machine: null == machine ? _self.machine : machine // ignore: cast_nullable_to_non_nullable
as MachineDto,issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as String,issueAction: freezed == issueAction ? _self.issueAction : issueAction // ignore: cast_nullable_to_non_nullable
as String?,repairId: freezed == repairId ? _self.repairId : repairId // ignore: cast_nullable_to_non_nullable
as String?,displayStatus: null == displayStatus ? _self.displayStatus : displayStatus // ignore: cast_nullable_to_non_nullable
as WorkOrderDisplayStatus,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,repair: freezed == repair ? _self.repair : repair // ignore: cast_nullable_to_non_nullable
as RepairDto?,
  ));
}

/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MachineDtoCopyWith<$Res> get machine {
  
  return $MachineDtoCopyWith<$Res>(_self.machine, (value) {
    return _then(_self.copyWith(machine: value));
  });
}/// Create a copy of WorkOrderDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RepairDtoCopyWith<$Res>? get repair {
    if (_self.repair == null) {
    return null;
  }

  return $RepairDtoCopyWith<$Res>(_self.repair!, (value) {
    return _then(_self.copyWith(repair: value));
  });
}
}


/// @nodoc
mixin _$PaginationDto {

 int get page; int get perPage; int get totalData; int get totalPages;
/// Create a copy of PaginationDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginationDtoCopyWith<PaginationDto> get copyWith => _$PaginationDtoCopyWithImpl<PaginationDto>(this as PaginationDto, _$identity);

  /// Serializes this PaginationDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaginationDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginationDto&&(identical(other.page, _this.page) || other.page == _this.page)&&(identical(other.perPage, _this.perPage) || other.perPage == _this.perPage)&&(identical(other.totalData, _this.totalData) || other.totalData == _this.totalData)&&(identical(other.totalPages, _this.totalPages) || other.totalPages == _this.totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaginationDto;
  return Object.hash(runtimeType,_this.page,_this.perPage,_this.totalData,_this.totalPages);
}

@override
String toString() {
  final _this = this as PaginationDto;
  return 'PaginationDto(page: ${_this.page}, perPage: ${_this.perPage}, totalData: ${_this.totalData}, totalPages: ${_this.totalPages})';
}


}

/// @nodoc
abstract mixin class $PaginationDtoCopyWith<$Res>  {
  factory $PaginationDtoCopyWith(PaginationDto value, $Res Function(PaginationDto) _then) = _$PaginationDtoCopyWithImpl;
@useResult
$Res call({
 int page, int perPage, int totalData, int totalPages
});




}
/// @nodoc
class _$PaginationDtoCopyWithImpl<$Res>
    implements $PaginationDtoCopyWith<$Res> {
  _$PaginationDtoCopyWithImpl(this._self, this._then);

  final PaginationDto _self;
  final $Res Function(PaginationDto) _then;

/// Create a copy of PaginationDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? page = null,Object? perPage = null,Object? totalData = null,Object? totalPages = null,}) {
  return _then(PaginationDto(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalData: null == totalData ? _self.totalData : totalData // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginationDto].
extension PaginationDtoPatterns on PaginationDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginationDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginationDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginationDto value)  $default,){
final _that = this;
switch (_that) {
case _PaginationDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginationDto value)?  $default,){
final _that = this;
switch (_that) {
case _PaginationDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int page,  int perPage,  int totalData,  int totalPages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginationDto() when $default != null:
return $default(_that.page,_that.perPage,_that.totalData,_that.totalPages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int page,  int perPage,  int totalData,  int totalPages)  $default,) {final _that = this;
switch (_that) {
case _PaginationDto():
return $default(_that.page,_that.perPage,_that.totalData,_that.totalPages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int page,  int perPage,  int totalData,  int totalPages)?  $default,) {final _that = this;
switch (_that) {
case _PaginationDto() when $default != null:
return $default(_that.page,_that.perPage,_that.totalData,_that.totalPages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginationDto extends PaginationDto {
  const _PaginationDto({this.page = 1, this.perPage = 20, this.totalData = 0, this.totalPages = 0}): super._();
  factory _PaginationDto.fromJson(Map<String, dynamic> json) => _$PaginationDtoFromJson(json);

@override@JsonKey() final  int page;
@override@JsonKey() final  int perPage;
@override@JsonKey() final  int totalData;
@override@JsonKey() final  int totalPages;

/// Create a copy of PaginationDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginationDtoCopyWith<_PaginationDto> get copyWith => __$PaginationDtoCopyWithImpl<_PaginationDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginationDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginationDto&&(identical(other.page, page) || other.page == page)&&(identical(other.perPage, perPage) || other.perPage == perPage)&&(identical(other.totalData, totalData) || other.totalData == totalData)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,page,perPage,totalData,totalPages);
}

@override
String toString() {
    return 'PaginationDto(page: $page, perPage: $perPage, totalData: $totalData, totalPages: $totalPages)';
}


}

/// @nodoc
abstract mixin class _$PaginationDtoCopyWith<$Res> implements $PaginationDtoCopyWith<$Res> {
  factory _$PaginationDtoCopyWith(_PaginationDto value, $Res Function(_PaginationDto) _then) = __$PaginationDtoCopyWithImpl;
@override @useResult
$Res call({
 int page, int perPage, int totalData, int totalPages
});




}
/// @nodoc
class __$PaginationDtoCopyWithImpl<$Res>
    implements _$PaginationDtoCopyWith<$Res> {
  __$PaginationDtoCopyWithImpl(this._self, this._then);

  final _PaginationDto _self;
  final $Res Function(_PaginationDto) _then;

/// Create a copy of PaginationDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? page = null,Object? perPage = null,Object? totalData = null,Object? totalPages = null,}) {
  return _then(_PaginationDto(
page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,perPage: null == perPage ? _self.perPage : perPage // ignore: cast_nullable_to_non_nullable
as int,totalData: null == totalData ? _self.totalData : totalData // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$WorkOrderPageDto {

 List<WorkOrderDto> get items; PaginationDto get pagination;
/// Create a copy of WorkOrderPageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderPageDtoCopyWith<WorkOrderPageDto> get copyWith => _$WorkOrderPageDtoCopyWithImpl<WorkOrderPageDto>(this as WorkOrderPageDto, _$identity);

  /// Serializes this WorkOrderPageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorkOrderPageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderPageDto&&const DeepCollectionEquality().equals(other.items, _this.items)&&(identical(other.pagination, _this.pagination) || other.pagination == _this.pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorkOrderPageDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.items),_this.pagination);
}

@override
String toString() {
  final _this = this as WorkOrderPageDto;
  return 'WorkOrderPageDto(items: ${_this.items}, pagination: ${_this.pagination})';
}


}

/// @nodoc
abstract mixin class $WorkOrderPageDtoCopyWith<$Res>  {
  factory $WorkOrderPageDtoCopyWith(WorkOrderPageDto value, $Res Function(WorkOrderPageDto) _then) = _$WorkOrderPageDtoCopyWithImpl;
@useResult
$Res call({
 List<WorkOrderDto> items, PaginationDto pagination
});


$PaginationDtoCopyWith<$Res> get pagination;

}
/// @nodoc
class _$WorkOrderPageDtoCopyWithImpl<$Res>
    implements $WorkOrderPageDtoCopyWith<$Res> {
  _$WorkOrderPageDtoCopyWithImpl(this._self, this._then);

  final WorkOrderPageDto _self;
  final $Res Function(WorkOrderPageDto) _then;

/// Create a copy of WorkOrderPageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(WorkOrderPageDto(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WorkOrderDto>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationDto,
  ));
}
/// Create a copy of WorkOrderPageDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaginationDtoCopyWith<$Res> get pagination {
  
  return $PaginationDtoCopyWith<$Res>(_self.pagination, (value) {
    return _then(_self.copyWith(pagination: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkOrderPageDto].
extension WorkOrderPageDtoPatterns on WorkOrderPageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkOrderPageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkOrderPageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkOrderPageDto value)  $default,){
final _that = this;
switch (_that) {
case _WorkOrderPageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkOrderPageDto value)?  $default,){
final _that = this;
switch (_that) {
case _WorkOrderPageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WorkOrderDto> items,  PaginationDto pagination)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkOrderPageDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WorkOrderDto> items,  PaginationDto pagination)  $default,) {final _that = this;
switch (_that) {
case _WorkOrderPageDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WorkOrderDto> items,  PaginationDto pagination)?  $default,) {final _that = this;
switch (_that) {
case _WorkOrderPageDto() when $default != null:
return $default(_that.items,_that.pagination);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkOrderPageDto implements WorkOrderPageDto {
  const _WorkOrderPageDto({ List<WorkOrderDto> items = const <WorkOrderDto>[], this.pagination = const PaginationDto()}): _items = items;
  factory _WorkOrderPageDto.fromJson(Map<String, dynamic> json) => _$WorkOrderPageDtoFromJson(json);

 final  List<WorkOrderDto> _items;
@override@JsonKey() List<WorkOrderDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  PaginationDto pagination;

/// Create a copy of WorkOrderPageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkOrderPageDtoCopyWith<_WorkOrderPageDto> get copyWith => __$WorkOrderPageDtoCopyWithImpl<_WorkOrderPageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkOrderPageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkOrderPageDto&&const DeepCollectionEquality().equals(other.items, _items)&&(identical(other.pagination, pagination) || other.pagination == pagination));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),pagination);
}

@override
String toString() {
    return 'WorkOrderPageDto(items: $items, pagination: $pagination)';
}


}

/// @nodoc
abstract mixin class _$WorkOrderPageDtoCopyWith<$Res> implements $WorkOrderPageDtoCopyWith<$Res> {
  factory _$WorkOrderPageDtoCopyWith(_WorkOrderPageDto value, $Res Function(_WorkOrderPageDto) _then) = __$WorkOrderPageDtoCopyWithImpl;
@override @useResult
$Res call({
 List<WorkOrderDto> items, PaginationDto pagination
});


@override $PaginationDtoCopyWith<$Res> get pagination;

}
/// @nodoc
class __$WorkOrderPageDtoCopyWithImpl<$Res>
    implements _$WorkOrderPageDtoCopyWith<$Res> {
  __$WorkOrderPageDtoCopyWithImpl(this._self, this._then);

  final _WorkOrderPageDto _self;
  final $Res Function(_WorkOrderPageDto) _then;

/// Create a copy of WorkOrderPageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? pagination = null,}) {
  return _then(_WorkOrderPageDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WorkOrderDto>,pagination: null == pagination ? _self.pagination : pagination // ignore: cast_nullable_to_non_nullable
as PaginationDto,
  ));
}

/// Create a copy of WorkOrderPageDto
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
