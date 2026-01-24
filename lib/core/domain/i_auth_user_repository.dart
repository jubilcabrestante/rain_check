import 'package:firebase_auth/firebase_auth.dart';
import 'package:rain_check/core/repository/user_model/user_vm.dart';
import 'package:rain_check/core/utils/typedef.dart';

abstract class IAuthUserRepository {
  Stream<User?> authStream();
  ResultFuture<UserVM> getUserDetails(String userId);
  ResultFuture<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  ResultFuture<User> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  ResultFuture<UserVM> addUserDetails(UserVM user);
  ResultFuture<UserVM> updateUserDetails(UserVM user);

  ResultFuture<UserVM> signInWithGoogle();

  ResultFuture<bool> forgotPassword(String email);
  ResultVoid logout();

  ResultFuture<String?> signInWithPhoneNumber(String phoneNumber);
  ResultFuture<UserCredential> verifyPhoneOTP(
    String verificationId,
    String smsCode,
  );
}
