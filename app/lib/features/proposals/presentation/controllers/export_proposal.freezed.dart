// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'export_proposal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExportProposalState {

 bool get creating; ProposalExport? get export; Uint8List? get bytes; List<String>? get missing; String? get errorMessage; bool get canRetry;
/// Create a copy of ExportProposalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportProposalStateCopyWith<ExportProposalState> get copyWith => _$ExportProposalStateCopyWithImpl<ExportProposalState>(this as ExportProposalState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ExportProposalState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportProposalState&&(identical(other.creating, _this.creating) || other.creating == _this.creating)&&(identical(other.export, _this.export) || other.export == _this.export)&&const DeepCollectionEquality().equals(other.bytes, _this.bytes)&&const DeepCollectionEquality().equals(other.missing, _this.missing)&&(identical(other.errorMessage, _this.errorMessage) || other.errorMessage == _this.errorMessage)&&(identical(other.canRetry, _this.canRetry) || other.canRetry == _this.canRetry));
}


@override
int get hashCode {
  final _this = this as ExportProposalState;
  return Object.hash(runtimeType,_this.creating,_this.export,const DeepCollectionEquality().hash(_this.bytes),const DeepCollectionEquality().hash(_this.missing),_this.errorMessage,_this.canRetry);
}

@override
String toString() {
  final _this = this as ExportProposalState;
  return 'ExportProposalState(creating: ${_this.creating}, export: ${_this.export}, bytes: ${_this.bytes}, missing: ${_this.missing}, errorMessage: ${_this.errorMessage}, canRetry: ${_this.canRetry})';
}


}

/// @nodoc
abstract mixin class $ExportProposalStateCopyWith<$Res>  {
  factory $ExportProposalStateCopyWith(ExportProposalState value, $Res Function(ExportProposalState) _then) = _$ExportProposalStateCopyWithImpl;
@useResult
$Res call({
 bool creating, ProposalExport? export, Uint8List? bytes, List<String>? missing, String? errorMessage, bool canRetry
});




}
/// @nodoc
class _$ExportProposalStateCopyWithImpl<$Res>
    implements $ExportProposalStateCopyWith<$Res> {
  _$ExportProposalStateCopyWithImpl(this._self, this._then);

  final ExportProposalState _self;
  final $Res Function(ExportProposalState) _then;

/// Create a copy of ExportProposalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? creating = null,Object? export = freezed,Object? bytes = freezed,Object? missing = freezed,Object? errorMessage = freezed,Object? canRetry = null,}) {
  return _then(ExportProposalState(
creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,export: freezed == export ? _self.export : export // ignore: cast_nullable_to_non_nullable
as ProposalExport?,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,missing: freezed == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as List<String>?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExportProposalState].
extension ExportProposalStatePatterns on ExportProposalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExportProposalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExportProposalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExportProposalState value)  $default,){
final _that = this;
switch (_that) {
case _ExportProposalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExportProposalState value)?  $default,){
final _that = this;
switch (_that) {
case _ExportProposalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool creating,  ProposalExport? export,  Uint8List? bytes,  List<String>? missing,  String? errorMessage,  bool canRetry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExportProposalState() when $default != null:
return $default(_that.creating,_that.export,_that.bytes,_that.missing,_that.errorMessage,_that.canRetry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool creating,  ProposalExport? export,  Uint8List? bytes,  List<String>? missing,  String? errorMessage,  bool canRetry)  $default,) {final _that = this;
switch (_that) {
case _ExportProposalState():
return $default(_that.creating,_that.export,_that.bytes,_that.missing,_that.errorMessage,_that.canRetry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool creating,  ProposalExport? export,  Uint8List? bytes,  List<String>? missing,  String? errorMessage,  bool canRetry)?  $default,) {final _that = this;
switch (_that) {
case _ExportProposalState() when $default != null:
return $default(_that.creating,_that.export,_that.bytes,_that.missing,_that.errorMessage,_that.canRetry);case _:
  return null;

}
}

}

/// @nodoc


class _ExportProposalState implements ExportProposalState {
  const _ExportProposalState({this.creating = false, this.export, this.bytes,  List<String>? missing, this.errorMessage, this.canRetry = false}): _missing = missing;
  

@override@JsonKey() final  bool creating;
@override final  ProposalExport? export;
@override final  Uint8List? bytes;
 final  List<String>? _missing;
@override List<String>? get missing {
  final value = _missing;
  if (value == null) return null;
  if (_missing is EqualUnmodifiableListView) return _missing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? errorMessage;
@override@JsonKey() final  bool canRetry;

/// Create a copy of ExportProposalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExportProposalStateCopyWith<_ExportProposalState> get copyWith => __$ExportProposalStateCopyWithImpl<_ExportProposalState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExportProposalState&&(identical(other.creating, creating) || other.creating == creating)&&(identical(other.export, export) || other.export == export)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&const DeepCollectionEquality().equals(other.missing, _missing)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.canRetry, canRetry) || other.canRetry == canRetry));
}


@override
int get hashCode {
    return Object.hash(runtimeType,creating,export,const DeepCollectionEquality().hash(bytes),const DeepCollectionEquality().hash(_missing),errorMessage,canRetry);
}

@override
String toString() {
    return 'ExportProposalState(creating: $creating, export: $export, bytes: $bytes, missing: $missing, errorMessage: $errorMessage, canRetry: $canRetry)';
}


}

/// @nodoc
abstract mixin class _$ExportProposalStateCopyWith<$Res> implements $ExportProposalStateCopyWith<$Res> {
  factory _$ExportProposalStateCopyWith(_ExportProposalState value, $Res Function(_ExportProposalState) _then) = __$ExportProposalStateCopyWithImpl;
@override @useResult
$Res call({
 bool creating, ProposalExport? export, Uint8List? bytes, List<String>? missing, String? errorMessage, bool canRetry
});




}
/// @nodoc
class __$ExportProposalStateCopyWithImpl<$Res>
    implements _$ExportProposalStateCopyWith<$Res> {
  __$ExportProposalStateCopyWithImpl(this._self, this._then);

  final _ExportProposalState _self;
  final $Res Function(_ExportProposalState) _then;

/// Create a copy of ExportProposalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? creating = null,Object? export = freezed,Object? bytes = freezed,Object? missing = freezed,Object? errorMessage = freezed,Object? canRetry = null,}) {
  return _then(_ExportProposalState(
creating: null == creating ? _self.creating : creating // ignore: cast_nullable_to_non_nullable
as bool,export: freezed == export ? _self.export : export // ignore: cast_nullable_to_non_nullable
as ProposalExport?,bytes: freezed == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List?,missing: freezed == missing ? _self._missing : missing // ignore: cast_nullable_to_non_nullable
as List<String>?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,canRetry: null == canRetry ? _self.canRetry : canRetry // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
