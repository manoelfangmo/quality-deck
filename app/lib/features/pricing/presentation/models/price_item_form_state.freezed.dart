// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_item_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PriceItemFormState {

 PriceItemFormMode get mode; String? get itemId; String get name; String get description; PricingType? get pricingType; String get price; bool get isSubmitting; bool get submitted; String? get errorMessage; String? get nameError; String? get descriptionError; String? get pricingTypeError; String? get priceError;
/// Create a copy of PriceItemFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceItemFormStateCopyWith<PriceItemFormState> get copyWith => _$PriceItemFormStateCopyWithImpl<PriceItemFormState>(this as PriceItemFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PriceItemFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceItemFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.itemId, _this.itemId) || other.itemId == _this.itemId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.pricingType, _this.pricingType) || other.pricingType == _this.pricingType)&&(identical(other.price, _this.price) || other.price == _this.price)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.descriptionError, _this.descriptionError) || other.descriptionError == _this.descriptionError)&&(identical(other.pricingTypeError, _this.pricingTypeError) || other.pricingTypeError == _this.pricingTypeError)&&(identical(other.priceError, _this.priceError) || other.priceError == _this.priceError));
}


@override
int get hashCode {
  final _this = this as PriceItemFormState;
  return Object.hash(runtimeType,_this.mode,_this.itemId,_this.name,_this.description,_this.pricingType,_this.price,_this.isSubmitting,_this.submitted,_this.errorMessage,_this.nameError,_this.descriptionError,_this.pricingTypeError,_this.priceError);
}

@override
String toString() {
  final _this = this as PriceItemFormState;
  return 'PriceItemFormState(mode: ${_this.mode}, itemId: ${_this.itemId}, name: ${_this.name}, description: ${_this.description}, pricingType: ${_this.pricingType}, price: ${_this.price}, isSubmitting: ${_this.isSubmitting}, submitted: ${_this.submitted}, errorMessage: ${_this.errorMessage}, nameError: ${_this.nameError}, descriptionError: ${_this.descriptionError}, pricingTypeError: ${_this.pricingTypeError}, priceError: ${_this.priceError})';
}


}

