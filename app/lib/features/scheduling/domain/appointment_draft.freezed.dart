// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'appointment_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppointmentDraft {

 DateTime get date; int get startHour; int get startMinute; int get durationMinutes; String get notes;
/// Create a copy of AppointmentDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppointmentDraftCopyWith<AppointmentDraft> get copyWith => _$AppointmentDraftCopyWithImpl<AppointmentDraft>(this as AppointmentDraft, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AppointmentDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppointmentDraft&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.startHour, _this.startHour) || other.startHour == _this.startHour)&&(identical(other.startMinute, _this.startMinute) || other.startMinute == _this.startMinute)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.notes, _this.notes) || other.notes == _this.notes));
}


@override
int get hashCode {
  final _this = this as AppointmentDraft;
  return Object.hash(runtimeType,_this.date,_this.startHour,_this.startMinute,_this.durationMinutes,_this.notes);
}

@override
String toString() {
  final _this = this as AppointmentDraft;
  return 'AppointmentDraft(date: ${_this.date}, startHour: ${_this.startHour}, startMinute: ${_this.startMinute}, durationMinutes: ${_this.durationMinutes}, notes: ${_this.notes})';
}


}

/// @nodoc
abstract mixin class $AppointmentDraftCopyWith<$Res>  {
  factory $AppointmentDraftCopyWith(AppointmentDraft value, $Res Function(AppointmentDraft) _then) = _$AppointmentDraftCopyWithImpl;
@useResult
$Res call({
 DateTime date, int startHour, int startMinute, int durationMinutes, String notes
});




}
/// @nodoc
class _$AppointmentDraftCopyWithImpl<$Res>
    implements $AppointmentDraftCopyWith<$Res> {
  _$AppointmentDraftCopyWithImpl(this._self, this._then);

  final AppointmentDraft _self;
  final $Res Function(AppointmentDraft) _then;

/// Create a copy of AppointmentDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? startHour = null,Object? startMinute = null,Object? durationMinutes = null,Object? notes = null,}) {
  return _then(AppointmentDraft(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startHour: null == startHour ? _self.startHour : startHour // ignore: cast_nullable_to_non_nullable
as int,startMinute: null == startMinute ? _self.startMinute : startMinute // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppointmentDraft].
extension AppointmentDraftPatterns on AppointmentDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppointmentDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppointmentDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppointmentDraft value)  $default,){
final _that = this;
switch (_that) {
case _AppointmentDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppointmentDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AppointmentDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime date,  int startHour,  int startMinute,  int durationMinutes,  String notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppointmentDraft() when $default != null:
return $default(_that.date,_that.startHour,_that.startMinute,_that.durationMinutes,_that.notes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime date,  int startHour,  int startMinute,  int durationMinutes,  String notes)  $default,) {final _that = this;
switch (_that) {
case _AppointmentDraft():
return $default(_that.date,_that.startHour,_that.startMinute,_that.durationMinutes,_that.notes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime date,  int startHour,  int startMinute,  int durationMinutes,  String notes)?  $default,) {final _that = this;
switch (_that) {
case _AppointmentDraft() when $default != null:
return $default(_that.date,_that.startHour,_that.startMinute,_that.durationMinutes,_that.notes);case _:
  return null;

}
}

}

/// @nodoc


class _AppointmentDraft implements AppointmentDraft {
  const _AppointmentDraft({required this.date, required this.startHour, required this.startMinute, required this.durationMinutes, this.notes = ''});
  

@override final  DateTime date;
@override final  int startHour;
@override final  int startMinute;
@override final  int durationMinutes;
@override@JsonKey() final  String notes;

/// Create a copy of AppointmentDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppointmentDraftCopyWith<_AppointmentDraft> get copyWith => __$AppointmentDraftCopyWithImpl<_AppointmentDraft>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppointmentDraft&&(identical(other.date, date) || other.date == date)&&(identical(other.startHour, startHour) || other.startHour == startHour)&&(identical(other.startMinute, startMinute) || other.startMinute == startMinute)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.notes, notes) || other.notes == notes));
}


@override
int get hashCode {
    return Object.hash(runtimeType,date,startHour,startMinute,durationMinutes,notes);
}

@override
String toString() {
    return 'AppointmentDraft(date: $date, startHour: $startHour, startMinute: $startMinute, durationMinutes: $durationMinutes, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$AppointmentDraftCopyWith<$Res> implements $AppointmentDraftCopyWith<$Res> {
  factory _$AppointmentDraftCopyWith(_AppointmentDraft value, $Res Function(_AppointmentDraft) _then) = __$AppointmentDraftCopyWithImpl;
@override @useResult
$Res call({
 DateTime date, int startHour, int startMinute, int durationMinutes, String notes
});




}
/// @nodoc
class __$AppointmentDraftCopyWithImpl<$Res>
    implements _$AppointmentDraftCopyWith<$Res> {
  __$AppointmentDraftCopyWithImpl(this._self, this._then);

  final _AppointmentDraft _self;
  final $Res Function(_AppointmentDraft) _then;

/// Create a copy of AppointmentDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? startHour = null,Object? startMinute = null,Object? durationMinutes = null,Object? notes = null,}) {
  return _then(_AppointmentDraft(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,startHour: null == startHour ? _self.startHour : startHour // ignore: cast_nullable_to_non_nullable
as int,startMinute: null == startMinute ? _self.startMinute : startMinute // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
