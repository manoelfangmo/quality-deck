// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'business.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Business {

 String get id; String get name; String get ownerId; String get timezone; int get defaultOnsiteMinutes;
/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BusinessCopyWith<Business> get copyWith => _$BusinessCopyWithImpl<Business>(this as Business, _$identity);

  /// Serializes this Business to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Business;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Business&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.timezone, _this.timezone) || other.timezone == _this.timezone)&&(identical(other.defaultOnsiteMinutes, _this.defaultOnsiteMinutes) || other.defaultOnsiteMinutes == _this.defaultOnsiteMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Business;
  return Object.hash(runtimeType,_this.id,_this.name,_this.ownerId,_this.timezone,_this.defaultOnsiteMinutes);
}

@override
String toString() {
  final _this = this as Business;
  return 'Business(id: ${_this.id}, name: ${_this.name}, ownerId: ${_this.ownerId}, timezone: ${_this.timezone}, defaultOnsiteMinutes: ${_this.defaultOnsiteMinutes})';
}


}

/// @nodoc
abstract mixin class $BusinessCopyWith<$Res>  {
  factory $BusinessCopyWith(Business value, $Res Function(Business) _then) = _$BusinessCopyWithImpl;
@useResult
$Res call({
 String id, String name, String ownerId, String timezone, int defaultOnsiteMinutes
});




}
/// @nodoc
class _$BusinessCopyWithImpl<$Res>
    implements $BusinessCopyWith<$Res> {
  _$BusinessCopyWithImpl(this._self, this._then);

  final Business _self;
  final $Res Function(Business) _then;

/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? ownerId = null,Object? timezone = null,Object? defaultOnsiteMinutes = null,}) {
  return _then(Business(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,defaultOnsiteMinutes: null == defaultOnsiteMinutes ? _self.defaultOnsiteMinutes : defaultOnsiteMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Business].
extension BusinessPatterns on Business {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Business value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Business() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Business value)  $default,){
final _that = this;
switch (_that) {
case _Business():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Business value)?  $default,){
final _that = this;
switch (_that) {
case _Business() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String ownerId,  String timezone,  int defaultOnsiteMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Business() when $default != null:
return $default(_that.id,_that.name,_that.ownerId,_that.timezone,_that.defaultOnsiteMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String ownerId,  String timezone,  int defaultOnsiteMinutes)  $default,) {final _that = this;
switch (_that) {
case _Business():
return $default(_that.id,_that.name,_that.ownerId,_that.timezone,_that.defaultOnsiteMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String ownerId,  String timezone,  int defaultOnsiteMinutes)?  $default,) {final _that = this;
switch (_that) {
case _Business() when $default != null:
return $default(_that.id,_that.name,_that.ownerId,_that.timezone,_that.defaultOnsiteMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Business implements Business {
  const _Business({required this.id, required this.name, required this.ownerId, this.timezone = 'America/New_York', this.defaultOnsiteMinutes = 60});
  factory _Business.fromJson(Map<String, dynamic> json) => _$BusinessFromJson(json);

@override final  String id;
@override final  String name;
@override final  String ownerId;
@override@JsonKey() final  String timezone;
@override@JsonKey() final  int defaultOnsiteMinutes;

/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BusinessCopyWith<_Business> get copyWith => __$BusinessCopyWithImpl<_Business>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BusinessToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Business&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.timezone, timezone) || other.timezone == timezone)&&(identical(other.defaultOnsiteMinutes, defaultOnsiteMinutes) || other.defaultOnsiteMinutes == defaultOnsiteMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,ownerId,timezone,defaultOnsiteMinutes);
}

@override
String toString() {
    return 'Business(id: $id, name: $name, ownerId: $ownerId, timezone: $timezone, defaultOnsiteMinutes: $defaultOnsiteMinutes)';
}


}

/// @nodoc
abstract mixin class _$BusinessCopyWith<$Res> implements $BusinessCopyWith<$Res> {
  factory _$BusinessCopyWith(_Business value, $Res Function(_Business) _then) = __$BusinessCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String ownerId, String timezone, int defaultOnsiteMinutes
});




}
/// @nodoc
class __$BusinessCopyWithImpl<$Res>
    implements _$BusinessCopyWith<$Res> {
  __$BusinessCopyWithImpl(this._self, this._then);

  final _Business _self;
  final $Res Function(_Business) _then;

/// Create a copy of Business
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? ownerId = null,Object? timezone = null,Object? defaultOnsiteMinutes = null,}) {
  return _then(_Business(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,timezone: null == timezone ? _self.timezone : timezone // ignore: cast_nullable_to_non_nullable
as String,defaultOnsiteMinutes: null == defaultOnsiteMinutes ? _self.defaultOnsiteMinutes : defaultOnsiteMinutes // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
