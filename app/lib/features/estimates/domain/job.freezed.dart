// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Job {

 String get id; String get projectId; String get title; JobType get jobType; String? get description; Labor? get labor; String? get alternateOfJobId; DateTime get createdAt; int get number;
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobCopyWith<Job> get copyWith => _$JobCopyWithImpl<Job>(this as Job, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Job;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Job&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.jobType, _this.jobType) || other.jobType == _this.jobType)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.labor, _this.labor) || other.labor == _this.labor)&&(identical(other.alternateOfJobId, _this.alternateOfJobId) || other.alternateOfJobId == _this.alternateOfJobId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.number, _this.number) || other.number == _this.number));
}


@override
int get hashCode {
  final _this = this as Job;
  return Object.hash(runtimeType,_this.id,_this.projectId,_this.title,_this.jobType,_this.description,_this.labor,_this.alternateOfJobId,_this.createdAt,_this.number);
}

@override
String toString() {
  final _this = this as Job;
  return 'Job(id: ${_this.id}, projectId: ${_this.projectId}, title: ${_this.title}, jobType: ${_this.jobType}, description: ${_this.description}, labor: ${_this.labor}, alternateOfJobId: ${_this.alternateOfJobId}, createdAt: ${_this.createdAt}, number: ${_this.number})';
}


}

/// @nodoc
abstract mixin class $JobCopyWith<$Res>  {
  factory $JobCopyWith(Job value, $Res Function(Job) _then) = _$JobCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String title, JobType jobType, String? description, Labor? labor, String? alternateOfJobId, DateTime createdAt, int number
});


$LaborCopyWith<$Res>? get labor;

}
/// @nodoc
class _$JobCopyWithImpl<$Res>
    implements $JobCopyWith<$Res> {
  _$JobCopyWithImpl(this._self, this._then);

  final Job _self;
  final $Res Function(Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? jobType = null,Object? description = freezed,Object? labor = freezed,Object? alternateOfJobId = freezed,Object? createdAt = null,Object? number = null,}) {
  return _then(Job(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,jobType: null == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as JobType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,labor: freezed == labor ? _self.labor : labor // ignore: cast_nullable_to_non_nullable
as Labor?,alternateOfJobId: freezed == alternateOfJobId ? _self.alternateOfJobId : alternateOfJobId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaborCopyWith<$Res>? get labor {
    if (_self.labor == null) {
    return null;
  }

  return $LaborCopyWith<$Res>(_self.labor!, (value) {
    return _then(_self.copyWith(labor: value));
  });
}
}


/// Adds pattern-matching-related methods to [Job].
extension JobPatterns on Job {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Job value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Job value)  $default,){
final _that = this;
switch (_that) {
case _Job():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Job value)?  $default,){
final _that = this;
switch (_that) {
case _Job() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String title,  JobType jobType,  String? description,  Labor? labor,  String? alternateOfJobId,  DateTime createdAt,  int number)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.jobType,_that.description,_that.labor,_that.alternateOfJobId,_that.createdAt,_that.number);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String title,  JobType jobType,  String? description,  Labor? labor,  String? alternateOfJobId,  DateTime createdAt,  int number)  $default,) {final _that = this;
switch (_that) {
case _Job():
return $default(_that.id,_that.projectId,_that.title,_that.jobType,_that.description,_that.labor,_that.alternateOfJobId,_that.createdAt,_that.number);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String title,  JobType jobType,  String? description,  Labor? labor,  String? alternateOfJobId,  DateTime createdAt,  int number)?  $default,) {final _that = this;
switch (_that) {
case _Job() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.jobType,_that.description,_that.labor,_that.alternateOfJobId,_that.createdAt,_that.number);case _:
  return null;

}
}

}

/// @nodoc


class _Job extends Job {
  const _Job({required this.id, required this.projectId, required this.title, required this.jobType, this.description, this.labor, this.alternateOfJobId, required this.createdAt, this.number = 0}): super._();
  

@override final  String id;
@override final  String projectId;
@override final  String title;
@override final  JobType jobType;
@override final  String? description;
@override final  Labor? labor;
@override final  String? alternateOfJobId;
@override final  DateTime createdAt;
@override@JsonKey() final  int number;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobCopyWith<_Job> get copyWith => __$JobCopyWithImpl<_Job>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Job&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.description, description) || other.description == description)&&(identical(other.labor, labor) || other.labor == labor)&&(identical(other.alternateOfJobId, alternateOfJobId) || other.alternateOfJobId == alternateOfJobId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.number, number) || other.number == number));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,projectId,title,jobType,description,labor,alternateOfJobId,createdAt,number);
}

@override
String toString() {
    return 'Job(id: $id, projectId: $projectId, title: $title, jobType: $jobType, description: $description, labor: $labor, alternateOfJobId: $alternateOfJobId, createdAt: $createdAt, number: $number)';
}


}

/// @nodoc
abstract mixin class _$JobCopyWith<$Res> implements $JobCopyWith<$Res> {
  factory _$JobCopyWith(_Job value, $Res Function(_Job) _then) = __$JobCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String title, JobType jobType, String? description, Labor? labor, String? alternateOfJobId, DateTime createdAt, int number
});


@override $LaborCopyWith<$Res>? get labor;

}
/// @nodoc
class __$JobCopyWithImpl<$Res>
    implements _$JobCopyWith<$Res> {
  __$JobCopyWithImpl(this._self, this._then);

  final _Job _self;
  final $Res Function(_Job) _then;

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? jobType = null,Object? description = freezed,Object? labor = freezed,Object? alternateOfJobId = freezed,Object? createdAt = null,Object? number = null,}) {
  return _then(_Job(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,jobType: null == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as JobType,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,labor: freezed == labor ? _self.labor : labor // ignore: cast_nullable_to_non_nullable
as Labor?,alternateOfJobId: freezed == alternateOfJobId ? _self.alternateOfJobId : alternateOfJobId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of Job
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LaborCopyWith<$Res>? get labor {
    if (_self.labor == null) {
    return null;
  }

  return $LaborCopyWith<$Res>(_self.labor!, (value) {
    return _then(_self.copyWith(labor: value));
  });
}
}

// dart format on
