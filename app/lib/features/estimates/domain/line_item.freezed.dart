// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'line_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LineItem {

 String get id; String get jobId; int get position; bool get isCustom; String? get priceItemId; String get name; String? get description; PricingType get pricingType; Quantity get quantity; Money get savedPrice; Money? get overridePrice; Money get total;
/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineItemCopyWith<LineItem> get copyWith => _$LineItemCopyWithImpl<LineItem>(this as LineItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as LineItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LineItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.jobId, _this.jobId) || other.jobId == _this.jobId)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.isCustom, _this.isCustom) || other.isCustom == _this.isCustom)&&(identical(other.priceItemId, _this.priceItemId) || other.priceItemId == _this.priceItemId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.pricingType, _this.pricingType) || other.pricingType == _this.pricingType)&&(identical(other.quantity, _this.quantity) || other.quantity == _this.quantity)&&(identical(other.savedPrice, _this.savedPrice) || other.savedPrice == _this.savedPrice)&&(identical(other.overridePrice, _this.overridePrice) || other.overridePrice == _this.overridePrice)&&(identical(other.total, _this.total) || other.total == _this.total));
}


@override
int get hashCode {
  final _this = this as LineItem;
  return Object.hash(runtimeType,_this.id,_this.jobId,_this.position,_this.isCustom,_this.priceItemId,_this.name,_this.description,_this.pricingType,_this.quantity,_this.savedPrice,_this.overridePrice,_this.total);
}

@override
String toString() {
  final _this = this as LineItem;
  return 'LineItem(id: ${_this.id}, jobId: ${_this.jobId}, position: ${_this.position}, isCustom: ${_this.isCustom}, priceItemId: ${_this.priceItemId}, name: ${_this.name}, description: ${_this.description}, pricingType: ${_this.pricingType}, quantity: ${_this.quantity}, savedPrice: ${_this.savedPrice}, overridePrice: ${_this.overridePrice}, total: ${_this.total})';
}


}

/// @nodoc
abstract mixin class $LineItemCopyWith<$Res>  {
  factory $LineItemCopyWith(LineItem value, $Res Function(LineItem) _then) = _$LineItemCopyWithImpl;
@useResult
$Res call({
 String id, String jobId, int position, bool isCustom, String? priceItemId, String name, String? description, PricingType pricingType, Quantity quantity, Money savedPrice, Money? overridePrice, Money total
});




}
/// @nodoc
class _$LineItemCopyWithImpl<$Res>
    implements $LineItemCopyWith<$Res> {
  _$LineItemCopyWithImpl(this._self, this._then);

  final LineItem _self;
  final $Res Function(LineItem) _then;

/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? jobId = null,Object? position = null,Object? isCustom = null,Object? priceItemId = freezed,Object? name = null,Object? description = freezed,Object? pricingType = null,Object? quantity = null,Object? savedPrice = null,Object? overridePrice = freezed,Object? total = null,}) {
  return _then(LineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,priceItemId: freezed == priceItemId ? _self.priceItemId : priceItemId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricingType: null == pricingType ? _self.pricingType : pricingType // ignore: cast_nullable_to_non_nullable
as PricingType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,savedPrice: null == savedPrice ? _self.savedPrice : savedPrice // ignore: cast_nullable_to_non_nullable
as Money,overridePrice: freezed == overridePrice ? _self.overridePrice : overridePrice // ignore: cast_nullable_to_non_nullable
as Money?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}

}


