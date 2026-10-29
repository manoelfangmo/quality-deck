// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_photos_view.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobPhotosView {

 List<JobPhoto> get saved; Map<String, String> get urls; List<PendingPhoto> get pending; String? get notice; bool get cameraDenied; String? get deleteError; bool get loading; int get batchSize; int get batchFinished;
/// Create a copy of JobPhotosView
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobPhotosViewCopyWith<JobPhotosView> get copyWith => _$JobPhotosViewCopyWithImpl<JobPhotosView>(this as JobPhotosView, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JobPhotosView;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobPhotosView&&const DeepCollectionEquality().equals(other.saved, _this.saved)&&const DeepCollectionEquality().equals(other.urls, _this.urls)&&const DeepCollectionEquality().equals(other.pending, _this.pending)&&(identical(other.notice, _this.notice) || other.notice == _this.notice)&&(identical(other.cameraDenied, _this.cameraDenied) || other.cameraDenied == _this.cameraDenied)&&(identical(other.deleteError, _this.deleteError) || other.deleteError == _this.deleteError)&&(identical(other.loading, _this.loading) || other.loading == _this.loading)&&(identical(other.batchSize, _this.batchSize) || other.batchSize == _this.batchSize)&&(identical(other.batchFinished, _this.batchFinished) || other.batchFinished == _this.batchFinished));
}


@override
int get hashCode {
  final _this = this as JobPhotosView;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.saved),const DeepCollectionEquality().hash(_this.urls),const DeepCollectionEquality().hash(_this.pending),_this.notice,_this.cameraDenied,_this.deleteError,_this.loading,_this.batchSize,_this.batchFinished);
}

@override
String toString() {
  final _this = this as JobPhotosView;
  return 'JobPhotosView(saved: ${_this.saved}, urls: ${_this.urls}, pending: ${_this.pending}, notice: ${_this.notice}, cameraDenied: ${_this.cameraDenied}, deleteError: ${_this.deleteError}, loading: ${_this.loading}, batchSize: ${_this.batchSize}, batchFinished: ${_this.batchFinished})';
}


}

/// @nodoc
abstract mixin class $JobPhotosViewCopyWith<$Res>  {
  factory $JobPhotosViewCopyWith(JobPhotosView value, $Res Function(JobPhotosView) _then) = _$JobPhotosViewCopyWithImpl;
@useResult
$Res call({
 List<JobPhoto> saved, Map<String, String> urls, List<PendingPhoto> pending, String? notice, bool cameraDenied, String? deleteError, bool loading, int batchSize, int batchFinished
});




}
/// @nodoc
class _$JobPhotosViewCopyWithImpl<$Res>
    implements $JobPhotosViewCopyWith<$Res> {
  _$JobPhotosViewCopyWithImpl(this._self, this._then);

  final JobPhotosView _self;
  final $Res Function(JobPhotosView) _then;

/// Create a copy of JobPhotosView
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? saved = null,Object? urls = null,Object? pending = null,Object? notice = freezed,Object? cameraDenied = null,Object? deleteError = freezed,Object? loading = null,Object? batchSize = null,Object? batchFinished = null,}) {
  return _then(JobPhotosView(
saved: null == saved ? _self.saved : saved // ignore: cast_nullable_to_non_nullable
as List<JobPhoto>,urls: null == urls ? _self.urls : urls // ignore: cast_nullable_to_non_nullable
as Map<String, String>,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as List<PendingPhoto>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,cameraDenied: null == cameraDenied ? _self.cameraDenied : cameraDenied // ignore: cast_nullable_to_non_nullable
as bool,deleteError: freezed == deleteError ? _self.deleteError : deleteError // ignore: cast_nullable_to_non_nullable
as String?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,batchSize: null == batchSize ? _self.batchSize : batchSize // ignore: cast_nullable_to_non_nullable
as int,batchFinished: null == batchFinished ? _self.batchFinished : batchFinished // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [JobPhotosView].
extension JobPhotosViewPatterns on JobPhotosView {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobPhotosView value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobPhotosView() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobPhotosView value)  $default,){
final _that = this;
switch (_that) {
case _JobPhotosView():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobPhotosView value)?  $default,){
final _that = this;
switch (_that) {
case _JobPhotosView() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<JobPhoto> saved,  Map<String, String> urls,  List<PendingPhoto> pending,  String? notice,  bool cameraDenied,  String? deleteError,  bool loading,  int batchSize,  int batchFinished)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobPhotosView() when $default != null:
return $default(_that.saved,_that.urls,_that.pending,_that.notice,_that.cameraDenied,_that.deleteError,_that.loading,_that.batchSize,_that.batchFinished);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<JobPhoto> saved,  Map<String, String> urls,  List<PendingPhoto> pending,  String? notice,  bool cameraDenied,  String? deleteError,  bool loading,  int batchSize,  int batchFinished)  $default,) {final _that = this;
switch (_that) {
case _JobPhotosView():
return $default(_that.saved,_that.urls,_that.pending,_that.notice,_that.cameraDenied,_that.deleteError,_that.loading,_that.batchSize,_that.batchFinished);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<JobPhoto> saved,  Map<String, String> urls,  List<PendingPhoto> pending,  String? notice,  bool cameraDenied,  String? deleteError,  bool loading,  int batchSize,  int batchFinished)?  $default,) {final _that = this;
switch (_that) {
case _JobPhotosView() when $default != null:
return $default(_that.saved,_that.urls,_that.pending,_that.notice,_that.cameraDenied,_that.deleteError,_that.loading,_that.batchSize,_that.batchFinished);case _:
  return null;

}
}

}

