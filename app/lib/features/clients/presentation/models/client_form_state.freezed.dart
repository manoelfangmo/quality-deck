// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ClientFormState {

 ClientFormMode get mode; String? get clientId; String get fullName; String get phone; String get email; String get street; String get city; String get state; String get zip; bool get appointmentOpen; AppointmentDraft? get appointmentDraft; bool get isSubmitting; bool get submitted; String? get errorMessage; String? get nameError; String? get phoneError; String? get emailError; String? get addressError; String? get stateError; String? get zipError; String? get appointmentDateError; String? get appointmentTimeError; String? get appointmentDurationError; String? get appointmentNotesError;
/// Create a copy of ClientFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientFormStateCopyWith<ClientFormState> get copyWith => _$ClientFormStateCopyWithImpl<ClientFormState>(this as ClientFormState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ClientFormState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientFormState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.clientId, _this.clientId) || other.clientId == _this.clientId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.street, _this.street) || other.street == _this.street)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.state, _this.state) || other.state == _this.state)&&(identical(other.zip, _this.zip) || other.zip == _this.zip)&&(identical(other.appointmentOpen, _this.appointmentOpen) || other.appointmentOpen == _this.appointmentOpen)&&(identical(other.appointmentDraft, _this.appointmentDraft) || other.appointmentDraft == _this.appointmentDraft)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.nameError, _this.nameError) || other.nameError == _this.nameError)&&(identical(other.phoneError, _this.phoneError) || other.phoneError == _this.phoneError)&&(identical(other.emailError, _this.emailError) || other.emailError == _this.emailError)&&(identical(other.addressError, _this.addressError) || other.addressError == _this.addressError)&&(identical(other.stateError, _this.stateError) || other.stateError == _this.stateError)&&(identical(other.zipError, _this.zipError) || other.zipError == _this.zipError)&&(identical(other.appointmentDateError, _this.appointmentDateError) || other.appointmentDateError == _this.appointmentDateError)&&(identical(other.appointmentTimeError, _this.appointmentTimeError) || other.appointmentTimeError == _this.appointmentTimeError)&&(identical(other.appointmentDurationError, _this.appointmentDurationError) || other.appointmentDurationError == _this.appointmentDurationError)&&(identical(other.appointmentNotesError, _this.appointmentNotesError) || other.appointmentNotesError == _this.appointmentNotesError));
}


@override
int get hashCode {
  final _this = this as ClientFormState;
  return Object.hashAll([runtimeType,_this.mode,_this.clientId,_this.fullName,_this.phone,_this.email,_this.street,_this.city,_this.state,_this.zip,_this.appointmentOpen,_this.appointmentDraft,_this.isSubmitting,_this.submitted,_this.errorMessage,_this.nameError,_this.phoneError,_this.emailError,_this.addressError,_this.stateError,_this.zipError,_this.appointmentDateError,_this.appointmentTimeError,_this.appointmentDurationError,_this.appointmentNotesError]);
}

@override
String toString() {
  final _this = this as ClientFormState;
  return 'ClientFormState(mode: ${_this.mode}, clientId: ${_this.clientId}, fullName: ${_this.fullName}, phone: ${_this.phone}, email: ${_this.email}, street: ${_this.street}, city: ${_this.city}, state: ${_this.state}, zip: ${_this.zip}, appointmentOpen: ${_this.appointmentOpen}, appointmentDraft: ${_this.appointmentDraft}, isSubmitting: ${_this.isSubmitting}, submitted: ${_this.submitted}, errorMessage: ${_this.errorMessage}, nameError: ${_this.nameError}, phoneError: ${_this.phoneError}, emailError: ${_this.emailError}, addressError: ${_this.addressError}, stateError: ${_this.stateError}, zipError: ${_this.zipError}, appointmentDateError: ${_this.appointmentDateError}, appointmentTimeError: ${_this.appointmentTimeError}, appointmentDurationError: ${_this.appointmentDurationError}, appointmentNotesError: ${_this.appointmentNotesError})';
}


}

