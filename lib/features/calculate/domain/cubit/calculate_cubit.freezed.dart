// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'calculate_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CalculateState {

 bool get loadingBarangays; bool get calculating; List<String> get barangays; String? get selectedBarangay; RainfallIntensity? get selectedIntensity; LogisticFloodResult? get result;// ✅ CHANGED from FloodCalculationResult
 String? get errorMessage;
/// Create a copy of CalculateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalculateStateCopyWith<CalculateState> get copyWith => _$CalculateStateCopyWithImpl<CalculateState>(this as CalculateState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalculateState&&(identical(other.loadingBarangays, loadingBarangays) || other.loadingBarangays == loadingBarangays)&&(identical(other.calculating, calculating) || other.calculating == calculating)&&const DeepCollectionEquality().equals(other.barangays, barangays)&&(identical(other.selectedBarangay, selectedBarangay) || other.selectedBarangay == selectedBarangay)&&(identical(other.selectedIntensity, selectedIntensity) || other.selectedIntensity == selectedIntensity)&&(identical(other.result, result) || other.result == result)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingBarangays,calculating,const DeepCollectionEquality().hash(barangays),selectedBarangay,selectedIntensity,result,errorMessage);

@override
String toString() {
  return 'CalculateState(loadingBarangays: $loadingBarangays, calculating: $calculating, barangays: $barangays, selectedBarangay: $selectedBarangay, selectedIntensity: $selectedIntensity, result: $result, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CalculateStateCopyWith<$Res>  {
  factory $CalculateStateCopyWith(CalculateState value, $Res Function(CalculateState) _then) = _$CalculateStateCopyWithImpl;
@useResult
$Res call({
 bool loadingBarangays, bool calculating, List<String> barangays, String? selectedBarangay, RainfallIntensity? selectedIntensity, LogisticFloodResult? result, String? errorMessage
});




}
/// @nodoc
class _$CalculateStateCopyWithImpl<$Res>
    implements $CalculateStateCopyWith<$Res> {
  _$CalculateStateCopyWithImpl(this._self, this._then);

  final CalculateState _self;
  final $Res Function(CalculateState) _then;

/// Create a copy of CalculateState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingBarangays = null,Object? calculating = null,Object? barangays = null,Object? selectedBarangay = freezed,Object? selectedIntensity = freezed,Object? result = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
loadingBarangays: null == loadingBarangays ? _self.loadingBarangays : loadingBarangays // ignore: cast_nullable_to_non_nullable
as bool,calculating: null == calculating ? _self.calculating : calculating // ignore: cast_nullable_to_non_nullable
as bool,barangays: null == barangays ? _self.barangays : barangays // ignore: cast_nullable_to_non_nullable
as List<String>,selectedBarangay: freezed == selectedBarangay ? _self.selectedBarangay : selectedBarangay // ignore: cast_nullable_to_non_nullable
as String?,selectedIntensity: freezed == selectedIntensity ? _self.selectedIntensity : selectedIntensity // ignore: cast_nullable_to_non_nullable
as RainfallIntensity?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as LogisticFloodResult?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CalculateState].
extension CalculateStatePatterns on CalculateState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CalculateState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CalculateState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CalculateState value)  $default,){
final _that = this;
switch (_that) {
case _CalculateState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CalculateState value)?  $default,){
final _that = this;
switch (_that) {
case _CalculateState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loadingBarangays,  bool calculating,  List<String> barangays,  String? selectedBarangay,  RainfallIntensity? selectedIntensity,  LogisticFloodResult? result,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CalculateState() when $default != null:
return $default(_that.loadingBarangays,_that.calculating,_that.barangays,_that.selectedBarangay,_that.selectedIntensity,_that.result,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loadingBarangays,  bool calculating,  List<String> barangays,  String? selectedBarangay,  RainfallIntensity? selectedIntensity,  LogisticFloodResult? result,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CalculateState():
return $default(_that.loadingBarangays,_that.calculating,_that.barangays,_that.selectedBarangay,_that.selectedIntensity,_that.result,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loadingBarangays,  bool calculating,  List<String> barangays,  String? selectedBarangay,  RainfallIntensity? selectedIntensity,  LogisticFloodResult? result,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CalculateState() when $default != null:
return $default(_that.loadingBarangays,_that.calculating,_that.barangays,_that.selectedBarangay,_that.selectedIntensity,_that.result,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CalculateState implements CalculateState {
  const _CalculateState({this.loadingBarangays = false, this.calculating = false, final  List<String> barangays = const [], this.selectedBarangay, this.selectedIntensity, this.result, this.errorMessage}): _barangays = barangays;
  

@override@JsonKey() final  bool loadingBarangays;
@override@JsonKey() final  bool calculating;
 final  List<String> _barangays;
@override@JsonKey() List<String> get barangays {
  if (_barangays is EqualUnmodifiableListView) return _barangays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_barangays);
}

@override final  String? selectedBarangay;
@override final  RainfallIntensity? selectedIntensity;
@override final  LogisticFloodResult? result;
// ✅ CHANGED from FloodCalculationResult
@override final  String? errorMessage;

/// Create a copy of CalculateState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CalculateStateCopyWith<_CalculateState> get copyWith => __$CalculateStateCopyWithImpl<_CalculateState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CalculateState&&(identical(other.loadingBarangays, loadingBarangays) || other.loadingBarangays == loadingBarangays)&&(identical(other.calculating, calculating) || other.calculating == calculating)&&const DeepCollectionEquality().equals(other._barangays, _barangays)&&(identical(other.selectedBarangay, selectedBarangay) || other.selectedBarangay == selectedBarangay)&&(identical(other.selectedIntensity, selectedIntensity) || other.selectedIntensity == selectedIntensity)&&(identical(other.result, result) || other.result == result)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loadingBarangays,calculating,const DeepCollectionEquality().hash(_barangays),selectedBarangay,selectedIntensity,result,errorMessage);

@override
String toString() {
  return 'CalculateState(loadingBarangays: $loadingBarangays, calculating: $calculating, barangays: $barangays, selectedBarangay: $selectedBarangay, selectedIntensity: $selectedIntensity, result: $result, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CalculateStateCopyWith<$Res> implements $CalculateStateCopyWith<$Res> {
  factory _$CalculateStateCopyWith(_CalculateState value, $Res Function(_CalculateState) _then) = __$CalculateStateCopyWithImpl;
@override @useResult
$Res call({
 bool loadingBarangays, bool calculating, List<String> barangays, String? selectedBarangay, RainfallIntensity? selectedIntensity, LogisticFloodResult? result, String? errorMessage
});




}
/// @nodoc
class __$CalculateStateCopyWithImpl<$Res>
    implements _$CalculateStateCopyWith<$Res> {
  __$CalculateStateCopyWithImpl(this._self, this._then);

  final _CalculateState _self;
  final $Res Function(_CalculateState) _then;

/// Create a copy of CalculateState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingBarangays = null,Object? calculating = null,Object? barangays = null,Object? selectedBarangay = freezed,Object? selectedIntensity = freezed,Object? result = freezed,Object? errorMessage = freezed,}) {
  return _then(_CalculateState(
loadingBarangays: null == loadingBarangays ? _self.loadingBarangays : loadingBarangays // ignore: cast_nullable_to_non_nullable
as bool,calculating: null == calculating ? _self.calculating : calculating // ignore: cast_nullable_to_non_nullable
as bool,barangays: null == barangays ? _self._barangays : barangays // ignore: cast_nullable_to_non_nullable
as List<String>,selectedBarangay: freezed == selectedBarangay ? _self.selectedBarangay : selectedBarangay // ignore: cast_nullable_to_non_nullable
as String?,selectedIntensity: freezed == selectedIntensity ? _self.selectedIntensity : selectedIntensity // ignore: cast_nullable_to_non_nullable
as RainfallIntensity?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as LogisticFloodResult?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
