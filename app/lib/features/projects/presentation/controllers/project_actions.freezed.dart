// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_actions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProjectActionState {

 bool get inProgress; String? get errorMessage;
/// Create a copy of ProjectActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectActionStateCopyWith<ProjectActionState> get copyWith => _$ProjectActionStateCopyWithImpl<ProjectActionState>(this as ProjectActionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ProjectActionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectActionState&&(identical(other.inProgress, _this.inProgress) || other.inProgress == _this.inProgress)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as ProjectActionState;
  return Object.hash(runtimeType,_this.inProgress,_this.errorMessage);
}

@override
String toString() {
  final _this = this as ProjectActionState;
  return 'ProjectActionState(inProgress: ${_this.inProgress}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $ProjectActionStateCopyWith<$Res>  {
  factory $ProjectActionStateCopyWith(ProjectActionState value, $Res Function(ProjectActionState) _then) = _$ProjectActionStateCopyWithImpl;
@useResult
$Res call({
 bool inProgress, String? errorMessage
});




}
/// @nodoc
class _$ProjectActionStateCopyWithImpl<$Res>
    implements $ProjectActionStateCopyWith<$Res> {
  _$ProjectActionStateCopyWithImpl(this._self, this._then);

  final ProjectActionState _self;
  final $Res Function(ProjectActionState) _then;

/// Create a copy of ProjectActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inProgress = null,Object? errorMessage = freezed,}) {
  return _then(ProjectActionState(
inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectActionState].
extension ProjectActionStatePatterns on ProjectActionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectActionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectActionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectActionState value)  $default,){
final _that = this;
switch (_that) {
case _ProjectActionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectActionState value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectActionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool inProgress,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectActionState() when $default != null:
return $default(_that.inProgress,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool inProgress,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ProjectActionState():
return $default(_that.inProgress,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool inProgress,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProjectActionState() when $default != null:
return $default(_that.inProgress,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectActionState implements ProjectActionState {
  const _ProjectActionState({this.inProgress = false, this.errorMessage});
  

@override@JsonKey() final  bool inProgress;
@override final  String? errorMessage;

/// Create a copy of ProjectActionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectActionStateCopyWith<_ProjectActionState> get copyWith => __$ProjectActionStateCopyWithImpl<_ProjectActionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectActionState&&(identical(other.inProgress, inProgress) || other.inProgress == inProgress)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,inProgress,errorMessage);
}

@override
String toString() {
    return 'ProjectActionState(inProgress: $inProgress, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ProjectActionStateCopyWith<$Res> implements $ProjectActionStateCopyWith<$Res> {
  factory _$ProjectActionStateCopyWith(_ProjectActionState value, $Res Function(_ProjectActionState) _then) = __$ProjectActionStateCopyWithImpl;
@override @useResult
$Res call({
 bool inProgress, String? errorMessage
});




}
/// @nodoc
class __$ProjectActionStateCopyWithImpl<$Res>
    implements _$ProjectActionStateCopyWith<$Res> {
  __$ProjectActionStateCopyWithImpl(this._self, this._then);

  final _ProjectActionState _self;
  final $Res Function(_ProjectActionState) _then;

/// Create a copy of ProjectActionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inProgress = null,Object? errorMessage = freezed,}) {
  return _then(_ProjectActionState(
inProgress: null == inProgress ? _self.inProgress : inProgress // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
