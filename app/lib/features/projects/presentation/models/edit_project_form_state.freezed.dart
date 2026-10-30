// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_project_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$EditProjectFormState {

 String get projectId; String get title; String get street; String get city; String get state; String get zip; bool get isSubmitting; bool get submitted; String? get errorMessage; String? get titleError; String? get streetError; String? get cityError; String? get stateError; String? get zipError;
/// Create a copy of EditProjectFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EditProjectFormStateCopyWith<EditProjectFormState> get copyWith => _$EditProjectFormStateCopyWithImpl<EditProjectFormState>(this as EditProjectFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as EditProjectFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EditProjectFormState&&(identical(other.projectId, _this.projectId) || other.projectId == _this.projectId)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.street, _this.street) || other.street == _this.street)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.zip, _this.zip) || other.zip == _this.zip)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.titleError, _this.titleError) || other.titleError == _this.titleError)&&(identical(other.streetError, _this.streetError) || other.streetError == _this.streetError)&&(identical(other.cityError, _this.cityError) || other.cityError == _this.cityError)&&(identical(other.stateError, _this.stateError) || other.stateError == _this.stateError)&&(identical(other.zipError, _this.zipError) || other.zipError == _this.zipError));
}


@override
int get hashCode {
  final _this = this as EditProjectFormState;
  return Object.hash(runtimeType,_this.projectId,_this.title,_this.street,_this.city,_this.state,_this.zip,_this.isSubmitting,_this.submitted,_this.errorMessage,_this.titleError,_this.streetError,_this.cityError,_this.stateError,_this.zipError);
}

@override
String toString() {
  final _this = this as EditProjectFormState;
  return 'EditProjectFormState(projectId: ${_this.projectId}, title: ${_this.title}, street: ${_this.street}, city: ${_this.city}, state: ${_this.state}, zip: ${_this.zip}, isSubmitting: ${_this.isSubmitting}, submitted: ${_this.submitted}, errorMessage: ${_this.errorMessage}, titleError: ${_this.titleError}, streetError: ${_this.streetError}, cityError: ${_this.cityError}, stateError: ${_this.stateError}, zipError: ${_this.zipError})';
}


}

