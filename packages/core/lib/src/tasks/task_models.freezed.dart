// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskAssignment {

/// `work_order.id`, used in every action URL.
 String get taskId;/// Human id, e.g. `WO-2026-00193`.
 String? get requestId;/// `machine.id`, e.g. `FAR339`.
 String get machineCode;/// `machine.cell_position`, e.g. `B-12`.
 String get location;/// `issue`, e.g. `Changeover`.
 String get issue; String? get shift;/// `created_at`, server time (UTC).
 DateTime get assignedAt;/// `respond_by`, server time (UTC). The countdown is derived from this
/// (doc 7.3). The server auto-declines a few seconds later.
 DateTime get expiresAt;
/// Create a copy of TaskAssignment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskAssignmentCopyWith<TaskAssignment> get copyWith => _$TaskAssignmentCopyWithImpl<TaskAssignment>(this as TaskAssignment, _$identity);

  /// Serializes this TaskAssignment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskAssignment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskAssignment&&(identical(other.taskId, _this.taskId) || other.taskId == _this.taskId)&&(identical(other.requestId, _this.requestId) || other.requestId == _this.requestId)&&(identical(other.machineCode, _this.machineCode) || other.machineCode == _this.machineCode)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.issue, _this.issue) || other.issue == _this.issue)&&(identical(other.shift, _this.shift) || other.shift == _this.shift)&&(identical(other.assignedAt, _this.assignedAt) || other.assignedAt == _this.assignedAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskAssignment;
  return Object.hash(runtimeType,_this.taskId,_this.requestId,_this.machineCode,_this.location,_this.issue,_this.shift,_this.assignedAt,_this.expiresAt);
}

