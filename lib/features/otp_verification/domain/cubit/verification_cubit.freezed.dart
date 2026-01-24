// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VerificationState {

 VerificationStatus get status; String? get verificationId; String? get phoneNumber;// ✅ Store phone number
 String? get errorMessage; bool get userExists; UserVM? get currentUser;
/// Create a copy of VerificationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationStateCopyWith<VerificationState> get copyWith => _$VerificationStateCopyWithImpl<VerificationState>(this as VerificationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VerificationState&&(identical(other.status, status) || other.status == status)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.userExists, userExists) || other.userExists == userExists)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser));
}


@override
int get hashCode => Object.hash(runtimeType,status,verificationId,phoneNumber,errorMessage,userExists,currentUser);

@override
String toString() {
  return 'VerificationState(status: $status, verificationId: $verificationId, phoneNumber: $phoneNumber, errorMessage: $errorMessage, userExists: $userExists, currentUser: $currentUser)';
}


}

/// @nodoc
abstract mixin class $VerificationStateCopyWith<$Res>  {
  factory $VerificationStateCopyWith(VerificationState value, $Res Function(VerificationState) _then) = _$VerificationStateCopyWithImpl;
@useResult
$Res call({
 VerificationStatus status, String? verificationId, String? phoneNumber, String? errorMessage, bool userExists, UserVM? currentUser
});


$UserVMCopyWith<$Res>? get currentUser;

}
/// @nodoc
class _$VerificationStateCopyWithImpl<$Res>
    implements $VerificationStateCopyWith<$Res> {
  _$VerificationStateCopyWithImpl(this._self, this._then);

  final VerificationState _self;
  final $Res Function(VerificationState) _then;

/// Create a copy of VerificationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? verificationId = freezed,Object? phoneNumber = freezed,Object? errorMessage = freezed,Object? userExists = null,Object? currentUser = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,verificationId: freezed == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,userExists: null == userExists ? _self.userExists : userExists // ignore: cast_nullable_to_non_nullable
as bool,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as UserVM?,
  ));
}
/// Create a copy of VerificationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserVMCopyWith<$Res>? get currentUser {
    if (_self.currentUser == null) {
    return null;
  }

  return $UserVMCopyWith<$Res>(_self.currentUser!, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}
}


/// Adds pattern-matching-related methods to [VerificationState].
extension VerificationStatePatterns on VerificationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VerificationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VerificationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VerificationState value)  $default,){
final _that = this;
switch (_that) {
case _VerificationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VerificationState value)?  $default,){
final _that = this;
switch (_that) {
case _VerificationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VerificationStatus status,  String? verificationId,  String? phoneNumber,  String? errorMessage,  bool userExists,  UserVM? currentUser)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VerificationState() when $default != null:
return $default(_that.status,_that.verificationId,_that.phoneNumber,_that.errorMessage,_that.userExists,_that.currentUser);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VerificationStatus status,  String? verificationId,  String? phoneNumber,  String? errorMessage,  bool userExists,  UserVM? currentUser)  $default,) {final _that = this;
switch (_that) {
case _VerificationState():
return $default(_that.status,_that.verificationId,_that.phoneNumber,_that.errorMessage,_that.userExists,_that.currentUser);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VerificationStatus status,  String? verificationId,  String? phoneNumber,  String? errorMessage,  bool userExists,  UserVM? currentUser)?  $default,) {final _that = this;
switch (_that) {
case _VerificationState() when $default != null:
return $default(_that.status,_that.verificationId,_that.phoneNumber,_that.errorMessage,_that.userExists,_that.currentUser);case _:
  return null;

}
}

}

/// @nodoc


class _VerificationState implements VerificationState {
  const _VerificationState({this.status = VerificationStatus.idle, this.verificationId, this.phoneNumber, this.errorMessage, this.userExists = false, this.currentUser});
  

@override@JsonKey() final  VerificationStatus status;
@override final  String? verificationId;
@override final  String? phoneNumber;
// ✅ Store phone number
@override final  String? errorMessage;
@override@JsonKey() final  bool userExists;
@override final  UserVM? currentUser;

/// Create a copy of VerificationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationStateCopyWith<_VerificationState> get copyWith => __$VerificationStateCopyWithImpl<_VerificationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VerificationState&&(identical(other.status, status) || other.status == status)&&(identical(other.verificationId, verificationId) || other.verificationId == verificationId)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.userExists, userExists) || other.userExists == userExists)&&(identical(other.currentUser, currentUser) || other.currentUser == currentUser));
}


@override
int get hashCode => Object.hash(runtimeType,status,verificationId,phoneNumber,errorMessage,userExists,currentUser);

@override
String toString() {
  return 'VerificationState(status: $status, verificationId: $verificationId, phoneNumber: $phoneNumber, errorMessage: $errorMessage, userExists: $userExists, currentUser: $currentUser)';
}


}

/// @nodoc
abstract mixin class _$VerificationStateCopyWith<$Res> implements $VerificationStateCopyWith<$Res> {
  factory _$VerificationStateCopyWith(_VerificationState value, $Res Function(_VerificationState) _then) = __$VerificationStateCopyWithImpl;
@override @useResult
$Res call({
 VerificationStatus status, String? verificationId, String? phoneNumber, String? errorMessage, bool userExists, UserVM? currentUser
});


@override $UserVMCopyWith<$Res>? get currentUser;

}
/// @nodoc
class __$VerificationStateCopyWithImpl<$Res>
    implements _$VerificationStateCopyWith<$Res> {
  __$VerificationStateCopyWithImpl(this._self, this._then);

  final _VerificationState _self;
  final $Res Function(_VerificationState) _then;

/// Create a copy of VerificationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? verificationId = freezed,Object? phoneNumber = freezed,Object? errorMessage = freezed,Object? userExists = null,Object? currentUser = freezed,}) {
  return _then(_VerificationState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,verificationId: freezed == verificationId ? _self.verificationId : verificationId // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,userExists: null == userExists ? _self.userExists : userExists // ignore: cast_nullable_to_non_nullable
as bool,currentUser: freezed == currentUser ? _self.currentUser : currentUser // ignore: cast_nullable_to_non_nullable
as UserVM?,
  ));
}

/// Create a copy of VerificationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserVMCopyWith<$Res>? get currentUser {
    if (_self.currentUser == null) {
    return null;
  }

  return $UserVMCopyWith<$Res>(_self.currentUser!, (value) {
    return _then(_self.copyWith(currentUser: value));
  });
}
}

// dart format on
