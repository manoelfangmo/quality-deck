// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignUpFormState {

 String get fullName; String get email; String get password; bool get obscurePassword; bool get isSubmitting; AuthFailure? get failure;
/// Create a copy of SignUpFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpFormStateCopyWith<SignUpFormState> get copyWith => _$SignUpFormStateCopyWithImpl<SignUpFormState>(this as SignUpFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SignUpFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpFormState&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.obscurePassword, _this.obscurePassword) || other.obscurePassword == _this.obscurePassword)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.failure, _this.failure) || other.failure == _this.failure));
}


@override
int get hashCode {
  final _this = this as SignUpFormState;
  return Object.hash(runtimeType,_this.fullName,_this.email,_this.password,_this.obscurePassword,_this.isSubmitting,_this.failure);
}

@override
String toString() {
  final _this = this as SignUpFormState;
  return 'SignUpFormState(fullName: ${_this.fullName}, email: ${_this.email}, password: ${_this.password}, obscurePassword: ${_this.obscurePassword}, isSubmitting: ${_this.isSubmitting}, failure: ${_this.failure})';
}


}

/// @nodoc
abstract mixin class $SignUpFormStateCopyWith<$Res>  {
  factory $SignUpFormStateCopyWith(SignUpFormState value, $Res Function(SignUpFormState) _then) = _$SignUpFormStateCopyWithImpl;
@useResult
$Res call({
 String fullName, String email, String password, bool obscurePassword, bool isSubmitting, AuthFailure? failure
});


$AuthFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$SignUpFormStateCopyWithImpl<$Res>
    implements $SignUpFormStateCopyWith<$Res> {
  _$SignUpFormStateCopyWithImpl(this._self, this._then);

  final SignUpFormState _self;
  final $Res Function(SignUpFormState) _then;

/// Create a copy of SignUpFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? email = null,Object? password = null,Object? obscurePassword = null,Object? isSubmitting = null,Object? failure = freezed,}) {
  return _then(SignUpFormState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,
  ));
}
/// Create a copy of SignUpFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $AuthFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [SignUpFormState].
extension SignUpFormStatePatterns on SignUpFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignUpFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignUpFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignUpFormState value)  $default,){
final _that = this;
switch (_that) {
case _SignUpFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignUpFormState value)?  $default,){
final _that = this;
switch (_that) {
case _SignUpFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String email,  String password,  bool obscurePassword,  bool isSubmitting,  AuthFailure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpFormState() when $default != null:
return $default(_that.fullName,_that.email,_that.password,_that.obscurePassword,_that.isSubmitting,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String email,  String password,  bool obscurePassword,  bool isSubmitting,  AuthFailure? failure)  $default,) {final _that = this;
switch (_that) {
case _SignUpFormState():
return $default(_that.fullName,_that.email,_that.password,_that.obscurePassword,_that.isSubmitting,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String email,  String password,  bool obscurePassword,  bool isSubmitting,  AuthFailure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SignUpFormState() when $default != null:
return $default(_that.fullName,_that.email,_that.password,_that.obscurePassword,_that.isSubmitting,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SignUpFormState implements SignUpFormState {
  const _SignUpFormState({this.fullName = '', this.email = '', this.password = '', this.obscurePassword = true, this.isSubmitting = false, this.failure});
  

@override@JsonKey() final  String fullName;
@override@JsonKey() final  String email;
@override@JsonKey() final  String password;
@override@JsonKey() final  bool obscurePassword;
@override@JsonKey() final  bool isSubmitting;
@override final  AuthFailure? failure;

/// Create a copy of SignUpFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpFormStateCopyWith<_SignUpFormState> get copyWith => __$SignUpFormStateCopyWithImpl<_SignUpFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpFormState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.obscurePassword, obscurePassword) || other.obscurePassword == obscurePassword)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fullName,email,password,obscurePassword,isSubmitting,failure);
}

@override
String toString() {
    return 'SignUpFormState(fullName: $fullName, email: $email, password: $password, obscurePassword: $obscurePassword, isSubmitting: $isSubmitting, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SignUpFormStateCopyWith<$Res> implements $SignUpFormStateCopyWith<$Res> {
  factory _$SignUpFormStateCopyWith(_SignUpFormState value, $Res Function(_SignUpFormState) _then) = __$SignUpFormStateCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String email, String password, bool obscurePassword, bool isSubmitting, AuthFailure? failure
});


@override $AuthFailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$SignUpFormStateCopyWithImpl<$Res>
    implements _$SignUpFormStateCopyWith<$Res> {
  __$SignUpFormStateCopyWithImpl(this._self, this._then);

  final _SignUpFormState _self;
  final $Res Function(_SignUpFormState) _then;

/// Create a copy of SignUpFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? email = null,Object? password = null,Object? obscurePassword = null,Object? isSubmitting = null,Object? failure = freezed,}) {
  return _then(_SignUpFormState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,obscurePassword: null == obscurePassword ? _self.obscurePassword : obscurePassword // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as AuthFailure?,
  ));
}

/// Create a copy of SignUpFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthFailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $AuthFailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
