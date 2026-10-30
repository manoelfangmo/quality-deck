// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobPhoto {

 String get id; String get jobId; PhotoKind get kind; String get storagePath; int get width; int get height; String get createdBy; DateTime get createdAt;
/// Create a copy of JobPhoto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobPhotoCopyWith<JobPhoto> get copyWith => _$JobPhotoCopyWithImpl<JobPhoto>(this as JobPhoto, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JobPhoto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobPhoto&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.jobId, _this.jobId) || other.jobId == _this.jobId)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.storagePath, _this.storagePath) || other.storagePath == _this.storagePath)&&(identical(other.width, _this.width) || other.width == _this.width)&&(identical(other.height, _this.height) || other.height == _this.height)&&(identical(other.createdBy, _this.createdBy) || other.createdBy == _this.createdBy)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}


@override
int get hashCode {
  final _this = this as JobPhoto;
  return Object.hash(runtimeType,_this.id,_this.jobId,_this.kind,_this.storagePath,_this.width,_this.height,_this.createdBy,_this.createdAt);
}

@override
String toString() {
  final _this = this as JobPhoto;
  return 'JobPhoto(id: ${_this.id}, jobId: ${_this.jobId}, kind: ${_this.kind}, storagePath: ${_this.storagePath}, width: ${_this.width}, height: ${_this.height}, createdBy: ${_this.createdBy}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $JobPhotoCopyWith<$Res>  {
  factory $JobPhotoCopyWith(JobPhoto value, $Res Function(JobPhoto) _then) = _$JobPhotoCopyWithImpl;
@useResult
$Res call({
 String id, String jobId, PhotoKind kind, String storagePath, int width, int height, String createdBy, DateTime createdAt
});




}
/// @nodoc
class _$JobPhotoCopyWithImpl<$Res>
    implements $JobPhotoCopyWith<$Res> {
  _$JobPhotoCopyWithImpl(this._self, this._then);

  final JobPhoto _self;
  final $Res Function(JobPhoto) _then;

/// Create a copy of JobPhoto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? jobId = null,Object? kind = null,Object? storagePath = null,Object? width = null,Object? height = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(JobPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JobPhoto].
extension JobPhotoPatterns on JobPhoto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobPhoto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobPhoto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobPhoto value)  $default,){
final _that = this;
switch (_that) {
case _JobPhoto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobPhoto value)?  $default,){
final _that = this;
switch (_that) {
case _JobPhoto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String jobId,  PhotoKind kind,  String storagePath,  int width,  int height,  String createdBy,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobPhoto() when $default != null:
return $default(_that.id,_that.jobId,_that.kind,_that.storagePath,_that.width,_that.height,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String jobId,  PhotoKind kind,  String storagePath,  int width,  int height,  String createdBy,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _JobPhoto():
return $default(_that.id,_that.jobId,_that.kind,_that.storagePath,_that.width,_that.height,_that.createdBy,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String jobId,  PhotoKind kind,  String storagePath,  int width,  int height,  String createdBy,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _JobPhoto() when $default != null:
return $default(_that.id,_that.jobId,_that.kind,_that.storagePath,_that.width,_that.height,_that.createdBy,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _JobPhoto implements JobPhoto {
  const _JobPhoto({required this.id, required this.jobId, required this.kind, required this.storagePath, required this.width, required this.height, required this.createdBy, required this.createdAt});
  

@override final  String id;
@override final  String jobId;
@override final  PhotoKind kind;
@override final  String storagePath;
@override final  int width;
@override final  int height;
@override final  String createdBy;
@override final  DateTime createdAt;

/// Create a copy of JobPhoto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobPhotoCopyWith<_JobPhoto> get copyWith => __$JobPhotoCopyWithImpl<_JobPhoto>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobPhoto&&(identical(other.id, id) || other.id == id)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.storagePath, storagePath) || other.storagePath == storagePath)&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,jobId,kind,storagePath,width,height,createdBy,createdAt);
}

@override
String toString() {
    return 'JobPhoto(id: $id, jobId: $jobId, kind: $kind, storagePath: $storagePath, width: $width, height: $height, createdBy: $createdBy, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$JobPhotoCopyWith<$Res> implements $JobPhotoCopyWith<$Res> {
  factory _$JobPhotoCopyWith(_JobPhoto value, $Res Function(_JobPhoto) _then) = __$JobPhotoCopyWithImpl;
@override @useResult
$Res call({
 String id, String jobId, PhotoKind kind, String storagePath, int width, int height, String createdBy, DateTime createdAt
});




}
/// @nodoc
class __$JobPhotoCopyWithImpl<$Res>
    implements _$JobPhotoCopyWith<$Res> {
  __$JobPhotoCopyWithImpl(this._self, this._then);

  final _JobPhoto _self;
  final $Res Function(_JobPhoto) _then;

/// Create a copy of JobPhoto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? jobId = null,Object? kind = null,Object? storagePath = null,Object? width = null,Object? height = null,Object? createdBy = null,Object? createdAt = null,}) {
  return _then(_JobPhoto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,jobId: null == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PhotoKind,storagePath: null == storagePath ? _self.storagePath : storagePath // ignore: cast_nullable_to_non_nullable
as String,width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
