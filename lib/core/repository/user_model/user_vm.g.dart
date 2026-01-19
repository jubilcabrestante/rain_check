// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserVM _$UserVMFromJson(Map<String, dynamic> json) => UserVM(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  profilePictureUrl: json['profilePictureUrl'] as String?,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
);

Map<String, dynamic> _$UserVMToJson(UserVM instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'profilePictureUrl': instance.profilePictureUrl,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
};
