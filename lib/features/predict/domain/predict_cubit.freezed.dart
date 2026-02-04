// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'predict_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PredictState {

// ✅ used by loadData()
 bool get loading;// ✅ used by predict()
 bool get predicting;// ✅ shared error channel
 String? get errorMessage;// ✅ used by UI + predict()
 DateTimeRange? get selectedRange;// ✅ used after loading boundaries
 BarangayBoundariesCollection? get boundaries;// ✅ used for dropdown list
 List<String> get barangayOptions;// ✅ used for selection validation
 String get selectedBarangay;// ✅ used by map coloring / results
 Map<String, BarangayFloodRisk> get riskMap;
/// Create a copy of PredictState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PredictStateCopyWith<PredictState> get copyWith => _$PredictStateCopyWithImpl<PredictState>(this as PredictState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PredictState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.predicting, predicting) || other.predicting == predicting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange)&&(identical(other.boundaries, boundaries) || other.boundaries == boundaries)&&const DeepCollectionEquality().equals(other.barangayOptions, barangayOptions)&&(identical(other.selectedBarangay, selectedBarangay) || other.selectedBarangay == selectedBarangay)&&const DeepCollectionEquality().equals(other.riskMap, riskMap));
}


@override
int get hashCode => Object.hash(runtimeType,loading,predicting,errorMessage,selectedRange,boundaries,const DeepCollectionEquality().hash(barangayOptions),selectedBarangay,const DeepCollectionEquality().hash(riskMap));

@override
String toString() {
  return 'PredictState(loading: $loading, predicting: $predicting, errorMessage: $errorMessage, selectedRange: $selectedRange, boundaries: $boundaries, barangayOptions: $barangayOptions, selectedBarangay: $selectedBarangay, riskMap: $riskMap)';
}


}

/// @nodoc
abstract mixin class $PredictStateCopyWith<$Res>  {
  factory $PredictStateCopyWith(PredictState value, $Res Function(PredictState) _then) = _$PredictStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool predicting, String? errorMessage, DateTimeRange? selectedRange, BarangayBoundariesCollection? boundaries, List<String> barangayOptions, String selectedBarangay, Map<String, BarangayFloodRisk> riskMap
});




}
/// @nodoc
class _$PredictStateCopyWithImpl<$Res>
    implements $PredictStateCopyWith<$Res> {
  _$PredictStateCopyWithImpl(this._self, this._then);

  final PredictState _self;
  final $Res Function(PredictState) _then;

/// Create a copy of PredictState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? predicting = null,Object? errorMessage = freezed,Object? selectedRange = freezed,Object? boundaries = freezed,Object? barangayOptions = null,Object? selectedBarangay = null,Object? riskMap = null,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,predicting: null == predicting ? _self.predicting : predicting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedRange: freezed == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as DateTimeRange?,boundaries: freezed == boundaries ? _self.boundaries : boundaries // ignore: cast_nullable_to_non_nullable
as BarangayBoundariesCollection?,barangayOptions: null == barangayOptions ? _self.barangayOptions : barangayOptions // ignore: cast_nullable_to_non_nullable
as List<String>,selectedBarangay: null == selectedBarangay ? _self.selectedBarangay : selectedBarangay // ignore: cast_nullable_to_non_nullable
as String,riskMap: null == riskMap ? _self.riskMap : riskMap // ignore: cast_nullable_to_non_nullable
as Map<String, BarangayFloodRisk>,
  ));
}

}


/// Adds pattern-matching-related methods to [PredictState].
extension PredictStatePatterns on PredictState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PredictState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PredictState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PredictState value)  $default,){
final _that = this;
switch (_that) {
case _PredictState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PredictState value)?  $default,){
final _that = this;
switch (_that) {
case _PredictState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool predicting,  String? errorMessage,  DateTimeRange? selectedRange,  BarangayBoundariesCollection? boundaries,  List<String> barangayOptions,  String selectedBarangay,  Map<String, BarangayFloodRisk> riskMap)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PredictState() when $default != null:
return $default(_that.loading,_that.predicting,_that.errorMessage,_that.selectedRange,_that.boundaries,_that.barangayOptions,_that.selectedBarangay,_that.riskMap);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool predicting,  String? errorMessage,  DateTimeRange? selectedRange,  BarangayBoundariesCollection? boundaries,  List<String> barangayOptions,  String selectedBarangay,  Map<String, BarangayFloodRisk> riskMap)  $default,) {final _that = this;
switch (_that) {
case _PredictState():
return $default(_that.loading,_that.predicting,_that.errorMessage,_that.selectedRange,_that.boundaries,_that.barangayOptions,_that.selectedBarangay,_that.riskMap);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool predicting,  String? errorMessage,  DateTimeRange? selectedRange,  BarangayBoundariesCollection? boundaries,  List<String> barangayOptions,  String selectedBarangay,  Map<String, BarangayFloodRisk> riskMap)?  $default,) {final _that = this;
switch (_that) {
case _PredictState() when $default != null:
return $default(_that.loading,_that.predicting,_that.errorMessage,_that.selectedRange,_that.boundaries,_that.barangayOptions,_that.selectedBarangay,_that.riskMap);case _:
  return null;

}
}

}