/// Adds pattern-matching-related methods to [LineItem].
extension LineItemPatterns on LineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LineItem value)  $default,){
final _that = this;
switch (_that) {
case _LineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LineItem value)?  $default,){
final _that = this;
switch (_that) {
case _LineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String jobId,  int position,  bool isCustom,  String? priceItemId,  String name,  String? description,  PricingType pricingType,  Quantity quantity,  Money savedPrice,  Money? overridePrice,  Money total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LineItem() when $default != null:
return $default(_that.id,_that.jobId,_that.position,_that.isCustom,_that.priceItemId,_that.name,_that.description,_that.pricingType,_that.quantity,_that.savedPrice,_that.overridePrice,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String jobId,  int position,  bool isCustom,  String? priceItemId,  String name,  String? description,  PricingType pricingType,  Quantity quantity,  Money savedPrice,  Money? overridePrice,  Money total)  $default,) {final _that = this;
switch (_that) {
case _LineItem():
return $default(_that.id,_that.jobId,_that.position,_that.isCustom,_that.priceItemId,_that.name,_that.description,_that.pricingType,_that.quantity,_that.savedPrice,_that.overridePrice,_that.total);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String jobId,  int position,  bool isCustom,  String? priceItemId,  String name,  String? description,  PricingType pricingType,  Quantity quantity,  Money savedPrice,  Money? overridePrice,  Money total)?  $default,) {final _that = this;
switch (_that) {
case _LineItem() when $default != null:
return $default(_that.id,_that.jobId,_that.position,_that.isCustom,_that.priceItemId,_that.name,_that.description,_that.pricingType,_that.quantity,_that.savedPrice,_that.overridePrice,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _LineItem extends LineItem {
  const _LineItem({required this.id, required this.jobId, required this.position, required this.isCustom, this.priceItemId, required this.name, this.description, required this.pricingType, required this.quantity, required this.savedPrice, this.overridePrice, required this.total}): super._();
  

@override final  String id;
@override final  String jobId;
@override final  int position;
@override final  bool isCustom;
@override final  String? priceItemId;
@override final  String name;
@override final  String? description;
@override final  PricingType pricingType;
@override final  Quantity quantity;
@override final  Money savedPrice;
@override final  Money? overridePrice;
@override final  Money total;

/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineItemCopyWith<_LineItem> get copyWith => __$LineItemCopyWithImpl<_LineItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.position, position) || other.position == position)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom)&&(identical(other.priceItemId, priceItemId) || other.priceItemId == priceItemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.pricingType, pricingType) || other.pricingType == pricingType)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.savedPrice, savedPrice) || other.savedPrice == savedPrice)&&(identical(other.overridePrice, overridePrice) || other.overridePrice == overridePrice)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,jobId,position,isCustom,priceItemId,name,description,pricingType,quantity,savedPrice,overridePrice,total);
}

@override
String toString() {
    return 'LineItem(id: $id, jobId: $jobId, position: $position, isCustom: $isCustom, priceItemId: $priceItemId, name: $name, description: $description, pricingType: $pricingType, quantity: $quantity, savedPrice: $savedPrice, overridePrice: $overridePrice, total: $total)';
}


}

/// @nodoc
abstract mixin class _$LineItemCopyWith<$Res> implements $LineItemCopyWith<$Res> {
  factory _$LineItemCopyWith(_LineItem value, $Res Function(_LineItem) _then) = __$LineItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String jobId, int position, bool isCustom, String? priceItemId, String name, String? description, PricingType pricingType, Quantity quantity, Money savedPrice, Money? overridePrice, Money total
});




}
/// @nodoc
class __$LineItemCopyWithImpl<$Res>
    implements _$LineItemCopyWith<$Res> {
  __$LineItemCopyWithImpl(this._self, this._then);

  final _LineItem _self;
  final $Res Function(_LineItem) _then;

/// Create a copy of LineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? jobId = null,Object? position = null,Object? isCustom = null,Object? priceItemId = freezed,Object? name = null,Object? description = freezed,Object? pricingType = null,Object? quantity = null,Object? savedPrice = null,Object? overridePrice = freezed,Object? total = null,}) {
  return _then(_LineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,priceItemId: freezed == priceItemId ? _self.priceItemId : priceItemId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,pricingType: null == pricingType ? _self.pricingType : pricingType // ignore: cast_nullable_to_non_nullable
as PricingType,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as Quantity,savedPrice: null == savedPrice ? _self.savedPrice : savedPrice // ignore: cast_nullable_to_non_nullable
as Money,overridePrice: freezed == overridePrice ? _self.overridePrice : overridePrice // ignore: cast_nullable_to_non_nullable
as Money?,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as Money,
  ));
}


}

// dart format on
