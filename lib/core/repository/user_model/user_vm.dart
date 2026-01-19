import 'package:json_annotation/json_annotation.dart';

part 'user_vm.g.dart';

@JsonSerializable()
class UserVM {
  final String id;
  final String fullName;
  final String? profilePictureUrl;
  final String? email;
  final String? phoneNumber;

  UserVM({
    required this.id,
    required this.fullName,
    this.profilePictureUrl,
    this.email,
    this.phoneNumber,
  });

  factory UserVM.fromJson(Map<String, dynamic> json) => _$UserVMFromJson(json);

  Map<String, dynamic> toJson() => _$UserVMToJson(this);
}
