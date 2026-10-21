// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingFormState {

 String get inviteCode; String get businessName; bool get isSubmitting; String? get errorMessage;
/// Create a copy of OnboardingFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingFormStateCopyWith<OnboardingFormState> get copyWith => _$OnboardingFormStateCopyWithImpl<OnboardingFormState>(this as OnboardingFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OnboardingFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingFormState&&(identical(other.inviteCode, _this.inviteCode) || other.inviteCode == _this.inviteCode)&&(identical(other.businessName, _this.businessName) || other.businessName == _this.businessName)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage));
}


@override
int get hashCode {
  final _this = this as OnboardingFormState;
  return Object.hash(runtimeType,_this.inviteCode,_this.businessName,_this.isSubmitting,_this.errorMessage);
}

@override
String toString() {
  final _this = this as OnboardingFormState;
  return 'OnboardingFormState(inviteCode: ${_this.inviteCode}, businessName: ${_this.businessName}, isSubmitting: ${_this.isSubmitting}, errorMessage: ${_this.errorMessage})';
}


}

/// @nodoc
abstract mixin class $OnboardingFormStateCopyWith<$Res>  {
  factory $OnboardingFormStateCopyWith(OnboardingFormState value, $Res Function(OnboardingFormState) _then) = _$OnboardingFormStateCopyWithImpl;
@useResult
$Res call({
 String inviteCode, String businessName, bool isSubmitting, String? errorMessage
});




}
/// @nodoc
class _$OnboardingFormStateCopyWithImpl<$Res>
    implements $OnboardingFormStateCopyWith<$Res> {
  _$OnboardingFormStateCopyWithImpl(this._self, this._then);

  final OnboardingFormState _self;
  final $Res Function(OnboardingFormState) _then;

/// Create a copy of OnboardingFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inviteCode = null,Object? businessName = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(OnboardingFormState(
inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingFormState].
extension OnboardingFormStatePatterns on OnboardingFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingFormState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingFormState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inviteCode,  String businessName,  bool isSubmitting,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingFormState() when $default != null:
return $default(_that.inviteCode,_that.businessName,_that.isSubmitting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inviteCode,  String businessName,  bool isSubmitting,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _OnboardingFormState():
return $default(_that.inviteCode,_that.businessName,_that.isSubmitting,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inviteCode,  String businessName,  bool isSubmitting,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingFormState() when $default != null:
return $default(_that.inviteCode,_that.businessName,_that.isSubmitting,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingFormState extends OnboardingFormState {
  const _OnboardingFormState({this.inviteCode = '', this.businessName = '', this.isSubmitting = false, this.errorMessage}): super._();
  

@override@JsonKey() final  String inviteCode;
@override@JsonKey() final  String businessName;
@override@JsonKey() final  bool isSubmitting;
@override final  String? errorMessage;

/// Create a copy of OnboardingFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingFormStateCopyWith<_OnboardingFormState> get copyWith => __$OnboardingFormStateCopyWithImpl<_OnboardingFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingFormState&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.businessName, businessName) || other.businessName == businessName)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode {
    return Object.hash(runtimeType,inviteCode,businessName,isSubmitting,errorMessage);
}

@override
String toString() {
    return 'OnboardingFormState(inviteCode: $inviteCode, businessName: $businessName, isSubmitting: $isSubmitting, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$OnboardingFormStateCopyWith<$Res> implements $OnboardingFormStateCopyWith<$Res> {
  factory _$OnboardingFormStateCopyWith(_OnboardingFormState value, $Res Function(_OnboardingFormState) _then) = __$OnboardingFormStateCopyWithImpl;
@override @useResult
$Res call({
 String inviteCode, String businessName, bool isSubmitting, String? errorMessage
});




}
/// @nodoc
class __$OnboardingFormStateCopyWithImpl<$Res>
    implements _$OnboardingFormStateCopyWith<$Res> {
  __$OnboardingFormStateCopyWithImpl(this._self, this._then);

  final _OnboardingFormState _self;
  final $Res Function(_OnboardingFormState) _then;

/// Create a copy of OnboardingFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inviteCode = null,Object? businessName = null,Object? isSubmitting = null,Object? errorMessage = freezed,}) {
  return _then(_OnboardingFormState(
inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,businessName: null == businessName ? _self.businessName : businessName // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
