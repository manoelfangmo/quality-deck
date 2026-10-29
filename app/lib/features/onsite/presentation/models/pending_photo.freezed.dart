// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pending_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PendingPhoto {

 String get localId; PhotoKind get kind; PendingPhotoStatus get status; Uint8List? get preview; CompressedPhoto? get compressed; String? get error;
/// Create a copy of PendingPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingPhotoCopyWith<PendingPhoto> get copyWith => _$PendingPhotoCopyWithImpl<PendingPhoto>(this as PendingPhoto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PendingPhoto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingPhoto&&(identical(other.localId, _this.localId) || other.localId == _this.localId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.preview, _this.preview)&&(identical(other.compressed, _this.compressed) || other.compressed == _this.compressed)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as PendingPhoto;
  return Object.hash(runtimeType,_this.localId,_this.kind,_this.status,const DeepCollectionEquality().hash(_this.preview),_this.compressed,_this.error);
}

@override
String toString() {
  final _this = this as PendingPhoto;
  return 'PendingPhoto(localId: ${_this.localId}, kind: ${_this.kind}, status: ${_this.status}, preview: ${_this.preview}, compressed: ${_this.compressed}, error: ${_this.error})';
}


}

/// @nodoc
abstract mixin class $PendingPhotoCopyWith<$Res>  {
  factory $PendingPhotoCopyWith(PendingPhoto value, $Res Function(PendingPhoto) _then) = _$PendingPhotoCopyWithImpl;
@useResult
$Res call({
 String localId, PhotoKind kind, PendingPhotoStatus status, Uint8List? preview, CompressedPhoto? compressed, String? error
});




}
/// @nodoc
class _$PendingPhotoCopyWithImpl<$Res>
    implements $PendingPhotoCopyWith<$Res> {
  _$PendingPhotoCopyWithImpl(this._self, this._then);

  final PendingPhoto _self;
  final $Res Function(PendingPhoto) _then;

/// Create a copy of PendingPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localId = null,Object? kind = null,Object? status = null,Object? preview = freezed,Object? compressed = freezed,Object? error = freezed,}) {
  return _then(PendingPhoto(
localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PendingPhotoStatus,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Uint8List?,compressed: freezed == compressed ? _self.compressed : compressed // ignore: cast_nullable_to_non_nullable
as CompressedPhoto?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingPhoto].
extension PendingPhotoPatterns on PendingPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingPhoto value)  $default,){
final _that = this;
switch (_that) {
case _PendingPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _PendingPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String localId,  PhotoKind kind,  PendingPhotoStatus status,  Uint8List? preview,  CompressedPhoto? compressed,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingPhoto() when $default != null:
return $default(_that.localId,_that.kind,_that.status,_that.preview,_that.compressed,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String localId,  PhotoKind kind,  PendingPhotoStatus status,  Uint8List? preview,  CompressedPhoto? compressed,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PendingPhoto():
return $default(_that.localId,_that.kind,_that.status,_that.preview,_that.compressed,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String localId,  PhotoKind kind,  PendingPhotoStatus status,  Uint8List? preview,  CompressedPhoto? compressed,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PendingPhoto() when $default != null:
return $default(_that.localId,_that.kind,_that.status,_that.preview,_that.compressed,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PendingPhoto implements PendingPhoto {
  const _PendingPhoto({required this.localId, required this.kind, required this.status, this.preview, this.compressed, this.error});
  

@override final  String localId;
@override final  PhotoKind kind;
@override final  PendingPhotoStatus status;
@override final  Uint8List? preview;
@override final  CompressedPhoto? compressed;
@override final  String? error;

/// Create a copy of PendingPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingPhotoCopyWith<_PendingPhoto> get copyWith => __$PendingPhotoCopyWithImpl<_PendingPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingPhoto&&(identical(other.localId, localId) || other.localId == localId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.preview, preview)&&(identical(other.compressed, compressed) || other.compressed == compressed)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,localId,kind,status,const DeepCollectionEquality().hash(preview),compressed,error);
}

@override
String toString() {
    return 'PendingPhoto(localId: $localId, kind: $kind, status: $status, preview: $preview, compressed: $compressed, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PendingPhotoCopyWith<$Res> implements $PendingPhotoCopyWith<$Res> {
  factory _$PendingPhotoCopyWith(_PendingPhoto value, $Res Function(_PendingPhoto) _then) = __$PendingPhotoCopyWithImpl;
@override @useResult
$Res call({
 String localId, PhotoKind kind, PendingPhotoStatus status, Uint8List? preview, CompressedPhoto? compressed, String? error
});




}
/// @nodoc
class __$PendingPhotoCopyWithImpl<$Res>
    implements _$PendingPhotoCopyWith<$Res> {
  __$PendingPhotoCopyWithImpl(this._self, this._then);

  final _PendingPhoto _self;
  final $Res Function(_PendingPhoto) _then;

/// Create a copy of PendingPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localId = null,Object? kind = null,Object? status = null,Object? preview = freezed,Object? compressed = freezed,Object? error = freezed,}) {
  return _then(_PendingPhoto(
localId: null == localId ? _self.localId : localId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PendingPhotoStatus,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Uint8List?,compressed: freezed == compressed ? _self.compressed : compressed // ignore: cast_nullable_to_non_nullable
as CompressedPhoto?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
