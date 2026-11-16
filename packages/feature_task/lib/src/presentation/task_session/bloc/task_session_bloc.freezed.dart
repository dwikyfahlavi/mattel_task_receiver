// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_session_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskSessionState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskSessionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TaskSessionState()';
}


}

/// @nodoc
class $TaskSessionStateCopyWith<$Res>  {
$TaskSessionStateCopyWith(TaskSessionState _, $Res Function(TaskSessionState) __);
}


/// Adds pattern-matching-related methods to [TaskSessionState].
extension TaskSessionStatePatterns on TaskSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskIdle value)?  idle,TResult Function( TaskAssigned value)?  assigned,TResult Function( TaskInProgress value)?  inProgress,TResult Function( TaskResult value)?  result,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskIdle() when idle != null:
return idle(_that);case TaskAssigned() when assigned != null:
return assigned(_that);case TaskInProgress() when inProgress != null:
return inProgress(_that);case TaskResult() when result != null:
return result(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskIdle value)  idle,required TResult Function( TaskAssigned value)  assigned,required TResult Function( TaskInProgress value)  inProgress,required TResult Function( TaskResult value)  result,}){
final _that = this;
switch (_that) {
case TaskIdle():
return idle(_that);case TaskAssigned():
return assigned(_that);case TaskInProgress():
return inProgress(_that);case TaskResult():
return result(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskIdle value)?  idle,TResult? Function( TaskAssigned value)?  assigned,TResult? Function( TaskInProgress value)?  inProgress,TResult? Function( TaskResult value)?  result,}){
final _that = this;
switch (_that) {
case TaskIdle() when idle != null:
return idle(_that);case TaskAssigned() when assigned != null:
return assigned(_that);case TaskInProgress() when inProgress != null:
return inProgress(_that);case TaskResult() when result != null:
return result(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( TaskAssignment task,  TaskAction action,  Failure? error)?  assigned,TResult Function( TaskAssignment task,  DateTime acceptedAt,  bool showAcceptedScreen,  TaskAction action,  Failure? error)?  inProgress,TResult Function( TaskOutcome outcome)?  result,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskIdle() when idle != null:
return idle();case TaskAssigned() when assigned != null:
return assigned(_that.task,_that.action,_that.error);case TaskInProgress() when inProgress != null:
return inProgress(_that.task,_that.acceptedAt,_that.showAcceptedScreen,_that.action,_that.error);case TaskResult() when result != null:
return result(_that.outcome);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( TaskAssignment task,  TaskAction action,  Failure? error)  assigned,required TResult Function( TaskAssignment task,  DateTime acceptedAt,  bool showAcceptedScreen,  TaskAction action,  Failure? error)  inProgress,required TResult Function( TaskOutcome outcome)  result,}) {final _that = this;
switch (_that) {
case TaskIdle():
return idle();case TaskAssigned():
return assigned(_that.task,_that.action,_that.error);case TaskInProgress():
return inProgress(_that.task,_that.acceptedAt,_that.showAcceptedScreen,_that.action,_that.error);case TaskResult():
return result(_that.outcome);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( TaskAssignment task,  TaskAction action,  Failure? error)?  assigned,TResult? Function( TaskAssignment task,  DateTime acceptedAt,  bool showAcceptedScreen,  TaskAction action,  Failure? error)?  inProgress,TResult? Function( TaskOutcome outcome)?  result,}) {final _that = this;
switch (_that) {
case TaskIdle() when idle != null:
return idle();case TaskAssigned() when assigned != null:
return assigned(_that.task,_that.action,_that.error);case TaskInProgress() when inProgress != null:
return inProgress(_that.task,_that.acceptedAt,_that.showAcceptedScreen,_that.action,_that.error);case TaskResult() when result != null:
return result(_that.outcome);case _:
  return null;

}
}

}

/// @nodoc


class TaskIdle extends TaskSessionState {
  const TaskIdle(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'TaskSessionState.idle()';
}


}




/// @nodoc


class TaskAssigned extends TaskSessionState {
  const TaskAssigned({required this.task, this.action = TaskAction.none, this.error}): super._();
  

 final  TaskAssignment task;
@JsonKey() final  TaskAction action;
 final  Failure? error;

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskAssignedCopyWith<TaskAssigned> get copyWith => _$TaskAssignedCopyWithImpl<TaskAssigned>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskAssigned&&(identical(other.task, task) || other.task == task)&&(identical(other.action, action) || other.action == action)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,task,action,error);
}

@override
String toString() {
    return 'TaskSessionState.assigned(task: $task, action: $action, error: $error)';
}


}

