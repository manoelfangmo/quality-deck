// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'job_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$JobFormState {

 String? get jobId; String get title; JobType? get jobType; String get description; bool get isSubmitting; bool get submitted; String? get errorMessage; String? get titleError; String? get jobTypeError; String? get descriptionError;
/// Create a copy of JobFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JobFormStateCopyWith<JobFormState> get copyWith => _$JobFormStateCopyWithImpl<JobFormState>(this as JobFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as JobFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JobFormState&&(identical(other.jobId, _this.jobId) || other.jobId == _this.jobId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.jobType, _this.jobType) || other.jobType == _this.jobType)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.titleError, _this.titleError) || other.titleError == _this.titleError)&&(identical(other.jobTypeError, _this.jobTypeError) || other.jobTypeError == _this.jobTypeError)&&(identical(other.descriptionError, _this.descriptionError) || other.descriptionError == _this.descriptionError));
}


@override
int get hashCode {
  final _this = this as JobFormState;
  return Object.hash(runtimeType,_this.jobId,_this.title,_this.jobType,_this.description,_this.isSubmitting,_this.submitted,_this.errorMessage,_this.titleError,_this.jobTypeError,_this.descriptionError);
}

@override
String toString() {
  final _this = this as JobFormState;
  return 'JobFormState(jobId: ${_this.jobId}, title: ${_this.title}, jobType: ${_this.jobType}, description: ${_this.description}, isSubmitting: ${_this.isSubmitting}, submitted: ${_this.submitted}, errorMessage: ${_this.errorMessage}, titleError: ${_this.titleError}, jobTypeError: ${_this.jobTypeError}, descriptionError: ${_this.descriptionError})';
}


}

/// @nodoc
abstract mixin class $JobFormStateCopyWith<$Res>  {
  factory $JobFormStateCopyWith(JobFormState value, $Res Function(JobFormState) _then) = _$JobFormStateCopyWithImpl;
@useResult
$Res call({
 String? jobId, String title, JobType? jobType, String description, bool isSubmitting, bool submitted, String? errorMessage, String? titleError, String? jobTypeError, String? descriptionError
});




}
/// @nodoc
class _$JobFormStateCopyWithImpl<$Res>
    implements $JobFormStateCopyWith<$Res> {
  _$JobFormStateCopyWithImpl(this._self, this._then);

  final JobFormState _self;
  final $Res Function(JobFormState) _then;

/// Create a copy of JobFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? jobId = freezed,Object? title = null,Object? jobType = freezed,Object? description = null,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? titleError = freezed,Object? jobTypeError = freezed,Object? descriptionError = freezed,}) {
  return _then(JobFormState(
jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as JobType?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,jobTypeError: freezed == jobTypeError ? _self.jobTypeError : jobTypeError // ignore: cast_nullable_to_non_nullable
as String?,descriptionError: freezed == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JobFormState].
extension JobFormStatePatterns on JobFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JobFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JobFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JobFormState value)  $default,){
final _that = this;
switch (_that) {
case _JobFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JobFormState value)?  $default,){
final _that = this;
switch (_that) {
case _JobFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? jobId,  String title,  JobType? jobType,  String description,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? titleError,  String? jobTypeError,  String? descriptionError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JobFormState() when $default != null:
return $default(_that.jobId,_that.title,_that.jobType,_that.description,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.titleError,_that.jobTypeError,_that.descriptionError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? jobId,  String title,  JobType? jobType,  String description,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? titleError,  String? jobTypeError,  String? descriptionError)  $default,) {final _that = this;
switch (_that) {
case _JobFormState():
return $default(_that.jobId,_that.title,_that.jobType,_that.description,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.titleError,_that.jobTypeError,_that.descriptionError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? jobId,  String title,  JobType? jobType,  String description,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? titleError,  String? jobTypeError,  String? descriptionError)?  $default,) {final _that = this;
switch (_that) {
case _JobFormState() when $default != null:
return $default(_that.jobId,_that.title,_that.jobType,_that.description,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.titleError,_that.jobTypeError,_that.descriptionError);case _:
  return null;

}
}

}

/// @nodoc


class _JobFormState extends JobFormState {
  const _JobFormState({this.jobId, this.title = '', this.jobType, this.description = '', this.isSubmitting = false, this.submitted = false, this.errorMessage, this.titleError, this.jobTypeError, this.descriptionError}): super._();
  

@override final  String? jobId;
@override@JsonKey() final  String title;
@override final  JobType? jobType;
@override@JsonKey() final  String description;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool submitted;
@override final  String? errorMessage;
@override final  String? titleError;
@override final  String? jobTypeError;
@override final  String? descriptionError;

/// Create a copy of JobFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JobFormStateCopyWith<_JobFormState> get copyWith => __$JobFormStateCopyWithImpl<_JobFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _JobFormState&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.title, title) || other.title == title)&&(identical(other.jobType, jobType) || other.jobType == jobType)&&(identical(other.description, description) || other.description == description)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.jobTypeError, jobTypeError) || other.jobTypeError == jobTypeError)&&(identical(other.descriptionError, descriptionError) || other.descriptionError == descriptionError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,jobId,title,jobType,description,isSubmitting,submitted,errorMessage,titleError,jobTypeError,descriptionError);
}

@override
String toString() {
    return 'JobFormState(jobId: $jobId, title: $title, jobType: $jobType, description: $description, isSubmitting: $isSubmitting, submitted: $submitted, errorMessage: $errorMessage, titleError: $titleError, jobTypeError: $jobTypeError, descriptionError: $descriptionError)';
}


}

/// @nodoc
abstract mixin class _$JobFormStateCopyWith<$Res> implements $JobFormStateCopyWith<$Res> {
  factory _$JobFormStateCopyWith(_JobFormState value, $Res Function(_JobFormState) _then) = __$JobFormStateCopyWithImpl;
@override @useResult
$Res call({
 String? jobId, String title, JobType? jobType, String description, bool isSubmitting, bool submitted, String? errorMessage, String? titleError, String? jobTypeError, String? descriptionError
});




}
/// @nodoc
class __$JobFormStateCopyWithImpl<$Res>
    implements _$JobFormStateCopyWith<$Res> {
  __$JobFormStateCopyWithImpl(this._self, this._then);

  final _JobFormState _self;
  final $Res Function(_JobFormState) _then;

/// Create a copy of JobFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? jobId = freezed,Object? title = null,Object? jobType = freezed,Object? description = null,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? titleError = freezed,Object? jobTypeError = freezed,Object? descriptionError = freezed,}) {
  return _then(_JobFormState(
jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,jobType: freezed == jobType ? _self.jobType : jobType // ignore: cast_nullable_to_non_nullable
as JobType?,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,jobTypeError: freezed == jobTypeError ? _self.jobTypeError : jobTypeError // ignore: cast_nullable_to_non_nullable
as String?,descriptionError: freezed == descriptionError ? _self.descriptionError : descriptionError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