/// @nodoc
abstract mixin class $ClientFormStateCopyWith<$Res>  {
  factory $ClientFormStateCopyWith(ClientFormState value, $Res Function(ClientFormState) _then) = _$ClientFormStateCopyWithImpl;
@useResult
$Res call({
 ClientFormMode mode, String? clientId, String fullName, String phone, String email, String street, String city, String state, String zip, bool appointmentOpen, AppointmentDraft? appointmentDraft, bool isSubmitting, bool submitted, String? errorMessage, String? nameError, String? phoneError, String? emailError, String? addressError, String? stateError, String? zipError, String? appointmentDateError, String? appointmentTimeError, String? appointmentDurationError, String? appointmentNotesError
});


$AppointmentDraftCopyWith<$Res>? get appointmentDraft;

}
/// @nodoc
class _$ClientFormStateCopyWithImpl<$Res>
    implements $ClientFormStateCopyWith<$Res> {
  _$ClientFormStateCopyWithImpl(this._self, this._then);

  final ClientFormState _self;
  final $Res Function(ClientFormState) _then;

/// Create a copy of ClientFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? clientId = freezed,Object? fullName = null,Object? phone = null,Object? email = null,Object? street = null,Object? city = null,Object? state = null,Object? zip = null,Object? appointmentOpen = null,Object? appointmentDraft = freezed,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? nameError = freezed,Object? phoneError = freezed,Object? emailError = freezed,Object? addressError = freezed,Object? stateError = freezed,Object? zipError = freezed,Object? appointmentDateError = freezed,Object? appointmentTimeError = freezed,Object? appointmentDurationError = freezed,Object? appointmentNotesError = freezed,}) {
  return _then(ClientFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ClientFormMode,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zip: null == zip ? _self.zip : zip // ignore: cast_nullable_to_non_nullable
as String,appointmentOpen: null == appointmentOpen ? _self.appointmentOpen : appointmentOpen // ignore: cast_nullable_to_non_nullable
as bool,appointmentDraft: freezed == appointmentDraft ? _self.appointmentDraft : appointmentDraft // ignore: cast_nullable_to_non_nullable
as AppointmentDraft?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,phoneError: freezed == phoneError ? _self.phoneError : phoneError // ignore: cast_nullable_to_non_nullable
as String?,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as String?,addressError: freezed == addressError ? _self.addressError : addressError // ignore: cast_nullable_to_non_nullable
as String?,stateError: freezed == stateError ? _self.stateError : stateError // ignore: cast_nullable_to_non_nullable
as String?,zipError: freezed == zipError ? _self.zipError : zipError // ignore: cast_nullable_to_non_nullable
as String?,appointmentDateError: freezed == appointmentDateError ? _self.appointmentDateError : appointmentDateError // ignore: cast_nullable_to_non_nullable
as String?,appointmentTimeError: freezed == appointmentTimeError ? _self.appointmentTimeError : appointmentTimeError // ignore: cast_nullable_to_non_nullable
as String?,appointmentDurationError: freezed == appointmentDurationError ? _self.appointmentDurationError : appointmentDurationError // ignore: cast_nullable_to_non_nullable
as String?,appointmentNotesError: freezed == appointmentNotesError ? _self.appointmentNotesError : appointmentNotesError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ClientFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDraftCopyWith<$Res>? get appointmentDraft {
    if (_self.appointmentDraft == null) {
    return null;
  }

  return $AppointmentDraftCopyWith<$Res>(_self.appointmentDraft!, (value) {
    return _then(_self.copyWith(appointmentDraft: value));
  });
}
}


/// Adds pattern-matching-related methods to [ClientFormState].
extension ClientFormStatePatterns on ClientFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientFormState value)  $default,){
final _that = this;
switch (_that) {
case _ClientFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ClientFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ClientFormMode mode,  String? clientId,  String fullName,  String phone,  String email,  String street,  String city,  String state,  String zip,  bool appointmentOpen,  AppointmentDraft? appointmentDraft,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? nameError,  String? phoneError,  String? emailError,  String? addressError,  String? stateError,  String? zipError,  String? appointmentDateError,  String? appointmentTimeError,  String? appointmentDurationError,  String? appointmentNotesError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientFormState() when $default != null:
return $default(_that.mode,_that.clientId,_that.fullName,_that.phone,_that.email,_that.street,_that.city,_that.state,_that.zip,_that.appointmentOpen,_that.appointmentDraft,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.nameError,_that.phoneError,_that.emailError,_that.addressError,_that.stateError,_that.zipError,_that.appointmentDateError,_that.appointmentTimeError,_that.appointmentDurationError,_that.appointmentNotesError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ClientFormMode mode,  String? clientId,  String fullName,  String phone,  String email,  String street,  String city,  String state,  String zip,  bool appointmentOpen,  AppointmentDraft? appointmentDraft,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? nameError,  String? phoneError,  String? emailError,  String? addressError,  String? stateError,  String? zipError,  String? appointmentDateError,  String? appointmentTimeError,  String? appointmentDurationError,  String? appointmentNotesError)  $default,) {final _that = this;
switch (_that) {
case _ClientFormState():
return $default(_that.mode,_that.clientId,_that.fullName,_that.phone,_that.email,_that.street,_that.city,_that.state,_that.zip,_that.appointmentOpen,_that.appointmentDraft,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.nameError,_that.phoneError,_that.emailError,_that.addressError,_that.stateError,_that.zipError,_that.appointmentDateError,_that.appointmentTimeError,_that.appointmentDurationError,_that.appointmentNotesError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ClientFormMode mode,  String? clientId,  String fullName,  String phone,  String email,  String street,  String city,  String state,  String zip,  bool appointmentOpen,  AppointmentDraft? appointmentDraft,  bool isSubmitting,  bool submitted,  String? errorMessage,  String? nameError,  String? phoneError,  String? emailError,  String? addressError,  String? stateError,  String? zipError,  String? appointmentDateError,  String? appointmentTimeError,  String? appointmentDurationError,  String? appointmentNotesError)?  $default,) {final _that = this;
switch (_that) {
case _ClientFormState() when $default != null:
return $default(_that.mode,_that.clientId,_that.fullName,_that.phone,_that.email,_that.street,_that.city,_that.state,_that.zip,_that.appointmentOpen,_that.appointmentDraft,_that.isSubmitting,_that.submitted,_that.errorMessage,_that.nameError,_that.phoneError,_that.emailError,_that.addressError,_that.stateError,_that.zipError,_that.appointmentDateError,_that.appointmentTimeError,_that.appointmentDurationError,_that.appointmentNotesError);case _:
  return null;

}
}

}

/// @nodoc


class _ClientFormState extends ClientFormState {
  const _ClientFormState({this.mode = ClientFormMode.add, this.clientId, this.fullName = '', this.phone = '', this.email = '', this.street = '', this.city = '', this.state = '', this.zip = '', this.appointmentOpen = false, this.appointmentDraft, this.isSubmitting = false, this.submitted = false, this.errorMessage, this.nameError, this.phoneError, this.emailError, this.addressError, this.stateError, this.zipError, this.appointmentDateError, this.appointmentTimeError, this.appointmentDurationError, this.appointmentNotesError}): super._();
  

@override@JsonKey() final  ClientFormMode mode;
@override final  String? clientId;
@override@JsonKey() final  String fullName;
@override@JsonKey() final  String phone;
@override@JsonKey() final  String email;
@override@JsonKey() final  String street;
@override@JsonKey() final  String city;
@override@JsonKey() final  String state;
@override@JsonKey() final  String zip;
@override@JsonKey() final  bool appointmentOpen;
@override final  AppointmentDraft? appointmentDraft;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool submitted;
@override final  String? errorMessage;
@override final  String? nameError;
@override final  String? phoneError;
@override final  String? emailError;
@override final  String? addressError;
@override final  String? stateError;
@override final  String? zipError;
@override final  String? appointmentDateError;
@override final  String? appointmentTimeError;
@override final  String? appointmentDurationError;
@override final  String? appointmentNotesError;

/// Create a copy of ClientFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientFormStateCopyWith<_ClientFormState> get copyWith => __$ClientFormStateCopyWithImpl<_ClientFormState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientFormState&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.street, street) || other.street == street)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.zip, zip) || other.zip == zip)&&(identical(other.appointmentOpen, appointmentOpen) || other.appointmentOpen == appointmentOpen)&&(identical(other.appointmentDraft, appointmentDraft) || other.appointmentDraft == appointmentDraft)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.phoneError, phoneError) || other.phoneError == phoneError)&&(identical(other.emailError, emailError) || other.emailError == emailError)&&(identical(other.addressError, addressError) || other.addressError == addressError)&&(identical(other.stateError, stateError) || other.stateError == stateError)&&(identical(other.zipError, zipError) || other.zipError == zipError)&&(identical(other.appointmentDateError, appointmentDateError) || other.appointmentDateError == appointmentDateError)&&(identical(other.appointmentTimeError, appointmentTimeError) || other.appointmentTimeError == appointmentTimeError)&&(identical(other.appointmentDurationError, appointmentDurationError) || other.appointmentDurationError == appointmentDurationError)&&(identical(other.appointmentNotesError, appointmentNotesError) || other.appointmentNotesError == appointmentNotesError));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,mode,clientId,fullName,phone,email,street,city,state,zip,appointmentOpen,appointmentDraft,isSubmitting,submitted,errorMessage,nameError,phoneError,emailError,addressError,stateError,zipError,appointmentDateError,appointmentTimeError,appointmentDurationError,appointmentNotesError]);
}

@override
String toString() {
    return 'ClientFormState(mode: $mode, clientId: $clientId, fullName: $fullName, phone: $phone, email: $email, street: $street, city: $city, state: $state, zip: $zip, appointmentOpen: $appointmentOpen, appointmentDraft: $appointmentDraft, isSubmitting: $isSubmitting, submitted: $submitted, errorMessage: $errorMessage, nameError: $nameError, phoneError: $phoneError, emailError: $emailError, addressError: $addressError, stateError: $stateError, zipError: $zipError, appointmentDateError: $appointmentDateError, appointmentTimeError: $appointmentTimeError, appointmentDurationError: $appointmentDurationError, appointmentNotesError: $appointmentNotesError)';
}


}

