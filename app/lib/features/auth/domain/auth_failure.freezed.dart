// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_failure.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthFailure {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;



}

/// @nodoc
class $AuthFailureCopyWith<$Res>  {
$AuthFailureCopyWith(AuthFailure _, $Res Function(AuthFailure) __);
}


/// Adds pattern-matching-related methods to [AuthFailure].
extension AuthFailurePatterns on AuthFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( InvalidCredentials value)?  invalidCredentials,TResult Function( EmailInUse value)?  emailInUse,TResult Function( WeakPassword value)?  weakPassword,TResult Function( NetworkFailure value)?  network,TResult Function( UnknownAuthFailure value)?  unknown,required TResult orElse(),}){
final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case EmailInUse() when emailInUse != null:
return emailInUse(_that);case WeakPassword() when weakPassword != null:
return weakPassword(_that);case NetworkFailure() when network != null:
return network(_that);case UnknownAuthFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( InvalidCredentials value)  invalidCredentials,required TResult Function( EmailInUse value)  emailInUse,required TResult Function( WeakPassword value)  weakPassword,required TResult Function( NetworkFailure value)  network,required TResult Function( UnknownAuthFailure value)  unknown,}){
final _that = this;
switch (_that) {
case InvalidCredentials():
return invalidCredentials(_that);case EmailInUse():
return emailInUse(_that);case WeakPassword():
return weakPassword(_that);case NetworkFailure():
return network(_that);case UnknownAuthFailure():
return unknown(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( InvalidCredentials value)?  invalidCredentials,TResult? Function( EmailInUse value)?  emailInUse,TResult? Function( WeakPassword value)?  weakPassword,TResult? Function( NetworkFailure value)?  network,TResult? Function( UnknownAuthFailure value)?  unknown,}){
final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials(_that);case EmailInUse() when emailInUse != null:
return emailInUse(_that);case WeakPassword() when weakPassword != null:
return weakPassword(_that);case NetworkFailure() when network != null:
return network(_that);case UnknownAuthFailure() when unknown != null:
return unknown(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  invalidCredentials,TResult Function()?  emailInUse,TResult Function()?  weakPassword,TResult Function()?  network,TResult Function()?  unknown,required TResult orElse(),}) {final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case EmailInUse() when emailInUse != null:
return emailInUse();case WeakPassword() when weakPassword != null:
return weakPassword();case NetworkFailure() when network != null:
return network();case UnknownAuthFailure() when unknown != null:
return unknown();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  invalidCredentials,required TResult Function()  emailInUse,required TResult Function()  weakPassword,required TResult Function()  network,required TResult Function()  unknown,}) {final _that = this;
switch (_that) {
case InvalidCredentials():
return invalidCredentials();case EmailInUse():
return emailInUse();case WeakPassword():
return weakPassword();case NetworkFailure():
return network();case UnknownAuthFailure():
return unknown();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  invalidCredentials,TResult? Function()?  emailInUse,TResult? Function()?  weakPassword,TResult? Function()?  network,TResult? Function()?  unknown,}) {final _that = this;
switch (_that) {
case InvalidCredentials() when invalidCredentials != null:
return invalidCredentials();case EmailInUse() when emailInUse != null:
return emailInUse();case WeakPassword() when weakPassword != null:
return weakPassword();case NetworkFailure() when network != null:
return network();case UnknownAuthFailure() when unknown != null:
return unknown();case _:
  return null;

}
}

}

/// @nodoc


class InvalidCredentials extends AuthFailure {
  const InvalidCredentials(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is InvalidCredentials);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class EmailInUse extends AuthFailure {
  const EmailInUse(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailInUse);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class WeakPassword extends AuthFailure {
  const WeakPassword(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakPassword);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class NetworkFailure extends AuthFailure {
  const NetworkFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFailure);
}


@override
int get hashCode => runtimeType.hashCode;



}




/// @nodoc


class UnknownAuthFailure extends AuthFailure {
  const UnknownAuthFailure(): super._();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is UnknownAuthFailure);
}


@override
int get hashCode => runtimeType.hashCode;



}




// dart format on
