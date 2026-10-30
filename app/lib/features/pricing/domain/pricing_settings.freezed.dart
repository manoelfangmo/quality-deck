// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pricing_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PricingSettings {

 Money? get laborRate; Percent? get overhead; DateTime get updatedAt; String? get updatedByName;
/// Create a copy of PricingSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricingSettingsCopyWith<PricingSettings> get copyWith => _$PricingSettingsCopyWithImpl<PricingSettings>(this as PricingSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PricingSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricingSettings&&(identical(other.laborRate, _this.laborRate) || other.laborRate == _this.laborRate)&&(identical(other.overhead, _this.overhead) || other.overhead == _this.overhead)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.updatedByName, _this.updatedByName) || other.updatedByName == _this.updatedByName));
}


@override
int get hashCode {
  final _this = this as PricingSettings;
  return Object.hash(runtimeType,_this.laborRate,_this.overhead,_this.updatedAt,_this.updatedByName);
}

@override
String toString() {
  final _this = this as PricingSettings;
  return 'PricingSettings(laborRate: ${_this.laborRate}, overhead: ${_this.overhead}, updatedAt: ${_this.updatedAt}, updatedByName: ${_this.updatedByName})';
}


}

/// @nodoc
abstract mixin class $PricingSettingsCopyWith<$Res>  {
  factory $PricingSettingsCopyWith(PricingSettings value, $Res Function(PricingSettings) _then) = _$PricingSettingsCopyWithImpl;
@useResult
$Res call({
 Money? laborRate, Percent? overhead, DateTime updatedAt, String? updatedByName
});




}
/// @nodoc
class _$PricingSettingsCopyWithImpl<$Res>
    implements $PricingSettingsCopyWith<$Res> {
  _$PricingSettingsCopyWithImpl(this._self, this._then);

  final PricingSettings _self;
  final $Res Function(PricingSettings) _then;

/// Create a copy of PricingSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? laborRate = freezed,Object? overhead = freezed,Object? updatedAt = null,Object? updatedByName = freezed,}) {
  return _then(PricingSettings(
laborRate: freezed == laborRate ? _self.laborRate : laborRate // ignore: cast_nullable_to_non_nullable
as Money?,overhead: freezed == overhead ? _self.overhead : overhead // ignore: cast_nullable_to_non_nullable
as Percent?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedByName: freezed == updatedByName ? _self.updatedByName : updatedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PricingSettings].
extension PricingSettingsPatterns on PricingSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricingSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricingSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricingSettings value)  $default,){
final _that = this;
switch (_that) {
case _PricingSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricingSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PricingSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Money? laborRate,  Percent? overhead,  DateTime updatedAt,  String? updatedByName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PricingSettings() when $default != null:
return $default(_that.laborRate,_that.overhead,_that.updatedAt,_that.updatedByName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Money? laborRate,  Percent? overhead,  DateTime updatedAt,  String? updatedByName)  $default,) {final _that = this;
switch (_that) {
case _PricingSettings():
return $default(_that.laborRate,_that.overhead,_that.updatedAt,_that.updatedByName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Money? laborRate,  Percent? overhead,  DateTime updatedAt,  String? updatedByName)?  $default,) {final _that = this;
switch (_that) {
case _PricingSettings() when $default != null:
return $default(_that.laborRate,_that.overhead,_that.updatedAt,_that.updatedByName);case _:
  return null;

}
}

}

/// @nodoc


class _PricingSettings implements PricingSettings {
  const _PricingSettings({this.laborRate, this.overhead, required this.updatedAt, this.updatedByName});
  

@override final  Money? laborRate;
@override final  Percent? overhead;
@override final  DateTime updatedAt;
@override final  String? updatedByName;

/// Create a copy of PricingSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricingSettingsCopyWith<_PricingSettings> get copyWith => __$PricingSettingsCopyWithImpl<_PricingSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricingSettings&&(identical(other.laborRate, laborRate) || other.laborRate == laborRate)&&(identical(other.overhead, overhead) || other.overhead == overhead)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.updatedByName, updatedByName) || other.updatedByName == updatedByName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,laborRate,overhead,updatedAt,updatedByName);
}

@override
String toString() {
    return 'PricingSettings(laborRate: $laborRate, overhead: $overhead, updatedAt: $updatedAt, updatedByName: $updatedByName)';
}


}

/// @nodoc
abstract mixin class _$PricingSettingsCopyWith<$Res> implements $PricingSettingsCopyWith<$Res> {
  factory _$PricingSettingsCopyWith(_PricingSettings value, $Res Function(_PricingSettings) _then) = __$PricingSettingsCopyWithImpl;
@override @useResult
$Res call({
 Money? laborRate, Percent? overhead, DateTime updatedAt, String? updatedByName
});




}
/// @nodoc
class __$PricingSettingsCopyWithImpl<$Res>
    implements _$PricingSettingsCopyWith<$Res> {
  __$PricingSettingsCopyWithImpl(this._self, this._then);

  final _PricingSettings _self;
  final $Res Function(_PricingSettings) _then;

/// Create a copy of PricingSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? laborRate = freezed,Object? overhead = freezed,Object? updatedAt = null,Object? updatedByName = freezed,}) {
  return _then(_PricingSettings(
laborRate: freezed == laborRate ? _self.laborRate : laborRate // ignore: cast_nullable_to_non_nullable
as Money?,overhead: freezed == overhead ? _self.overhead : overhead // ignore: cast_nullable_to_non_nullable
as Percent?,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedByName: freezed == updatedByName ? _self.updatedByName : updatedByName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