/// @nodoc
abstract mixin class _$ClientFormStateCopyWith<$Res> implements $ClientFormStateCopyWith<$Res> {
  factory _$ClientFormStateCopyWith(_ClientFormState value, $Res Function(_ClientFormState) _then) = __$ClientFormStateCopyWithImpl;
@override @useResult
$Res call({
 ClientFormMode mode, String? clientId, String fullName, String phone, String email, String street, String city, String state, String zip, bool appointmentOpen, AppointmentDraft? appointmentDraft, bool isSubmitting, bool submitted, String? errorMessage, String? nameError, String? phoneError, String? emailError, String? addressError, String? stateError, String? zipError, String? appointmentDateError, String? appointmentTimeError, String? appointmentDurationError, String? appointmentNotesError
});


@override $AppointmentDraftCopyWith<$Res>? get appointmentDraft;

}
/// @nodoc
class __$ClientFormStateCopyWithImpl<$Res>
    implements _$ClientFormStateCopyWith<$Res> {
  __$ClientFormStateCopyWithImpl(this._self, this._then);

  final _ClientFormState _self;
  final $Res Function(_ClientFormState) _then;

/// Create a copy of ClientFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? clientId = freezed,Object? fullName = null,Object? phone = null,Object? email = null,Object? street = null,Object? city = null,Object? state = null,Object? zip = null,Object? appointmentOpen = null,Object? appointmentDraft = freezed,Object? isSubmitting = null,Object? submitted = null,Object? errorMessage = freezed,Object? nameError = freezed,Object? phoneError = freezed,Object? emailError = freezed,Object? addressError = freezed,Object? stateError = freezed,Object? zipError = freezed,Object? appointmentDateError = freezed,Object? appointmentTimeError = freezed,Object? appointmentDurationError = freezed,Object? appointmentNotesError = freezed,}) {
  return _then(_ClientFormState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as ClientFormMode,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,street: null == street ? _self.street : street // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,zip: null == zip ? _self.zip : zip // ignore: cast_nullable_to_non_nullable
as String,appointmentOpen: null == appointmentOpen ? _self.appointmentOpen : appointmentOpen // ignore: cast_nullable_to_non_nullable
as bool,appointmentDraft: freezed == appointmentDraft ? _self.appointmentDraft : appointmentDraft // ignore: cast_nullable_to_non_nullable
as AppointmentDraft?,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as String?,phoneError: freezed == phoneError ? _self.phoneError : phoneError // ignore: cast_nullable_to_non_nullable
as String?,emailError: freezed == emailError ? _self.emailError : emailError // ignore: cast_nullable_to_non_nullable
as String?,addressError: freezed == addressError ? _self.addressError : addressError // ignore: cast_nullable_to_non_nullable
as String?,stateError: freezed == stateError ? _self.stateError : stateError // ignore: cast_nullable_to_non_nullable
as String?,zipError: freezed == zipError ? _self.zipError : zipError // ignore: cast_nullable_to_non_nullable
as String?,appointmentDateError: freezed == appointmentDateError ? _self.appointmentDateError : appointmentDateError // ignore: cast_nullable_to_non_nullable
as String?,appointmentTimeError: freezed == appointmentTimeError ? _self.appointmentTimeError : appointmentTimeError // ignore: cast_nullable_to_non_nullable
as String?,appointmentDurationError: freezed == appointmentDurationError ? _self.appointmentDurationError : appointmentDurationError // ignore: cast_nullable_to_non_nullable
as String?,appointmentNotesError: freezed == appointmentNotesError ? _self.appointmentNotesError : appointmentNotesError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ClientFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppointmentDraftCopyWith<$Res>? get appointmentDraft {
    if (_self.appointmentDraft == null) {
    return null;
  }

  return $AppointmentDraftCopyWith<$Res>(_self.appointmentDraft!, (value) {
    return _then(_self.copyWith(appointmentDraft: value));
  });
}
}

// dart format on