/// @nodoc


class _JobPhotosView extends JobPhotosView {
  const _JobPhotosView({ List<JobPhoto> saved = const [],  Map<String, String> urls = const <String, String>{},  List<PendingPhoto> pending = const [], this.notice, this.cameraDenied = false, this.deleteError, this.loading = true, this.batchSize = 0, this.batchFinished = 0}): _saved = saved,_urls = urls,_pending = pending,super._();
  

 final  List<JobPhoto> _saved;
@override@JsonKey() List<JobPhoto> get saved {
  if (_saved is EqualUnmodifiableListView) return _saved;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_saved);
}

 final  Map<String, String> _urls;
@override@JsonKey() Map<String, String> get urls {
  if (_urls is EqualUnmodifiableMapView) return _urls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_urls);
}

 final  List<PendingPhoto> _pending;
@override@JsonKey() List<PendingPhoto> get pending {
  if (_pending is EqualUnmodifiableListView) return _pending;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pending);
}

@override final  String? notice;
@override@JsonKey() final  bool cameraDenied;
@override final  String? deleteError;
@override@JsonKey() final  bool loading;
@override@JsonKey() final  int batchSize;
@override@JsonKey() final  int batchFinished;

/// Create a copy of JobPhotosView
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobPhotosViewCopyWith<_JobPhotosView> get copyWith => __$JobPhotosViewCopyWithImpl<_JobPhotosView>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobPhotosView&&const DeepCollectionEquality().equals(other.saved, _saved)&&const DeepCollectionEquality().equals(other.urls, _urls)&&const DeepCollectionEquality().equals(other.pending, _pending)&&(identical(other.notice, notice) || other.notice == notice)&&(identical(other.cameraDenied, cameraDenied) || other.cameraDenied == cameraDenied)&&(identical(other.deleteError, deleteError) || other.deleteError == deleteError)&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.batchSize, batchSize) || other.batchSize == batchSize)&&(identical(other.batchFinished, batchFinished) || other.batchFinished == batchFinished));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_saved),const DeepCollectionEquality().hash(_urls),const DeepCollectionEquality().hash(_pending),notice,cameraDenied,deleteError,loading,batchSize,batchFinished);
}

@override
String toString() {
    return 'JobPhotosView(saved: $saved, urls: $urls, pending: $pending, notice: $notice, cameraDenied: $cameraDenied, deleteError: $deleteError, loading: $loading, batchSize: $batchSize, batchFinished: $batchFinished)';
}


}

/// @nodoc
abstract mixin class _$JobPhotosViewCopyWith<$Res> implements $JobPhotosViewCopyWith<$Res> {
  factory _$JobPhotosViewCopyWith(_JobPhotosView value, $Res Function(_JobPhotosView) _then) = __$JobPhotosViewCopyWithImpl;
@override @useResult
$Res call({
 List<JobPhoto> saved, Map<String, String> urls, List<PendingPhoto> pending, String? notice, bool cameraDenied, String? deleteError, bool loading, int batchSize, int batchFinished
});




}
/// @nodoc
class __$JobPhotosViewCopyWithImpl<$Res>
    implements _$JobPhotosViewCopyWith<$Res> {
  __$JobPhotosViewCopyWithImpl(this._self, this._then);

  final _JobPhotosView _self;
  final $Res Function(_JobPhotosView) _then;

/// Create a copy of JobPhotosView
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? saved = null,Object? urls = null,Object? pending = null,Object? notice = freezed,Object? cameraDenied = null,Object? deleteError = freezed,Object? loading = null,Object? batchSize = null,Object? batchFinished = null,}) {
  return _then(_JobPhotosView(
saved: null == saved ? _self._saved : saved // ignore: cast_nullable_to_non_nullable
as List<JobPhoto>,urls: null == urls ? _self._urls : urls // ignore: cast_nullable_to_non_nullable
as Map<String, String>,pending: null == pending ? _self._pending : pending // ignore: cast_nullable_to_non_nullable
as List<PendingPhoto>,notice: freezed == notice ? _self.notice : notice // ignore: cast_nullable_to_non_nullable
as String?,cameraDenied: null == cameraDenied ? _self.cameraDenied : cameraDenied // ignore: cast_nullable_to_non_nullable
as bool,deleteError: freezed == deleteError ? _self.deleteError : deleteError // ignore: cast_nullable_to_non_nullable
as String?,loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,batchSize: null == batchSize ? _self.batchSize : batchSize // ignore: cast_nullable_to_non_nullable
as int,batchFinished: null == batchFinished ? _self.batchFinished : batchFinished // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
