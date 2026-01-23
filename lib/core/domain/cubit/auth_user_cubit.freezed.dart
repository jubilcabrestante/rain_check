// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_user_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthUserState {

 AuthStatus get status; UserVM? get currentUser; String? get message; String? get verificationId;
/// Create a copy of AuthUserState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthUserStateCopyWith<AuthUserState> get copyWith => _$AuthUserStateCopyWithImpl<AuthUserState>(this as AuthUserState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthUserState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.message, message) || other.message == message)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentUser,message,verificationId);

@override
String toString() {
  return 'AuthUserState(status: $status, currentUser: $currentUser, message: $message, verificationId: $verificationId)';
}


}

/// @nodoc
abstract mixin class $AuthUserStateCopyWith<$Res>  {
  factory $AuthUserStateCopyWith(AuthUserState value, $Res Function(AuthUserState) _then) = _$AuthUserStateCopyWithImpl;
@useResult
$Res call({
 AuthStatus status, UserVM? currentUser, String? message, String? verificationId
});




}
/// @nodoc
class _$AuthUserStateCopyWithImpl<$Res>
    implements $AuthUserStateCopyWith<$Res> {
  _$AuthUserStateCopyWithImpl(this._self, this._then);

  final AuthUserState _self;
  final $Res Function(AuthUserState) _then;

/// Create a copy of AuthUserState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? currentUser = freezed,Object? message = freezed,Object? verificationId = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as UserVM?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,verificationId: freezed == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthUserState].
extension AuthUserStatePatterns on AuthUserState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthUserState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthUserState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthUserState value)  $default,){
final _that = this;
switch (_that) {
case _AuthUserState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthUserState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthUserState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AuthStatus status,  UserVM? currentUser,  String? message,  String? verificationId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthUserState() when $default != null:
return $default(_that.status,_that.currentUser,_that.message,_that.verificationId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AuthStatus status,  UserVM? currentUser,  String? message,  String? verificationId)  $default,) {final _that = this;
switch (_that) {
case _AuthUserState():
return $default(_that.status,_that.currentUser,_that.message,_that.verificationId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AuthStatus status,  UserVM? currentUser,  String? message,  String? verificationId)?  $default,) {final _that = this;
switch (_that) {
case _AuthUserState() when $default != null:
return $default(_that.status,_that.currentUser,_that.message,_that.verificationId);case _:
  return null;

}
}

}

/// @nodoc


class _AuthUserState implements AuthUserState {
  const _AuthUserState({this.status = AuthStatus.initial, this.currentUser, this.message, this.verificationId});
  

@override@JsonKey() final  AuthStatus status;
@override final  UserVM? currentUser;
@override final  String? message;
@override final  String? verificationId;

/// Create a copy of AuthUserState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthUserStateCopyWith<_AuthUserState> get copyWith => __$AuthUserStateCopyWithImpl<_AuthUserState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthUserState&&(identical(other.status, status) || other.status == status)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser)&&(identical(other.message, message) || other.message == message)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId));
}


@override
int get hashCode => Object.hash(runtimeType,status,currentUser,message,verificationId);

@override
String toString() {
  return 'AuthUserState(status: $status, currentUser: $currentUser, message: $message, verificationId: $verificationId)';
}


}

/// @nodoc
abstract mixin class _$AuthUserStateCopyWith<$Res> implements $AuthUserStateCopyWith<$Res> {
  factory _$AuthUserStateCopyWith(_AuthUserState value, $Res Function(_AuthUserState) _then) = __$AuthUserStateCopyWithImpl;
@override @useResult
$Res call({
 AuthStatus status, UserVM? currentUser, String? message, String? verificationId
});




}
/// @nodoc
class __$AuthUserStateCopyWithImpl<$Res>
    implements _$AuthUserStateCopyWith<$Res> {
  __$AuthUserStateCopyWithImpl(this._self, this._then);

  final _AuthUserState _self;
  final $Res Function(_AuthUserState) _then;

/// Create a copy of AuthUserState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? currentUser = freezed,Object? message = freezed,Object? verificationId = freezed,}) {
  return _then(_AuthUserState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthStatus,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as UserVM?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,verificationId: freezed == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
