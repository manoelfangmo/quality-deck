// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_actions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClientActionState {

 bool get isRemoving; String? get errorMessage;
/// Create a copy of ClientActionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientActionStateCopyWith<ClientActionState> get copyWith => _$ClientActionStateCopyWithImpl<ClientActionState>(this as ClientActionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ClientActionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientActionState&&(identical(other.isRemoving, _this.isRemoving) || other.isRemoving == _this.isRemoving)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as ClientActionState;
  return Object.hash(runtimeType,_this.isRemoving,_this.errorMessage);
}

@override
String toString() {
  final _this = this as ClientActionState;
  return 'ClientActionState(isRemoving: ${_this.isRemoving}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $ClientActionStateCopyWith<$Res>  {
  factory $ClientActionStateCopyWith(ClientActionState value, $Res Function(ClientActionState) _then) = _$ClientActionStateCopyWithImpl;
@useResult
$Res call({
 bool isRemoving, String? errorMessage
});




}
/// @nodoc
class _$ClientActionStateCopyWithImpl<$Res>
    implements $ClientActionStateCopyWith<$Res> {
  _$ClientActionStateCopyWithImpl(this._self, this._then);

  final ClientActionState _self;
  final $Res Function(ClientActionState) _then;

/// Create a copy of ClientActionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isRemoving = null,Object? errorMessage = freezed,}) {
  return _then(ClientActionState(
isRemoving: null == isRemoving ? _self.isRemoving : isRemoving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientActionState].
extension ClientActionStatePatterns on ClientActionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientActionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientActionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientActionState value)  $default,){
final _that = this;
switch (_that) {
case _ClientActionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientActionState value)?  $default,){
final _that = this;
switch (_that) {
case _ClientActionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isRemoving,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientActionState() when $default != null:
return $default(_that.isRemoving,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isRemoving,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ClientActionState():
return $default(_that.isRemoving,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isRemoving,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ClientActionState() when $default != null:
return $default(_that.isRemoving,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ClientActionState implements ClientActionState {
  const _ClientActionState({this.isRemoving = false, this.errorMessage});
  

@override@JsonKey() final  bool isRemoving;
@override final  String? errorMessage;

/// Create a copy of ClientActionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientActionStateCopyWith<_ClientActionState> get copyWith => __$ClientActionStateCopyWithImpl<_ClientActionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientActionState&&(identical(other.isRemoving, isRemoving) || other.isRemoving == isRemoving)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isRemoving,errorMessage);
}

@override
String toString() {
    return 'ClientActionState(isRemoving: $isRemoving, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ClientActionStateCopyWith<$Res> implements $ClientActionStateCopyWith<$Res> {
  factory _$ClientActionStateCopyWith(_ClientActionState value, $Res Function(_ClientActionState) _then) = __$ClientActionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isRemoving, String? errorMessage
});




}
/// @nodoc
class __$ClientActionStateCopyWithImpl<$Res>
    implements _$ClientActionStateCopyWith<$Res> {
  __$ClientActionStateCopyWithImpl(this._self, this._then);

  final _ClientActionState _self;
  final $Res Function(_ClientActionState) _then;

/// Create a copy of ClientActionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isRemoving = null,Object? errorMessage = freezed,}) {
  return _then(_ClientActionState(
isRemoving: null == isRemoving ? _self.isRemoving : isRemoving // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
