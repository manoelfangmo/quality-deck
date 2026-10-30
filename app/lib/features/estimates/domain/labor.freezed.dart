// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'labor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Labor {

 Quantity get hours; Money get rate;
/// Create a copy of Labor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LaborCopyWith<Labor> get copyWith => _$LaborCopyWithImpl<Labor>(this as Labor, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Labor;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Labor&&(identical(other.hours, _this.hours) || other.hours == _this.hours)&&(identical(other.rate, _this.rate) || other.rate == _this.rate));
}


@override
int get hashCode {
  final _this = this as Labor;
  return Object.hash(runtimeType,_this.hours,_this.rate);
}

@override
String toString() {
  final _this = this as Labor;
  return 'Labor(hours: ${_this.hours}, rate: ${_this.rate})';
}


}

/// @nodoc
abstract mixin class $LaborCopyWith<$Res>  {
  factory $LaborCopyWith(Labor value, $Res Function(Labor) _then) = _$LaborCopyWithImpl;
@useResult
$Res call({
 Quantity hours, Money rate
});




}
/// @nodoc
class _$LaborCopyWithImpl<$Res>
    implements $LaborCopyWith<$Res> {
  _$LaborCopyWithImpl(this._self, this._then);

  final Labor _self;
  final $Res Function(Labor) _then;

/// Create a copy of Labor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hours = null,Object? rate = null,}) {
  return _then(Labor(
hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as Quantity,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [Labor].
extension LaborPatterns on Labor {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Labor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Labor() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Labor value)  $default,){
final _that = this;
switch (_that) {
case _Labor():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Labor value)?  $default,){
final _that = this;
switch (_that) {
case _Labor() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Quantity hours,  Money rate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Labor() when $default != null:
return $default(_that.hours,_that.rate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Quantity hours,  Money rate)  $default,) {final _that = this;
switch (_that) {
case _Labor():
return $default(_that.hours,_that.rate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Quantity hours,  Money rate)?  $default,) {final _that = this;
switch (_that) {
case _Labor() when $default != null:
return $default(_that.hours,_that.rate);case _:
  return null;

}
}

}

/// @nodoc


class _Labor extends Labor {
  const _Labor({required this.hours, required this.rate}): super._();
  

@override final  Quantity hours;
@override final  Money rate;

/// Create a copy of Labor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LaborCopyWith<_Labor> get copyWith => __$LaborCopyWithImpl<_Labor>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Labor&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.rate, rate) || other.rate == rate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,hours,rate);
}

@override
String toString() {
    return 'Labor(hours: $hours, rate: $rate)';
}


}

/// @nodoc
abstract mixin class _$LaborCopyWith<$Res> implements $LaborCopyWith<$Res> {
  factory _$LaborCopyWith(_Labor value, $Res Function(_Labor) _then) = __$LaborCopyWithImpl;
@override @useResult
$Res call({
 Quantity hours, Money rate
});




}
/// @nodoc
class __$LaborCopyWithImpl<$Res>
    implements _$LaborCopyWith<$Res> {
  __$LaborCopyWithImpl(this._self, this._then);

  final _Labor _self;
  final $Res Function(_Labor) _then;

/// Create a copy of Labor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hours = null,Object? rate = null,}) {
  return _then(_Labor(
hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as Quantity,rate: null == rate ? _self.rate : rate // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

// dart format on
