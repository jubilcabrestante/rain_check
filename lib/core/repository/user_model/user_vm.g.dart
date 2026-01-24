// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_vm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserVM _$UserVMFromJson(Map<String, dynamic> json) => _UserVM(
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  email: json['email'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  profilePictureUrl: json['profilePictureUrl'] as String?,
);

Map<String, dynamic> _$UserVMToJson(_UserVM instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'profilePictureUrl': instance.profilePictureUrl,
};