/// @nodoc


class _PredictState implements PredictState {
  const _PredictState({this.loading = false, this.predicting = false, this.errorMessage, this.selectedRange, this.boundaries, final  List<String> barangayOptions = const <String>[], this.selectedBarangay = '', final  Map<String, BarangayFloodRisk> riskMap = const <String, BarangayFloodRisk>{}}): _barangayOptions = barangayOptions,_riskMap = riskMap;
  

// ✅ used by loadData()
@override@JsonKey() final  bool loading;
// ✅ used by predict()
@override@JsonKey() final  bool predicting;
// ✅ shared error channel
@override final  String? errorMessage;
// ✅ used by UI + predict()
@override final  DateTimeRange? selectedRange;
// ✅ used after loading boundaries
@override final  BarangayBoundariesCollection? boundaries;
// ✅ used for dropdown list
 final  List<String> _barangayOptions;
// ✅ used for dropdown list
@override@JsonKey() List<String> get barangayOptions {
  if (_barangayOptions is EqualUnmodifiableListView) return _barangayOptions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_barangayOptions);
}

// ✅ used for selection validation
@override@JsonKey() final  String selectedBarangay;
// ✅ used by map coloring / results
 final  Map<String, BarangayFloodRisk> _riskMap;
// ✅ used by map coloring / results
@override@JsonKey() Map<String, BarangayFloodRisk> get riskMap {
  if (_riskMap is EqualUnmodifiableMapView) return _riskMap;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_riskMap);
}


/// Create a copy of PredictState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PredictStateCopyWith<_PredictState> get copyWith => __$PredictStateCopyWithImpl<_PredictState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PredictState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.predicting, predicting) || other.predicting == predicting)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.selectedRange, selectedRange) || other.selectedRange == selectedRange)&&(identical(other.boundaries, boundaries) || other.boundaries == boundaries)&&const DeepCollectionEquality().equals(other._barangayOptions, _barangayOptions)&&(identical(other.selectedBarangay, selectedBarangay) || other.selectedBarangay == selectedBarangay)&&const DeepCollectionEquality().equals(other._riskMap, _riskMap));
}


@override
int get hashCode => Object.hash(runtimeType,loading,predicting,errorMessage,selectedRange,boundaries,const DeepCollectionEquality().hash(_barangayOptions),selectedBarangay,const DeepCollectionEquality().hash(_riskMap));

@override
String toString() {
  return 'PredictState(loading: $loading, predicting: $predicting, errorMessage: $errorMessage, selectedRange: $selectedRange, boundaries: $boundaries, barangayOptions: $barangayOptions, selectedBarangay: $selectedBarangay, riskMap: $riskMap)';
}


}

/// @nodoc
abstract mixin class _$PredictStateCopyWith<$Res> implements $PredictStateCopyWith<$Res> {
  factory _$PredictStateCopyWith(_PredictState value, $Res Function(_PredictState) _then) = __$PredictStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool predicting, String? errorMessage, DateTimeRange? selectedRange, BarangayBoundariesCollection? boundaries, List<String> barangayOptions, String selectedBarangay, Map<String, BarangayFloodRisk> riskMap
});




}
/// @nodoc
class __$PredictStateCopyWithImpl<$Res>
    implements _$PredictStateCopyWith<$Res> {
  __$PredictStateCopyWithImpl(this._self, this._then);

  final _PredictState _self;
  final $Res Function(_PredictState) _then;

/// Create a copy of PredictState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? predicting = null,Object? errorMessage = freezed,Object? selectedRange = freezed,Object? boundaries = freezed,Object? barangayOptions = null,Object? selectedBarangay = null,Object? riskMap = null,}) {
  return _then(_PredictState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,predicting: null == predicting ? _self.predicting : predicting // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,selectedRange: freezed == selectedRange ? _self.selectedRange : selectedRange // ignore: cast_nullable_to_non_nullable
as DateTimeRange?,boundaries: freezed == boundaries ? _self.boundaries : boundaries // ignore: cast_nullable_to_non_nullable
as BarangayBoundariesCollection?,barangayOptions: null == barangayOptions ? _self._barangayOptions : barangayOptions // ignore: cast_nullable_to_non_nullable
as List<String>,selectedBarangay: null == selectedBarangay ? _self.selectedBarangay : selectedBarangay // ignore: cast_nullable_to_non_nullable
as String,riskMap: null == riskMap ? _self._riskMap : riskMap // ignore: cast_nullable_to_non_nullable
as Map<String, BarangayFloodRisk>,
  ));
}


}

// dart format on