/// @nodoc
abstract mixin class $PriceItemFormStateCopyWith<$Res>  {
  factory $PriceItemFormStateCopyWith(PriceItemFormState value, $Res Function(PriceItemFormState) _then) = _$PriceItemFormStateCopyWithImpl;
@useResult
$Res call({
 PriceItemFormMode mode, String? itemId, String name, String description, PricingType? pricingType, String price, bool isSubmitting, bool submitted, String? errorMessage, String? nameError, String? descriptionError, String? pricingTypeError, String? priceError
});




}
/// @nodoc
class _$PriceItemFormStateCopyWithImpl<$Res>
    implements $PriceItemFormStateCopyWith<$Res> {
  _$PriceItemFormStateCopyWithImpl(this._self, this._then);

  final PriceItemFormState _self;
  final $Res Function(PriceItemFormState) _then;

/// Create a copy of PriceItemFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? itemId = freezed,Object? name = null,Object? description = null,Object? pricingType = freezed,Object? price = null,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? nameError = freezed,Object? descriptionError = freezed,Object? pricingTypeError = freezed,Object? priceError = freezed,}) {
  return _then(PriceItemFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PriceItemFormMode,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pricingType: freezed == pricingType ? _self.pricingType : pricingType // ignore: cast_nullable_to_non_nullable
as PricingType?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,descriptionError: freezed == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String?,pricingTypeError: freezed == pricingTypeError ? _self.pricingTypeError : pricingTypeError // ignore: cast_nullable_to_non_nullable
as String?,priceError: freezed == priceError ? _self.priceError : priceError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceItemFormState].
extension PriceItemFormStatePatterns on PriceItemFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceItemFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceItemFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceItemFormState value)  $default,){
final _that = this;
switch (_that) {
case _PriceItemFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceItemFormState value)?  $default,){
final _that = this;
switch (_that) {
case _PriceItemFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PriceItemFormMode mode,  String? itemId,  String name,  String description,  PricingType? pricingType,  String price,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? nameError,  String? descriptionError,  String? pricingTypeError,  String? priceError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceItemFormState() when $default != null:
return $default(_that.mode,_that.itemId,_that.name,_that.description,_that.pricingType,_that.price,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.nameError,_that.descriptionError,_that.pricingTypeError,_that.priceError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PriceItemFormMode mode,  String? itemId,  String name,  String description,  PricingType? pricingType,  String price,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? nameError,  String? descriptionError,  String? pricingTypeError,  String? priceError)  $default,) {final _that = this;
switch (_that) {
case _PriceItemFormState():
return $default(_that.mode,_that.itemId,_that.name,_that.description,_that.pricingType,_that.price,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.nameError,_that.descriptionError,_that.pricingTypeError,_that.priceError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PriceItemFormMode mode,  String? itemId,  String name,  String description,  PricingType? pricingType,  String price,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? nameError,  String? descriptionError,  String? pricingTypeError,  String? priceError)?  $default,) {final _that = this;
switch (_that) {
case _PriceItemFormState() when $default != null:
return $default(_that.mode,_that.itemId,_that.name,_that.description,_that.pricingType,_that.price,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.nameError,_that.descriptionError,_that.pricingTypeError,_that.priceError);case _:
  return null;

}
}

}

/// @nodoc


class _PriceItemFormState extends PriceItemFormState {
  const _PriceItemFormState({this.mode = PriceItemFormMode.add, this.itemId, this.name = '', this.description = '', this.pricingType, this.price = '', this.isSubmitting = false, this.submitted = false, this.errorMessage, this.nameError, this.descriptionError, this.pricingTypeError, this.priceError}): super._();
  

@override@JsonKey() final  PriceItemFormMode mode;
@override final  String? itemId;
@override@JsonKey() final  String name;
@override@JsonKey() final  String description;
@override final  PricingType? pricingType;
@override@JsonKey() final  String price;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool submitted;
@override final  String? errorMessage;
@override final  String? nameError;
@override final  String? descriptionError;
@override final  String? pricingTypeError;
@override final  String? priceError;

/// Create a copy of PriceItemFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceItemFormStateCopyWith<_PriceItemFormState> get copyWith => __$PriceItemFormStateCopyWithImpl<_PriceItemFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceItemFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.pricingType, pricingType) || other.pricingType == pricingType)&&(identical(other.price, price) || other.price == price)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError)&&(identical(other.pricingTypeError, pricingTypeError) || other.pricingTypeError == pricingTypeError)&&(identical(other.priceError, priceError) || other.priceError == priceError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,itemId,name,description,pricingType,price,isSubmitting,submitted,errorMessage,nameError,descriptionError,pricingTypeError,priceError);
}

@override
String toString() {
    return 'PriceItemFormState(mode: $mode, itemId: $itemId, name: $name, description: $description, pricingType: $pricingType, price: $price, isSubmitting: $isSubmitting, submitted: $submitted, errorMessage: $errorMessage, nameError: $nameError, descriptionError: $descriptionError, pricingTypeError: $pricingTypeError, priceError: $priceError)';
}


}

/// @nodoc
abstract mixin class _$PriceItemFormStateCopyWith<$Res> implements $PriceItemFormStateCopyWith<$Res> {
  factory _$PriceItemFormStateCopyWith(_PriceItemFormState value, $Res Function(_PriceItemFormState) _then) = __$PriceItemFormStateCopyWithImpl;
@override @useResult
$Res call({
 PriceItemFormMode mode, String? itemId, String name, String description, PricingType? pricingType, String price, bool isSubmitting, bool submitted, String? errorMessage, String? nameError, String? descriptionError, String? pricingTypeError, String? priceError
});




}
/// @nodoc
class __$PriceItemFormStateCopyWithImpl<$Res>
    implements _$PriceItemFormStateCopyWith<$Res> {
  __$PriceItemFormStateCopyWithImpl(this._self, this._then);

  final _PriceItemFormState _self;
  final $Res Function(_PriceItemFormState) _then;

/// Create a copy of PriceItemFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? itemId = freezed,Object? name = null,Object? description = null,Object? pricingType = freezed,Object? price = null,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? nameError = freezed,Object? descriptionError = freezed,Object? pricingTypeError = freezed,Object? priceError = freezed,}) {
  return _then(_PriceItemFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as PriceItemFormMode,itemId: freezed == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,pricingType: freezed == pricingType ? _self.pricingType : pricingType // ignore: cast_nullable_to_non_nullable
as PricingType?,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,descriptionError: freezed == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String?,pricingTypeError: freezed == pricingTypeError ? _self.pricingTypeError : pricingTypeError // ignore: cast_nullable_to_non_nullable
as String?,priceError: freezed == priceError ? _self.priceError : priceError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
