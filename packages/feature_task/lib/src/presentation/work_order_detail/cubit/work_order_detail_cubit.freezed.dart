// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_order_detail_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkOrderDetailState {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WorkOrderDetailState()';
}


}

/// @nodoc
class $WorkOrderDetailStateCopyWith<$Res>  {
$WorkOrderDetailStateCopyWith(WorkOrderDetailState _, $Res Function(WorkOrderDetailState) __);
}


/// Adds pattern-matching-related methods to [WorkOrderDetailState].
extension WorkOrderDetailStatePatterns on WorkOrderDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( WorkOrderDetailLoading value)?  loading,TResult Function( WorkOrderDetailLoaded value)?  loaded,TResult Function( WorkOrderDetailFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case WorkOrderDetailLoading() when loading != null:
return loading(_that);case WorkOrderDetailLoaded() when loaded != null:
return loaded(_that);case WorkOrderDetailFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( WorkOrderDetailLoading value)  loading,required TResult Function( WorkOrderDetailLoaded value)  loaded,required TResult Function( WorkOrderDetailFailed value)  failed,}){
final _that = this;
switch (_that) {
case WorkOrderDetailLoading():
return loading(_that);case WorkOrderDetailLoaded():
return loaded(_that);case WorkOrderDetailFailed():
return failed(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( WorkOrderDetailLoading value)?  loading,TResult? Function( WorkOrderDetailLoaded value)?  loaded,TResult? Function( WorkOrderDetailFailed value)?  failed,}){
final _that = this;
switch (_that) {
case WorkOrderDetailLoading() when loading != null:
return loading(_that);case WorkOrderDetailLoaded() when loaded != null:
return loaded(_that);case WorkOrderDetailFailed() when failed != null:
return failed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( WorkOrderDto workOrder)?  loaded,TResult Function( Failure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case WorkOrderDetailLoading() when loading != null:
return loading();case WorkOrderDetailLoaded() when loaded != null:
return loaded(_that.workOrder);case WorkOrderDetailFailed() when failed != null:
return failed(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( WorkOrderDto workOrder)  loaded,required TResult Function( Failure failure)  failed,}) {final _that = this;
switch (_that) {
case WorkOrderDetailLoading():
return loading();case WorkOrderDetailLoaded():
return loaded(_that.workOrder);case WorkOrderDetailFailed():
return failed(_that.failure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( WorkOrderDto workOrder)?  loaded,TResult? Function( Failure failure)?  failed,}) {final _that = this;
switch (_that) {
case WorkOrderDetailLoading() when loading != null:
return loading();case WorkOrderDetailLoaded() when loaded != null:
return loaded(_that.workOrder);case WorkOrderDetailFailed() when failed != null:
return failed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class WorkOrderDetailLoading implements WorkOrderDetailState {
  const WorkOrderDetailLoading();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'WorkOrderDetailState.loading()';
}


}




/// @nodoc


class WorkOrderDetailLoaded implements WorkOrderDetailState {
  const WorkOrderDetailLoaded(this.workOrder);
  

 final  WorkOrderDto workOrder;

/// Create a copy of WorkOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderDetailLoadedCopyWith<WorkOrderDetailLoaded> get copyWith => _$WorkOrderDetailLoadedCopyWithImpl<WorkOrderDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderDetailLoaded&&(identical(other.workOrder, workOrder) || other.workOrder == workOrder));
}


@override
int get hashCode {
    return Object.hash(runtimeType,workOrder);
}

@override
String toString() {
    return 'WorkOrderDetailState.loaded(workOrder: $workOrder)';
}


}

/// @nodoc
abstract mixin class $WorkOrderDetailLoadedCopyWith<$Res> implements $WorkOrderDetailStateCopyWith<$Res> {
  factory $WorkOrderDetailLoadedCopyWith(WorkOrderDetailLoaded value, $Res Function(WorkOrderDetailLoaded) _then) = _$WorkOrderDetailLoadedCopyWithImpl;
@useResult
$Res call({
 WorkOrderDto workOrder
});


$WorkOrderDtoCopyWith<$Res> get workOrder;

}
/// @nodoc
class _$WorkOrderDetailLoadedCopyWithImpl<$Res>
    implements $WorkOrderDetailLoadedCopyWith<$Res> {
  _$WorkOrderDetailLoadedCopyWithImpl(this._self, this._then);

  final WorkOrderDetailLoaded _self;
  final $Res Function(WorkOrderDetailLoaded) _then;

/// Create a copy of WorkOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? workOrder = null,}) {
  return _then(WorkOrderDetailLoaded(
null == workOrder ? _self.workOrder : workOrder // ignore: cast_nullable_to_non_nullable
as WorkOrderDto,
  ));
}

/// Create a copy of WorkOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkOrderDtoCopyWith<$Res> get workOrder {
  
  return $WorkOrderDtoCopyWith<$Res>(_self.workOrder, (value) {
    return _then(_self.copyWith(workOrder: value));
  });
}
}

/// @nodoc


class WorkOrderDetailFailed implements WorkOrderDetailState {
  const WorkOrderDetailFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of WorkOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkOrderDetailFailedCopyWith<WorkOrderDetailFailed> get copyWith => _$WorkOrderDetailFailedCopyWithImpl<WorkOrderDetailFailed>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkOrderDetailFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,failure);
}

@override
String toString() {
    return 'WorkOrderDetailState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $WorkOrderDetailFailedCopyWith<$Res> implements $WorkOrderDetailStateCopyWith<$Res> {
  factory $WorkOrderDetailFailedCopyWith(WorkOrderDetailFailed value, $Res Function(WorkOrderDetailFailed) _then) = _$WorkOrderDetailFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$WorkOrderDetailFailedCopyWithImpl<$Res>
    implements $WorkOrderDetailFailedCopyWith<$Res> {
  _$WorkOrderDetailFailedCopyWithImpl(this._self, this._then);

  final WorkOrderDetailFailed _self;
  final $Res Function(WorkOrderDetailFailed) _then;

/// Create a copy of WorkOrderDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(WorkOrderDetailFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
