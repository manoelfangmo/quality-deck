// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Client {

 String get id; String get fullName; String? get email; String? get phone; Address? get address; DateTime get lastActivityAt; DateTime get createdAt; String? get appointmentId; DateTime? get appointmentStartsAt; int? get appointmentDurationMinutes;
/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientCopyWith<Client> get copyWith => _$ClientCopyWithImpl<Client>(this as Client, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Client;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Client&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.lastActivityAt, _this.lastActivityAt) || other.lastActivityAt == _this.lastActivityAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.appointmentId, _this.appointmentId) || other.appointmentId == _this.appointmentId)&&(identical(other.appointmentStartsAt, _this.appointmentStartsAt) || other.appointmentStartsAt == _this.appointmentStartsAt)&&(identical(other.appointmentDurationMinutes, _this.appointmentDurationMinutes) || other.appointmentDurationMinutes == _this.appointmentDurationMinutes));
}


@override
int get hashCode {
  final _this = this as Client;
  return Object.hash(runtimeType,_this.id,_this.fullName,_this.email,_this.phone,_this.address,_this.lastActivityAt,_this.createdAt,_this.appointmentId,_this.appointmentStartsAt,_this.appointmentDurationMinutes);
}

@override
String toString() {
  final _this = this as Client;
  return 'Client(id: ${_this.id}, fullName: ${_this.fullName}, email: ${_this.email}, phone: ${_this.phone}, address: ${_this.address}, lastActivityAt: ${_this.lastActivityAt}, createdAt: ${_this.createdAt}, appointmentId: ${_this.appointmentId}, appointmentStartsAt: ${_this.appointmentStartsAt}, appointmentDurationMinutes: ${_this.appointmentDurationMinutes})';
}


}

/// @nodoc
abstract mixin class $ClientCopyWith<$Res>  {
  factory $ClientCopyWith(Client value, $Res Function(Client) _then) = _$ClientCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? email, String? phone, Address? address, DateTime lastActivityAt, DateTime createdAt, String? appointmentId, DateTime? appointmentStartsAt, int? appointmentDurationMinutes
});


$AddressCopyWith<$Res>? get address;

}
/// @nodoc
class _$ClientCopyWithImpl<$Res>
    implements $ClientCopyWith<$Res> {
  _$ClientCopyWithImpl(this._self, this._then);

  final Client _self;
  final $Res Function(Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phone = freezed,Object? address = freezed,Object? lastActivityAt = null,Object? createdAt = null,Object? appointmentId = freezed,Object? appointmentStartsAt = freezed,Object? appointmentDurationMinutes = freezed,}) {
  return _then(Client(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,appointmentStartsAt: freezed == appointmentStartsAt ? _self.appointmentStartsAt : appointmentStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,appointmentDurationMinutes: freezed == appointmentDurationMinutes ? _self.appointmentDurationMinutes : appointmentDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}


/// Adds pattern-matching-related methods to [Client].
extension ClientPatterns on Client {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Client value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Client value)  $default,){
final _that = this;
switch (_that) {
case _Client():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Client value)?  $default,){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? email,  String? phone,  Address? address,  DateTime lastActivityAt,  DateTime createdAt,  String? appointmentId,  DateTime? appointmentStartsAt,  int? appointmentDurationMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.address,_that.lastActivityAt,_that.createdAt,_that.appointmentId,_that.appointmentStartsAt,_that.appointmentDurationMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? email,  String? phone,  Address? address,  DateTime lastActivityAt,  DateTime createdAt,  String? appointmentId,  DateTime? appointmentStartsAt,  int? appointmentDurationMinutes)  $default,) {final _that = this;
switch (_that) {
case _Client():
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.address,_that.lastActivityAt,_that.createdAt,_that.appointmentId,_that.appointmentStartsAt,_that.appointmentDurationMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? email,  String? phone,  Address? address,  DateTime lastActivityAt,  DateTime createdAt,  String? appointmentId,  DateTime? appointmentStartsAt,  int? appointmentDurationMinutes)?  $default,) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phone,_that.address,_that.lastActivityAt,_that.createdAt,_that.appointmentId,_that.appointmentStartsAt,_that.appointmentDurationMinutes);case _:
  return null;

}
}

}

/// @nodoc


class _Client extends Client {
  const _Client({required this.id, required this.fullName, this.email, this.phone, this.address, required this.lastActivityAt, required this.createdAt, this.appointmentId, this.appointmentStartsAt, this.appointmentDurationMinutes}): super._();
  

@override final  String id;
@override final  String fullName;
@override final  String? email;
@override final  String? phone;
@override final  Address? address;
@override final  DateTime lastActivityAt;
@override final  DateTime createdAt;
@override final  String? appointmentId;
@override final  DateTime? appointmentStartsAt;
@override final  int? appointmentDurationMinutes;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientCopyWith<_Client> get copyWith => __$ClientCopyWithImpl<_Client>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Client&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.address, address) || other.address == address)&&(identical(other.lastActivityAt, lastActivityAt) || other.lastActivityAt == lastActivityAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.appointmentId, appointmentId) || other.appointmentId == appointmentId)&&(identical(other.appointmentStartsAt, appointmentStartsAt) || other.appointmentStartsAt == appointmentStartsAt)&&(identical(other.appointmentDurationMinutes, appointmentDurationMinutes) || other.appointmentDurationMinutes == appointmentDurationMinutes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,fullName,email,phone,address,lastActivityAt,createdAt,appointmentId,appointmentStartsAt,appointmentDurationMinutes);
}

@override
String toString() {
    return 'Client(id: $id, fullName: $fullName, email: $email, phone: $phone, address: $address, lastActivityAt: $lastActivityAt, createdAt: $createdAt, appointmentId: $appointmentId, appointmentStartsAt: $appointmentStartsAt, appointmentDurationMinutes: $appointmentDurationMinutes)';
}


}

/// @nodoc
abstract mixin class _$ClientCopyWith<$Res> implements $ClientCopyWith<$Res> {
  factory _$ClientCopyWith(_Client value, $Res Function(_Client) _then) = __$ClientCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? email, String? phone, Address? address, DateTime lastActivityAt, DateTime createdAt, String? appointmentId, DateTime? appointmentStartsAt, int? appointmentDurationMinutes
});


@override $AddressCopyWith<$Res>? get address;

}
/// @nodoc
class __$ClientCopyWithImpl<$Res>
    implements _$ClientCopyWith<$Res> {
  __$ClientCopyWithImpl(this._self, this._then);

  final _Client _self;
  final $Res Function(_Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phone = freezed,Object? address = freezed,Object? lastActivityAt = null,Object? createdAt = null,Object? appointmentId = freezed,Object? appointmentStartsAt = freezed,Object? appointmentDurationMinutes = freezed,}) {
  return _then(_Client(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as Address?,lastActivityAt: null == lastActivityAt ? _self.lastActivityAt : lastActivityAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,appointmentId: freezed == appointmentId ? _self.appointmentId : appointmentId // ignore: cast_nullable_to_non_nullable
as String?,appointmentStartsAt: freezed == appointmentStartsAt ? _self.appointmentStartsAt : appointmentStartsAt // ignore: cast_nullable_to_non_nullable
as DateTime?,appointmentDurationMinutes: freezed == appointmentDurationMinutes ? _self.appointmentDurationMinutes : appointmentDurationMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressCopyWith<$Res>? get address {
    if (_self.address == null) {
    return null;
  }

  return $AddressCopyWith<$Res>(_self.address!, (value) {
    return _then(_self.copyWith(address: value));
  });
}
}

// dart format on
