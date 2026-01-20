import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rain_check/core/domain/i_user_repository.dart';
import 'package:rain_check/core/repository/user_model/user_vm.dart';
import 'package:rain_check/core/utils/error_handler.dart';
import 'package:rain_check/core/utils/typedef.dart';

class AuthUserRepository implements IAuthUserRepository {
  final FirebaseAuth auth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;
  AuthUserRepository({
    required this.auth,
    required this.googleSignIn,
    required this.firestore,
  });

  final CollectionReference usersCollection = FirebaseFirestore.instance
      .collection('users');
  @override
  Stream<User?> authStream() => auth.authStateChanges();

  // get user details
  @override
  ResultFuture<UserVM> getUserDetails(String userId) async {
    try {
      final userDoc = await usersCollection.doc(userId).get();
      if (userDoc.exists) {
        final userData = UserVM.fromJson(
          userDoc.data() as Map<String, dynamic>,
        );
        return Right(userData);
      } else {
        return Left(ApiFailure(errorMesage: "User not found"));
      }
    } catch (e) {
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // login with email and password
  @override
  ResultFuture<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(ApiFailure(errorMesage: e.message));
    } catch (e) {
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // google sign in
  @override
  ResultFuture<UserVM> signInWithGoogle() async {
    try {
      // Sign out first to force account picker
      await googleSignIn.signOut();

      // Check if platform supports authenticate()
      if (!googleSignIn.supportsAuthenticate()) {
        return Left(
          ApiFailure(
            errorMesage: 'Google Sign-In not supported on this platform',
          ),
        );
      }

      // Trigger authentication flow - THIS IS THE v7.x METHOD
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      // Get authentication credentials
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create Firebase credential
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final userCredential = await auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return Left(
          ApiFailure(errorMesage: 'Failed to get user from credential'),
        );
      }

      log("User ID: ${firebaseUser.uid}");

      // Check if user exists in Firestore
      final userDoc = await usersCollection.doc(firebaseUser.uid).get();

      if (userDoc.exists) {
        // Existing user
        final userData = UserVM.fromJson(
          userDoc.data() as Map<String, dynamic>,
        );
        return Right(userData);
      } else {
        // New user - create document
        final newUser = UserVM(
          id: firebaseUser.uid,
          fullName: googleUser.displayName ?? 'User',
          email: googleUser.email,
        );

        await usersCollection.doc(newUser.id).set(newUser.toJson());

        return Right(newUser);
      }
    } on GoogleSignInException catch (e) {
      return Left(
        ApiFailure(errorMesage: e.description ?? 'Google sign-in failed'),
      );
    } on FirebaseAuthException catch (e) {
      log("Firebase Auth Error: ${e.code} - ${e.message}");
      return Left(
        ApiFailure(errorMesage: e.message ?? 'Authentication failed'),
      );
    } catch (e, stackTrace) {
      log("Google Sign-In failed: $e", stackTrace: stackTrace);
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // register
  // for firebase authentication
  @override
  ResultFuture<User> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Right(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      return Left(ApiFailure(errorMesage: e.message));
    } catch (e) {
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // add user details to firestore
  @override
  ResultFuture<UserVM> addUserDetails(UserVM user) async {
    try {
      await usersCollection.doc(user.id).set(user.toJson());
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // update user details
  @override
  ResultFuture<UserVM> updateUserDetails(UserVM user) async {
    try {
      await usersCollection.doc(user.id).update(user.toJson());
      return Right(user);
    } catch (e) {
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // forgot password
  @override
  ResultFuture<bool> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(ApiFailure(errorMesage: e.message));
    } catch (e) {
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // logout
  @override
  ResultVoid logout() async {
    try {
      // sign out from firebase auth
      await auth.signOut();
      // sign out from google
      // await googleSignIn.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ApiFailure(errorMesage: e.toString()));
    }
  }

  // phone number sign in
  // send phone number verification code
  @override
  ResultFuture<String?> sendOTP(String phoneNumber) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return const Left(ApiFailure(errorMesage: "User not authenticated."));
      }

      final firebaseAuthPhoneNumber = currentUser.phoneNumber;
      if (firebaseAuthPhoneNumber != null &&
          firebaseAuthPhoneNumber == phoneNumber) {
        return const Left(
          ApiFailure(
            errorMesage: "This phone number is already linked to your account.",
          ),
        );
      }

      final isUsed = await isPhoneNumberAlreadyInUse(phoneNumber);
      if (isUsed) {
        return const Left(
          ApiFailure(
            errorMesage: "Phone number is already in use by another account.",
          ),
        );
      }

      final completer = Completer<Either<Failure, String?>>();

      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 120),

        verificationCompleted: (credential) async {
          final linkResult = await linkPhoneNumberToUser(credential);

          linkResult.fold(
            (failure) => completer.complete(Left(failure)),
            (_) => completer.complete(const Right(null)),
          );
        },

        verificationFailed: (e) {
          completer.complete(Left(ApiFailure(errorMesage: e.message)));
        },

        codeSent: (verificationId, _) {
          completer.complete(Right(verificationId));
        },

        codeAutoRetrievalTimeout: (verificationId) {
          completer.complete(Right(verificationId));
        },
      );

      return completer.future;
    } catch (e) {
      return const Left(ApiFailure());
    }
  }

  @override
  ResultFuture<bool> verifyOTP(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      await linkPhoneNumberToUser(credential);

      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return const Left(ApiFailure(errorMesage: "User not authenticated"));
      }

      await usersCollection.doc(currentUser.uid).update({
        "phoneNumber": currentUser.phoneNumber,
      });

      log("Phone number updated successfully");
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-verification-code":
          return const Left(
            ApiFailure(errorMesage: "Invalid OTP. Please try again."),
          );

        case "session-expired":
          final currentUser = auth.currentUser;
          if (currentUser?.phoneNumber != null) {
            await sendOTP(currentUser!.phoneNumber!);
          }
          return const Left(
            ApiFailure(
              errorMesage: "OTP session expired. A new code was sent.",
            ),
          );

        case "quota-exceeded":
          return const Left(
            ApiFailure(errorMesage: "Too many attempts. Try again later."),
          );

        default:
          return Left(ApiFailure(errorMesage: e.message));
      }
    } catch (e) {
      log("Error verifying OTP: $e");
      return const Left(ApiFailure());
    }
  }

  // link phone number to user
  ResultVoid linkPhoneNumberToUser(PhoneAuthCredential credential) async {
    try {
      final currentUser = auth.currentUser;
      if (currentUser == null) {
        return const Left(
          ApiFailure(errorMesage: "No user is currently signed in."),
        );
      }

      await currentUser.linkWithCredential(credential);

      log("Phone number linked successfully to user: ${currentUser.uid}");
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'provider-already-linked') {
        log("Phone number is already linked to this account.");
        return const Right(null);
      }

      return Left(ApiFailure(errorMesage: e.message));
    } catch (e) {
      log("Failed to link phone number: $e");
      return const Left(ApiFailure());
    }
  }

  Future<bool> isPhoneNumberAlreadyInUse(String phoneNumber) async {
    try {
      final querySnapshot = await usersCollection
          .where("phoneNumber", isEqualTo: phoneNumber)
          .get();
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception("Failed to check phone number: $e");
    }
  }
}
