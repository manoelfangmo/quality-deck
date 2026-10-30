// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_with_lines.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobWithLines {

 Job get job; List<LineItem> get lines;
/// Create a copy of JobWithLines
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobWithLinesCopyWith<JobWithLines> get copyWith => _$JobWithLinesCopyWithImpl<JobWithLines>(this as JobWithLines, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JobWithLines;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobWithLines&&(identical(other.job, _this.job) || other.job == _this.job)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}


@override
int get hashCode {
  final _this = this as JobWithLines;
  return Object.hash(runtimeType,_this.job,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as JobWithLines;
  return 'JobWithLines(job: ${_this.job}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $JobWithLinesCopyWith<$Res>  {
  factory $JobWithLinesCopyWith(JobWithLines value, $Res Function(JobWithLines) _then) = _$JobWithLinesCopyWithImpl;
@useResult
$Res call({
 Job job, List<LineItem> lines
});


$JobCopyWith<$Res> get job;

}
/// @nodoc
class _$JobWithLinesCopyWithImpl<$Res>
    implements $JobWithLinesCopyWith<$Res> {
  _$JobWithLinesCopyWithImpl(this._self, this._then);

  final JobWithLines _self;
  final $Res Function(JobWithLines) _then;

/// Create a copy of JobWithLines
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? job = null,Object? lines = null,}) {
  return _then(JobWithLines(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as Job,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<LineItem>,
  ));
}
/// Create a copy of JobWithLines
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobCopyWith<$Res> get job {
  
  return $JobCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}


/// Adds pattern-matching-related methods to [JobWithLines].
extension JobWithLinesPatterns on JobWithLines {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobWithLines value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobWithLines() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobWithLines value)  $default,){
final _that = this;
switch (_that) {
case _JobWithLines():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobWithLines value)?  $default,){
final _that = this;
switch (_that) {
case _JobWithLines() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Job job,  List<LineItem> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobWithLines() when $default != null:
return $default(_that.job,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Job job,  List<LineItem> lines)  $default,) {final _that = this;
switch (_that) {
case _JobWithLines():
return $default(_that.job,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Job job,  List<LineItem> lines)?  $default,) {final _that = this;
switch (_that) {
case _JobWithLines() when $default != null:
return $default(_that.job,_that.lines);case _:
  return null;

}
}

}

/// @nodoc


class _JobWithLines extends JobWithLines {
  const _JobWithLines({required this.job, required  List<LineItem> lines}): _lines = lines,super._();
  

@override final  Job job;
 final  List<LineItem> _lines;
@override List<LineItem> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of JobWithLines
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobWithLinesCopyWith<_JobWithLines> get copyWith => __$JobWithLinesCopyWithImpl<_JobWithLines>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobWithLines&&(identical(other.job, job) || other.job == job)&&const DeepCollectionEquality().equals(other.lines, _lines));
}


@override
int get hashCode {
    return Object.hash(runtimeType,job,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'JobWithLines(job: $job, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$JobWithLinesCopyWith<$Res> implements $JobWithLinesCopyWith<$Res> {
  factory _$JobWithLinesCopyWith(_JobWithLines value, $Res Function(_JobWithLines) _then) = __$JobWithLinesCopyWithImpl;
@override @useResult
$Res call({
 Job job, List<LineItem> lines
});


@override $JobCopyWith<$Res> get job;

}
/// @nodoc
class __$JobWithLinesCopyWithImpl<$Res>
    implements _$JobWithLinesCopyWith<$Res> {
  __$JobWithLinesCopyWithImpl(this._self, this._then);

  final _JobWithLines _self;
  final $Res Function(_JobWithLines) _then;

/// Create a copy of JobWithLines
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? job = null,Object? lines = null,}) {
  return _then(_JobWithLines(
job: null == job ? _self.job : job // ignore: cast_nullable_to_non_nullable
as Job,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<LineItem>,
  ));
}

/// Create a copy of JobWithLines
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$JobCopyWith<$Res> get job {
  
  return $JobCopyWith<$Res>(_self.job, (value) {
    return _then(_self.copyWith(job: value));
  });
}
}

// dart format on