/// @nodoc
abstract mixin class $TaskAssignedCopyWith<$Res> implements $TaskSessionStateCopyWith<$Res> {
  factory $TaskAssignedCopyWith(TaskAssigned value, $Res Function(TaskAssigned) _then) = _$TaskAssignedCopyWithImpl;
@useResult
$Res call({
 TaskAssignment task, TaskAction action, Failure? error
});


$TaskAssignmentCopyWith<$Res> get task;

}
/// @nodoc
class _$TaskAssignedCopyWithImpl<$Res>
    implements $TaskAssignedCopyWith<$Res> {
  _$TaskAssignedCopyWithImpl(this._self, this._then);

  final TaskAssigned _self;
  final $Res Function(TaskAssigned) _then;

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,Object? action = null,Object? error = freezed,}) {
  return _then(TaskAssigned(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TaskAssignment,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskAction,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskAssignmentCopyWith<$Res> get task {
  
  return $TaskAssignmentCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

/// @nodoc


class TaskInProgress extends TaskSessionState {
  const TaskInProgress({required this.task, required this.acceptedAt, this.showAcceptedScreen = false, this.action = TaskAction.none, this.error}): super._();
  

 final  TaskAssignment task;
 final  DateTime acceptedAt;
@JsonKey() final  bool showAcceptedScreen;
@JsonKey() final  TaskAction action;
 final  Failure? error;

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskInProgressCopyWith<TaskInProgress> get copyWith => _$TaskInProgressCopyWithImpl<TaskInProgress>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskInProgress&&(identical(other.task, task) || other.task == task)&&(identical(other.acceptedAt, acceptedAt) || other.acceptedAt == acceptedAt)&&(identical(other.showAcceptedScreen, showAcceptedScreen) || other.showAcceptedScreen == showAcceptedScreen)&&(identical(other.action, action) || other.action == action)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,task,acceptedAt,showAcceptedScreen,action,error);
}

@override
String toString() {
    return 'TaskSessionState.inProgress(task: $task, acceptedAt: $acceptedAt, showAcceptedScreen: $showAcceptedScreen, action: $action, error: $error)';
}


}

/// @nodoc
abstract mixin class $TaskInProgressCopyWith<$Res> implements $TaskSessionStateCopyWith<$Res> {
  factory $TaskInProgressCopyWith(TaskInProgress value, $Res Function(TaskInProgress) _then) = _$TaskInProgressCopyWithImpl;
@useResult
$Res call({
 TaskAssignment task, DateTime acceptedAt, bool showAcceptedScreen, TaskAction action, Failure? error
});


$TaskAssignmentCopyWith<$Res> get task;

}
/// @nodoc
class _$TaskInProgressCopyWithImpl<$Res>
    implements $TaskInProgressCopyWith<$Res> {
  _$TaskInProgressCopyWithImpl(this._self, this._then);

  final TaskInProgress _self;
  final $Res Function(TaskInProgress) _then;

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,Object? acceptedAt = null,Object? showAcceptedScreen = null,Object? action = null,Object? error = freezed,}) {
  return _then(TaskInProgress(
task: null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as TaskAssignment,acceptedAt: null == acceptedAt ? _self.acceptedAt : acceptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,showAcceptedScreen: null == showAcceptedScreen ? _self.showAcceptedScreen : showAcceptedScreen // ignore: cast_nullable_to_non_nullable
as bool,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as TaskAction,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskAssignmentCopyWith<$Res> get task {
  
  return $TaskAssignmentCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

/// @nodoc


class TaskResult extends TaskSessionState {
  const TaskResult({required this.outcome}): super._();
  

 final  TaskOutcome outcome;

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskResultCopyWith<TaskResult> get copyWith => _$TaskResultCopyWithImpl<TaskResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskResult&&(identical(other.outcome, outcome) || other.outcome == outcome));
}


@override
int get hashCode {
    return Object.hash(runtimeType,outcome);
}

@override
String toString() {
    return 'TaskSessionState.result(outcome: $outcome)';
}


}

/// @nodoc
abstract mixin class $TaskResultCopyWith<$Res> implements $TaskSessionStateCopyWith<$Res> {
  factory $TaskResultCopyWith(TaskResult value, $Res Function(TaskResult) _then) = _$TaskResultCopyWithImpl;
@useResult
$Res call({
 TaskOutcome outcome
});


$TaskOutcomeCopyWith<$Res> get outcome;

}
/// @nodoc
class _$TaskResultCopyWithImpl<$Res>
    implements $TaskResultCopyWith<$Res> {
  _$TaskResultCopyWithImpl(this._self, this._then);

  final TaskResult _self;
  final $Res Function(TaskResult) _then;

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? outcome = null,}) {
  return _then(TaskResult(
outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as TaskOutcome,
  ));
}

/// Create a copy of TaskSessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskOutcomeCopyWith<$Res> get outcome {
  
  return $TaskOutcomeCopyWith<$Res>(_self.outcome, (value) {
    return _then(_self.copyWith(outcome: value));
  });
}
}

// dart format on
