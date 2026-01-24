import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_vm.freezed.dart';
part 'user_vm.g.dart';

@freezed
abstract class UserVM with _$UserVM {
  const factory UserVM({
    required String id,
    required String fullName,
    String? email,
    String? phoneNumber,
    String? profilePictureUrl,
  }) = _UserVM;

  factory UserVM.fromJson(Map<String, dynamic> json) => _$UserVMFromJson(json);
}
