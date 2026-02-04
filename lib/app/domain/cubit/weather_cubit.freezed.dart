// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weather_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeatherHeaderState {

 bool get loading; bool get loadingWeather; List<BarangayLocation> get barangays; BarangayLocation? get selectedBarangay; WeatherSnapshot? get weather; String? get errorMessage;
/// Create a copy of WeatherHeaderState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeatherHeaderStateCopyWith<WeatherHeaderState> get copyWith => _$WeatherHeaderStateCopyWithImpl<WeatherHeaderState>(this as WeatherHeaderState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeatherHeaderState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingWeather, loadingWeather) || other.loadingWeather == loadingWeather)&&const DeepCollectionEquality().equals(other.barangays, barangays)&&(identical(other.selectedBarangay, selectedBarangay) || other.selectedBarangay == selectedBarangay)&&(identical(other.weather, weather) || other.weather == weather)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loading,loadingWeather,const DeepCollectionEquality().hash(barangays),selectedBarangay,weather,errorMessage);

@override
String toString() {
  return 'WeatherHeaderState(loading: $loading, loadingWeather: $loadingWeather, barangays: $barangays, selectedBarangay: $selectedBarangay, weather: $weather, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $WeatherHeaderStateCopyWith<$Res>  {
  factory $WeatherHeaderStateCopyWith(WeatherHeaderState value, $Res Function(WeatherHeaderState) _then) = _$WeatherHeaderStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool loadingWeather, List<BarangayLocation> barangays, BarangayLocation? selectedBarangay, WeatherSnapshot? weather, String? errorMessage
});




}
/// @nodoc
class _$WeatherHeaderStateCopyWithImpl<$Res>
    implements $WeatherHeaderStateCopyWith<$Res> {
  _$WeatherHeaderStateCopyWithImpl(this._self, this._then);

  final WeatherHeaderState _self;
  final $Res Function(WeatherHeaderState) _then;

/// Create a copy of WeatherHeaderState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? loadingWeather = null,Object? barangays = null,Object? selectedBarangay = freezed,Object? weather = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingWeather: null == loadingWeather ? _self.loadingWeather : loadingWeather // ignore: cast_nullable_to_non_nullable
as bool,barangays: null == barangays ? _self.barangays : barangays // ignore: cast_nullable_to_non_nullable
as List<BarangayLocation>,selectedBarangay: freezed == selectedBarangay ? _self.selectedBarangay : selectedBarangay // ignore: cast_nullable_to_non_nullable
as BarangayLocation?,weather: freezed == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as WeatherSnapshot?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WeatherHeaderState].
extension WeatherHeaderStatePatterns on WeatherHeaderState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeatherHeaderState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeatherHeaderState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeatherHeaderState value)  $default,){
final _that = this;
switch (_that) {
case _WeatherHeaderState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeatherHeaderState value)?  $default,){
final _that = this;
switch (_that) {
case _WeatherHeaderState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool loadingWeather,  List<BarangayLocation> barangays,  BarangayLocation? selectedBarangay,  WeatherSnapshot? weather,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeatherHeaderState() when $default != null:
return $default(_that.loading,_that.loadingWeather,_that.barangays,_that.selectedBarangay,_that.weather,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool loadingWeather,  List<BarangayLocation> barangays,  BarangayLocation? selectedBarangay,  WeatherSnapshot? weather,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _WeatherHeaderState():
return $default(_that.loading,_that.loadingWeather,_that.barangays,_that.selectedBarangay,_that.weather,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool loadingWeather,  List<BarangayLocation> barangays,  BarangayLocation? selectedBarangay,  WeatherSnapshot? weather,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _WeatherHeaderState() when $default != null:
return $default(_that.loading,_that.loadingWeather,_that.barangays,_that.selectedBarangay,_that.weather,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _WeatherHeaderState implements WeatherHeaderState {
  const _WeatherHeaderState({this.loading = false, this.loadingWeather = false, final  List<BarangayLocation> barangays = const <BarangayLocation>[], this.selectedBarangay, this.weather, this.errorMessage}): _barangays = barangays;
  

@override@JsonKey() final  bool loading;
@override@JsonKey() final  bool loadingWeather;
 final  List<BarangayLocation> _barangays;
@override@JsonKey() List<BarangayLocation> get barangays {
  if (_barangays is EqualUnmodifiableListView) return _barangays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_barangays);
}

@override final  BarangayLocation? selectedBarangay;
@override final  WeatherSnapshot? weather;
@override final  String? errorMessage;

/// Create a copy of WeatherHeaderState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeatherHeaderStateCopyWith<_WeatherHeaderState> get copyWith => __$WeatherHeaderStateCopyWithImpl<_WeatherHeaderState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeatherHeaderState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.loadingWeather, loadingWeather) || other.loadingWeather == loadingWeather)&&const DeepCollectionEquality().equals(other._barangays, _barangays)&&(identical(other.selectedBarangay, selectedBarangay) || other.selectedBarangay == selectedBarangay)&&(identical(other.weather, weather) || other.weather == weather)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loading,loadingWeather,const DeepCollectionEquality().hash(_barangays),selectedBarangay,weather,errorMessage);

@override
String toString() {
  return 'WeatherHeaderState(loading: $loading, loadingWeather: $loadingWeather, barangays: $barangays, selectedBarangay: $selectedBarangay, weather: $weather, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$WeatherHeaderStateCopyWith<$Res> implements $WeatherHeaderStateCopyWith<$Res> {
  factory _$WeatherHeaderStateCopyWith(_WeatherHeaderState value, $Res Function(_WeatherHeaderState) _then) = __$WeatherHeaderStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool loadingWeather, List<BarangayLocation> barangays, BarangayLocation? selectedBarangay, WeatherSnapshot? weather, String? errorMessage
});




}
/// @nodoc
class __$WeatherHeaderStateCopyWithImpl<$Res>
    implements _$WeatherHeaderStateCopyWith<$Res> {
  __$WeatherHeaderStateCopyWithImpl(this._self, this._then);

  final _WeatherHeaderState _self;
  final $Res Function(_WeatherHeaderState) _then;

/// Create a copy of WeatherHeaderState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? loadingWeather = null,Object? barangays = null,Object? selectedBarangay = freezed,Object? weather = freezed,Object? errorMessage = freezed,}) {
  return _then(_WeatherHeaderState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,loadingWeather: null == loadingWeather ? _self.loadingWeather : loadingWeather // ignore: cast_nullable_to_non_nullable
as bool,barangays: null == barangays ? _self._barangays : barangays // ignore: cast_nullable_to_non_nullable
as List<BarangayLocation>,selectedBarangay: freezed == selectedBarangay ? _self.selectedBarangay : selectedBarangay // ignore: cast_nullable_to_non_nullable
as BarangayLocation?,weather: freezed == weather ? _self.weather : weather // ignore: cast_nullable_to_non_nullable
as WeatherSnapshot?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
