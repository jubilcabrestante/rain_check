// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_vm.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserVM {

 String get id; String get fullName; String? get email; String? get phoneNumber; String? get profilePictureUrl;
/// Create a copy of UserVM
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserVMCopyWith<UserVM> get copyWith => _$UserVMCopyWithImpl<UserVM>(this as UserVM, _$identity);

  /// Serializes this UserVM to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserVM&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,phoneNumber,profilePictureUrl);

@override
String toString() {
  return 'UserVM(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, profilePictureUrl: $profilePictureUrl)';
}


}

/// @nodoc
abstract mixin class $UserVMCopyWith<$Res>  {
  factory $UserVMCopyWith(UserVM value, $Res Function(UserVM) _then) = _$UserVMCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? email, String? phoneNumber, String? profilePictureUrl
});




}
/// @nodoc
class _$UserVMCopyWithImpl<$Res>
    implements $UserVMCopyWith<$Res> {
  _$UserVMCopyWithImpl(this._self, this._then);

  final UserVM _self;
  final $Res Function(UserVM) _then;

/// Create a copy of UserVM
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phoneNumber = freezed,Object? profilePictureUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserVM].
extension UserVMPatterns on UserVM {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserVM value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserVM() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserVM value)  $default,){
final _that = this;
switch (_that) {
case _UserVM():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserVM value)?  $default,){
final _that = this;
switch (_that) {
case _UserVM() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? email,  String? phoneNumber,  String? profilePictureUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserVM() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phoneNumber,_that.profilePictureUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? email,  String? phoneNumber,  String? profilePictureUrl)  $default,) {final _that = this;
switch (_that) {
case _UserVM():
return $default(_that.id,_that.fullName,_that.email,_that.phoneNumber,_that.profilePictureUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? email,  String? phoneNumber,  String? profilePictureUrl)?  $default,) {final _that = this;
switch (_that) {
case _UserVM() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.phoneNumber,_that.profilePictureUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserVM implements UserVM {
  const _UserVM({required this.id, required this.fullName, this.email, this.phoneNumber, this.profilePictureUrl});
  factory _UserVM.fromJson(Map<String, dynamic> json) => _$UserVMFromJson(json);

@override final  String id;
@override final  String fullName;
@override final  String? email;
@override final  String? phoneNumber;
@override final  String? profilePictureUrl;

/// Create a copy of UserVM
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserVMCopyWith<_UserVM> get copyWith => __$UserVMCopyWithImpl<_UserVM>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserVMToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserVM&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.profilePictureUrl, profilePictureUrl) || other.profilePictureUrl == profilePictureUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,phoneNumber,profilePictureUrl);

@override
String toString() {
  return 'UserVM(id: $id, fullName: $fullName, email: $email, phoneNumber: $phoneNumber, profilePictureUrl: $profilePictureUrl)';
}


}

/// @nodoc
abstract mixin class _$UserVMCopyWith<$Res> implements $UserVMCopyWith<$Res> {
  factory _$UserVMCopyWith(_UserVM value, $Res Function(_UserVM) _then) = __$UserVMCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? email, String? phoneNumber, String? profilePictureUrl
});




}
/// @nodoc
class __$UserVMCopyWithImpl<$Res>
    implements _$UserVMCopyWith<$Res> {
  __$UserVMCopyWithImpl(this._self, this._then);

  final _UserVM _self;
  final $Res Function(_UserVM) _then;

/// Create a copy of UserVM
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? phoneNumber = freezed,Object? profilePictureUrl = freezed,}) {
  return _then(_UserVM(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phoneNumber: freezed == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String?,profilePictureUrl: freezed == profilePictureUrl ? _self.profilePictureUrl : profilePictureUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