/// @nodoc
abstract mixin class $EditProjectFormStateCopyWith<$Res>  {
  factory $EditProjectFormStateCopyWith(EditProjectFormState value, $Res Function(EditProjectFormState) _then) = _$EditProjectFormStateCopyWithImpl;
@useResult
$Res call({
 String projectId, String title, String street, String city, String state, String zip, bool isSubmitting, bool submitted, String? errorMessage, String? titleError, String? streetError, String? cityError, String? stateError, String? zipError
});




}
/// @nodoc
class _$EditProjectFormStateCopyWithImpl<$Res>
    implements $EditProjectFormStateCopyWith<$Res> {
  _$EditProjectFormStateCopyWithImpl(this._self, this._then);

  final EditProjectFormState _self;
  final $Res Function(EditProjectFormState) _then;

/// Create a copy of EditProjectFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? projectId = null,Object? title = null,Object? street = null,Object? city = null,Object? state = null,Object? zip = null,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? titleError = freezed,Object? streetError = freezed,Object? cityError = freezed,Object? stateError = freezed,Object? zipError = freezed,}) {
  return _then(EditProjectFormState(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zip: null == zip ? _self.zip : zip // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,streetError: freezed == streetError ? _self.streetError : streetError // ignore: cast_nullable_to_non_nullable
as String?,cityError: freezed == cityError ? _self.cityError : cityError // ignore: cast_nullable_to_non_nullable
as String?,stateError: freezed == stateError ? _self.stateError : stateError // ignore: cast_nullable_to_non_nullable
as String?,zipError: freezed == zipError ? _self.zipError : zipError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EditProjectFormState].
extension EditProjectFormStatePatterns on EditProjectFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EditProjectFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EditProjectFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EditProjectFormState value)  $default,){
final _that = this;
switch (_that) {
case _EditProjectFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EditProjectFormState value)?  $default,){
final _that = this;
switch (_that) {
case _EditProjectFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String projectId,  String title,  String street,  String city,  String state,  String zip,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? titleError,  String? streetError,  String? cityError,  String? stateError,  String? zipError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EditProjectFormState() when $default != null:
return $default(_that.projectId,_that.title,_that.street,_that.city,_that.state,_that.zip,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.titleError,_that.streetError,_that.cityError,_that.stateError,_that.zipError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String projectId,  String title,  String street,  String city,  String state,  String zip,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? titleError,  String? streetError,  String? cityError,  String? stateError,  String? zipError)  $default,) {final _that = this;
switch (_that) {
case _EditProjectFormState():
return $default(_that.projectId,_that.title,_that.street,_that.city,_that.state,_that.zip,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.titleError,_that.streetError,_that.cityError,_that.stateError,_that.zipError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String projectId,  String title,  String street,  String city,  String state,  String zip,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? titleError,  String? streetError,  String? cityError,  String? stateError,  String? zipError)?  $default,) {final _that = this;
switch (_that) {
case _EditProjectFormState() when $default != null:
return $default(_that.projectId,_that.title,_that.street,_that.city,_that.state,_that.zip,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.titleError,_that.streetError,_that.cityError,_that.stateError,_that.zipError);case _:
  return null;

}
}

}

/// @nodoc


class _EditProjectFormState implements EditProjectFormState {
  const _EditProjectFormState({required this.projectId, this.title = '', this.street = '', this.city = '', this.state = '', this.zip = '', this.isSubmitting = false, this.submitted = false, this.errorMessage, this.titleError, this.streetError, this.cityError, this.stateError, this.zipError});
  

@override final  String projectId;
@override@JsonKey() final  String title;
@override@JsonKey() final  String street;
@override@JsonKey() final  String city;
@override@JsonKey() final  String state;
@override@JsonKey() final  String zip;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool submitted;
@override final  String? errorMessage;
@override final  String? titleError;
@override final  String? streetError;
@override final  String? cityError;
@override final  String? stateError;
@override final  String? zipError;

/// Create a copy of EditProjectFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EditProjectFormStateCopyWith<_EditProjectFormState> get copyWith => __$EditProjectFormStateCopyWithImpl<_EditProjectFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EditProjectFormState&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.street, street) || other.street == street)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zip, zip) || other.zip == zip)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.titleError, titleError) || other.titleError == titleError)&&(identical(other.streetError, streetError) || other.streetError == streetError)&&(identical(other.cityError, cityError) || other.cityError == cityError)&&(identical(other.stateError, stateError) || other.stateError == stateError)&&(identical(other.zipError, zipError) || other.zipError == zipError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,projectId,title,street,city,state,zip,isSubmitting,submitted,errorMessage,titleError,streetError,cityError,stateError,zipError);
}

@override
String toString() {
    return 'EditProjectFormState(projectId: $projectId, title: $title, street: $street, city: $city, state: $state, zip: $zip, isSubmitting: $isSubmitting, submitted: $submitted, errorMessage: $errorMessage, titleError: $titleError, streetError: $streetError, cityError: $cityError, stateError: $stateError, zipError: $zipError)';
}


}

/// @nodoc
abstract mixin class _$EditProjectFormStateCopyWith<$Res> implements $EditProjectFormStateCopyWith<$Res> {
  factory _$EditProjectFormStateCopyWith(_EditProjectFormState value, $Res Function(_EditProjectFormState) _then) = __$EditProjectFormStateCopyWithImpl;
@override @useResult
$Res call({
 String projectId, String title, String street, String city, String state, String zip, bool isSubmitting, bool submitted, String? errorMessage, String? titleError, String? streetError, String? cityError, String? stateError, String? zipError
});




}
/// @nodoc
class __$EditProjectFormStateCopyWithImpl<$Res>
    implements _$EditProjectFormStateCopyWith<$Res> {
  __$EditProjectFormStateCopyWithImpl(this._self, this._then);

  final _EditProjectFormState _self;
  final $Res Function(_EditProjectFormState) _then;

/// Create a copy of EditProjectFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? projectId = null,Object? title = null,Object? street = null,Object? city = null,Object? state = null,Object? zip = null,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? titleError = freezed,Object? streetError = freezed,Object? cityError = freezed,Object? stateError = freezed,Object? zipError = freezed,}) {
  return _then(_EditProjectFormState(
projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zip: null == zip ? _self.zip : zip // ignore: cast_nullable_to_non_nullable
as String,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,titleError: freezed == titleError ? _self.titleError : titleError // ignore: cast_nullable_to_non_nullable
as String?,streetError: freezed == streetError ? _self.streetError : streetError // ignore: cast_nullable_to_non_nullable
as String?,cityError: freezed == cityError ? _self.cityError : cityError // ignore: cast_nullable_to_non_nullable
as String?,stateError: freezed == stateError ? _self.stateError : stateError // ignore: cast_nullable_to_non_nullable
as String?,zipError: freezed == zipError ? _self.zipError : zipError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
