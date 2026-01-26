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

 bool get loading; String? get location; String? get rainAmount; String? get errorMessage;
/// Create a copy of CalculateState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CalculateStateCopyWith<CalculateState> get copyWith => _$CalculateStateCopyWithImpl<CalculateState>(this as CalculateState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CalculateState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.location, location) || other.location == location)&&(identical(other.rainAmount, rainAmount) || other.rainAmount == rainAmount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loading,location,rainAmount,errorMessage);

@override
String toString() {
  return 'CalculateState(loading: $loading, location: $location, rainAmount: $rainAmount, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CalculateStateCopyWith<$Res>  {
  factory $CalculateStateCopyWith(CalculateState value, $Res Function(CalculateState) _then) = _$CalculateStateCopyWithImpl;
@useResult
$Res call({
 bool loading, String? location, String? rainAmount, String? errorMessage
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
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? location = freezed,Object? rainAmount = freezed,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,rainAmount: freezed == rainAmount ? _self.rainAmount : rainAmount // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Initial value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Initial value)  $default,){
final _that = this;
switch (_that) {
case _Initial():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Initial value)?  $default,){
final _that = this;
switch (_that) {
case _Initial() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  String? location,  String? rainAmount,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when $default != null:
return $default(_that.loading,_that.location,_that.rainAmount,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  String? location,  String? rainAmount,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _Initial():
return $default(_that.loading,_that.location,_that.rainAmount,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  String? location,  String? rainAmount,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _Initial() when $default != null:
return $default(_that.loading,_that.location,_that.rainAmount,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CalculateState {
  const _Initial({this.loading = false, this.location, this.rainAmount, this.errorMessage});
  

@override@JsonKey() final  bool loading;
@override final  String? location;
@override final  String? rainAmount;
@override final  String? errorMessage;

/// Create a copy of CalculateState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.location, location) || other.location == location)&&(identical(other.rainAmount, rainAmount) || other.rainAmount == rainAmount)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,loading,location,rainAmount,errorMessage);

@override
String toString() {
  return 'CalculateState(loading: $loading, location: $location, rainAmount: $rainAmount, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $CalculateStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 bool loading, String? location, String? rainAmount, String? errorMessage
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of CalculateState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? location = freezed,Object? rainAmount = freezed,Object? errorMessage = freezed,}) {
  return _then(_Initial(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as String?,rainAmount: freezed == rainAmount ? _self.rainAmount : rainAmount // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