@override
String toString() {
  final _this = this as TaskAssignment;
  return 'TaskAssignment(taskId: ${_this.taskId}, requestId: ${_this.requestId}, machineCode: ${_this.machineCode}, location: ${_this.location}, issue: ${_this.issue}, shift: ${_this.shift}, assignedAt: ${_this.assignedAt}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $TaskAssignmentCopyWith<$Res>  {
  factory $TaskAssignmentCopyWith(TaskAssignment value, $Res Function(TaskAssignment) _then) = _$TaskAssignmentCopyWithImpl;
@useResult
$Res call({
 String taskId, String? requestId, String machineCode, String location, String issue, String? shift, DateTime assignedAt, DateTime expiresAt
});




}
/// @nodoc
class _$TaskAssignmentCopyWithImpl<$Res>
    implements $TaskAssignmentCopyWith<$Res> {
  _$TaskAssignmentCopyWithImpl(this._self, this._then);

  final TaskAssignment _self;
  final $Res Function(TaskAssignment) _then;

/// Create a copy of TaskAssignment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? taskId = null,Object? requestId = freezed,Object? machineCode = null,Object? location = null,Object? issue = null,Object? shift = freezed,Object? assignedAt = null,Object? expiresAt = null,}) {
  return _then(TaskAssignment(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,machineCode: null == machineCode ? _self.machineCode : machineCode // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskAssignment].
extension TaskAssignmentPatterns on TaskAssignment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskAssignment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskAssignment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskAssignment value)  $default,){
final _that = this;
switch (_that) {
case _TaskAssignment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskAssignment value)?  $default,){
final _that = this;
switch (_that) {
case _TaskAssignment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String taskId,  String? requestId,  String machineCode,  String location,  String issue,  String? shift,  DateTime assignedAt,  DateTime expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskAssignment() when $default != null:
return $default(_that.taskId,_that.requestId,_that.machineCode,_that.location,_that.issue,_that.shift,_that.assignedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String taskId,  String? requestId,  String machineCode,  String location,  String issue,  String? shift,  DateTime assignedAt,  DateTime expiresAt)  $default,) {final _that = this;
switch (_that) {
case _TaskAssignment():
return $default(_that.taskId,_that.requestId,_that.machineCode,_that.location,_that.issue,_that.shift,_that.assignedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String taskId,  String? requestId,  String machineCode,  String location,  String issue,  String? shift,  DateTime assignedAt,  DateTime expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskAssignment() when $default != null:
return $default(_that.taskId,_that.requestId,_that.machineCode,_that.location,_that.issue,_that.shift,_that.assignedAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskAssignment extends TaskAssignment {
  const _TaskAssignment({required this.taskId, this.requestId, required this.machineCode, this.location = '', this.issue = '', this.shift, required this.assignedAt, required this.expiresAt}): super._();
  factory _TaskAssignment.fromJson(Map<String, dynamic> json) => _$TaskAssignmentFromJson(json);

/// `work_order.id`, used in every action URL.
@override final  String taskId;
/// Human id, e.g. `WO-2026-00193`.
@override final  String? requestId;
/// `machine.id`, e.g. `FAR339`.
@override final  String machineCode;
/// `machine.cell_position`, e.g. `B-12`.
@override@JsonKey() final  String location;
/// `issue`, e.g. `Changeover`.
@override@JsonKey() final  String issue;
@override final  String? shift;
/// `created_at`, server time (UTC).
@override final  DateTime assignedAt;
/// `respond_by`, server time (UTC). The countdown is derived from this
/// (doc 7.3). The server auto-declines a few seconds later.
@override final  DateTime expiresAt;

/// Create a copy of TaskAssignment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskAssignmentCopyWith<_TaskAssignment> get copyWith => __$TaskAssignmentCopyWithImpl<_TaskAssignment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskAssignmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskAssignment&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.machineCode, machineCode) || other.machineCode == machineCode)&&(identical(other.location, location) || other.location == location)&&(identical(other.issue, issue) || other.issue == issue)&&(identical(other.shift, shift) || other.shift == shift)&&(identical(other.assignedAt, assignedAt) || other.assignedAt == assignedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,taskId,requestId,machineCode,location,issue,shift,assignedAt,expiresAt);
}

@override
String toString() {
    return 'TaskAssignment(taskId: $taskId, requestId: $requestId, machineCode: $machineCode, location: $location, issue: $issue, shift: $shift, assignedAt: $assignedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$TaskAssignmentCopyWith<$Res> implements $TaskAssignmentCopyWith<$Res> {
  factory _$TaskAssignmentCopyWith(_TaskAssignment value, $Res Function(_TaskAssignment) _then) = __$TaskAssignmentCopyWithImpl;
@override @useResult
$Res call({
 String taskId, String? requestId, String machineCode, String location, String issue, String? shift, DateTime assignedAt, DateTime expiresAt
});




}
/// @nodoc
class __$TaskAssignmentCopyWithImpl<$Res>
    implements _$TaskAssignmentCopyWith<$Res> {
  __$TaskAssignmentCopyWithImpl(this._self, this._then);

  final _TaskAssignment _self;
  final $Res Function(_TaskAssignment) _then;

/// Create a copy of TaskAssignment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? taskId = null,Object? requestId = freezed,Object? machineCode = null,Object? location = null,Object? issue = null,Object? shift = freezed,Object? assignedAt = null,Object? expiresAt = null,}) {
  return _then(_TaskAssignment(
taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,requestId: freezed == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String?,machineCode: null == machineCode ? _self.machineCode : machineCode // ignore: cast_nullable_to_non_nullable
as String,location: null == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String,issue: null == issue ? _self.issue : issue // ignore: cast_nullable_to_non_nullable
as String,shift: freezed == shift ? _self.shift : shift // ignore: cast_nullable_to_non_nullable
as String?,assignedAt: null == assignedAt ? _self.assignedAt : assignedAt // ignore: cast_nullable_to_non_nullable
as DateTime,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskOutcome {

 TaskAssignment get task; ResolutionReason get reason;
/// Create a copy of TaskOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskOutcomeCopyWith<TaskOutcome> get copyWith => _$TaskOutcomeCopyWithImpl<TaskOutcome>(this as TaskOutcome, _$identity);

  /// Serializes this TaskOutcome to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TaskOutcome;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskOutcome&&(identical(other.task, _this.task) || other.task == _this.task)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TaskOutcome;
  return Object.hash(runtimeType,_this.task,_this.reason);
}

@override
String toString() {
  final _this = this as TaskOutcome;
  return 'TaskOutcome(task: ${_this.task}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $TaskOutcomeCopyWith<$Res>  {
  factory $TaskOutcomeCopyWith(TaskOutcome value, $Res Function(TaskOutcome) _then) = _$TaskOutcomeCopyWithImpl;
@useResult
$Res call({
 TaskAssignment task, ResolutionReason reason
});


$TaskAssignmentCopyWith<$Res> get task;

}
/// @nodoc
class _$TaskOutcomeCopyWithImpl<$Res>
    implements $TaskOutcomeCopyWith<$Res> {
  _$TaskOutcomeCopyWithImpl(this._self, this._then);

  final TaskOutcome _self;
  final $Res Function(TaskOutcome) _then;

/// Create a copy of TaskOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? task = null,Object? reason = null,}) {
  return _then(TaskOutcome(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TaskAssignment,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ResolutionReason,
  ));
}
/// Create a copy of TaskOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskAssignmentCopyWith<$Res> get task {
  
  return $TaskAssignmentCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}


/// Adds pattern-matching-related methods to [TaskOutcome].
extension TaskOutcomePatterns on TaskOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskOutcome value)  $default,){
final _that = this;
switch (_that) {
case _TaskOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _TaskOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TaskAssignment task,  ResolutionReason reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskOutcome() when $default != null:
return $default(_that.task,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TaskAssignment task,  ResolutionReason reason)  $default,) {final _that = this;
switch (_that) {
case _TaskOutcome():
return $default(_that.task,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TaskAssignment task,  ResolutionReason reason)?  $default,) {final _that = this;
switch (_that) {
case _TaskOutcome() when $default != null:
return $default(_that.task,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskOutcome implements TaskOutcome {
  const _TaskOutcome({required this.task, required this.reason});
  factory _TaskOutcome.fromJson(Map<String, dynamic> json) => _$TaskOutcomeFromJson(json);

@override final  TaskAssignment task;
@override final  ResolutionReason reason;

/// Create a copy of TaskOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskOutcomeCopyWith<_TaskOutcome> get copyWith => __$TaskOutcomeCopyWithImpl<_TaskOutcome>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskOutcomeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskOutcome&&(identical(other.task, task) || other.task == task)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,task,reason);
}

@override
String toString() {
    return 'TaskOutcome(task: $task, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$TaskOutcomeCopyWith<$Res> implements $TaskOutcomeCopyWith<$Res> {
  factory _$TaskOutcomeCopyWith(_TaskOutcome value, $Res Function(_TaskOutcome) _then) = __$TaskOutcomeCopyWithImpl;
@override @useResult
$Res call({
 TaskAssignment task, ResolutionReason reason
});


@override $TaskAssignmentCopyWith<$Res> get task;

}
/// @nodoc
class __$TaskOutcomeCopyWithImpl<$Res>
    implements _$TaskOutcomeCopyWith<$Res> {
  __$TaskOutcomeCopyWithImpl(this._self, this._then);

  final _TaskOutcome _self;
  final $Res Function(_TaskOutcome) _then;

/// Create a copy of TaskOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? task = null,Object? reason = null,}) {
  return _then(_TaskOutcome(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TaskAssignment,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ResolutionReason,
  ));
}

/// Create a copy of TaskOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskAssignmentCopyWith<$Res> get task {
  
  return $TaskAssignmentCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
