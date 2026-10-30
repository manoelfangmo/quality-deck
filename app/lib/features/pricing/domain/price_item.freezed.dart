// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PriceItem {

 String get id; String get name; String? get description; PricingType get pricingType; Money get price; DateTime get updatedAt;
/// Create a copy of PriceItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceItemCopyWith<PriceItem> get copyWith => _$PriceItemCopyWithImpl<PriceItem>(this as PriceItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.pricingType, _this.pricingType) || other.pricingType == _this.pricingType)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}


@override
int get hashCode {
  final _this = this as PriceItem;
  return Object.hash(runtimeType,_this.id,_this.name,_this.description,_this.pricingType,_this.price,_this.updatedAt);
}

@override
String toString() {
  final _this = this as PriceItem;
  return 'PriceItem(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, pricingType: ${_this.pricingType}, price: ${_this.price}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $PriceItemCopyWith<$Res>  {
  factory $PriceItemCopyWith(PriceItem value, $Res Function(PriceItem) _then) = _$PriceItemCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, PricingType pricingType, Money price, DateTime updatedAt
});




}
/// @nodoc
class _$PriceItemCopyWithImpl<$Res>
    implements $PriceItemCopyWith<$Res> {
  _$PriceItemCopyWithImpl(this._self, this._then);

  final PriceItem _self;
  final $Res Function(PriceItem) _then;

/// Create a copy of PriceItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? pricingType = null,Object? price = null,Object? updatedAt = null,}) {
  return _then(PriceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricingType: null == pricingType ? _self.pricingType : pricingType // ignore: cast_nullable_to_non_nullable
as PricingType,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceItem].
extension PriceItemPatterns on PriceItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceItem value)  $default,){
final _that = this;
switch (_that) {
case _PriceItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceItem value)?  $default,){
final _that = this;
switch (_that) {
case _PriceItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  PricingType pricingType,  Money price,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceItem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pricingType,_that.price,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  PricingType pricingType,  Money price,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PriceItem():
return $default(_that.id,_that.name,_that.description,_that.pricingType,_that.price,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  PricingType pricingType,  Money price,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PriceItem() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.pricingType,_that.price,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _PriceItem extends PriceItem {
  const _PriceItem({required this.id, required this.name, this.description, required this.pricingType, required this.price, required this.updatedAt}): super._();
  

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  PricingType pricingType;
@override final  Money price;
@override final  DateTime updatedAt;

/// Create a copy of PriceItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceItemCopyWith<_PriceItem> get copyWith => __$PriceItemCopyWithImpl<_PriceItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceItem&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.pricingType, pricingType) || other.pricingType == pricingType)&&(identical(other.price, price) || other.price == price)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,description,pricingType,price,updatedAt);
}

@override
String toString() {
    return 'PriceItem(id: $id, name: $name, description: $description, pricingType: $pricingType, price: $price, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PriceItemCopyWith<$Res> implements $PriceItemCopyWith<$Res> {
  factory _$PriceItemCopyWith(_PriceItem value, $Res Function(_PriceItem) _then) = __$PriceItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, PricingType pricingType, Money price, DateTime updatedAt
});




}
/// @nodoc
class __$PriceItemCopyWithImpl<$Res>
    implements _$PriceItemCopyWith<$Res> {
  __$PriceItemCopyWithImpl(this._self, this._then);

  final _PriceItem _self;
  final $Res Function(_PriceItem) _then;

/// Create a copy of PriceItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? pricingType = null,Object? price = null,Object? updatedAt = null,}) {
  return _then(_PriceItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricingType: null == pricingType ? _self.pricingType : pricingType // ignore: cast_nullable_to_non_nullable
as PricingType,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as Money,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
