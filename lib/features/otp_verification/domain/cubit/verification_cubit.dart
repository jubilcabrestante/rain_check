import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rain_check/core/domain/cubit/auth_user_cubit.dart';
import 'package:rain_check/core/domain/i_auth_user_repository.dart';
import 'package:rain_check/core/repository/user_model/user_vm.dart';

part 'verification_state.dart';
part 'verification_cubit.freezed.dart';

/// Handles OTP verification logic
class VerificationCubit extends Cubit<VerificationState> {
  final IAuthUserRepository iAuthUserRepository;
  final AuthUserCubit authUserCubit;

  VerificationCubit({
    required this.iAuthUserRepository,
    required this.authUserCubit,
  }) : super(const VerificationState());

  /// Send OTP to phone number
  Future<void> sendOTPForSignIn(String phoneNumber) async {
    emit(
      state.copyWith(
        status: VerificationStatus.loading,
        errorMessage: null,
        phoneNumber: phoneNumber,
      ),
    );

    final result = await iAuthUserRepository.signInWithPhoneNumber(phoneNumber);

    result.fold(
      (error) async {
        emit(
          state.copyWith(
            status: VerificationStatus.error,
            errorMessage: error.errorMesage ?? 'Failed to send OTP',
          ),
        );
      },
      (verficationId) {
        emit(
          state.copyWith(
            status: VerificationStatus.otpSent,
            verificationId: verficationId,
            phoneNumber: phoneNumber,
            errorMessage: null,
          ),
        );
      },
    );
  }

  /// Verify OTP for phone sign-in
  Future<void> verifyPhoneSignInOTP(String otpCode) async {
    if (otpCode.length != 6) {
      emit(
        state.copyWith(
          status: VerificationStatus.error,
          errorMessage: 'Please enter a valid 6-digit code',
        ),
      );
      return;
    }

    final verificationId = state.verificationId;
    if (verificationId == null) {
      emit(
        state.copyWith(
          status: VerificationStatus.error,
          errorMessage: 'Verification ID not found. Please resend OTP.',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: VerificationStatus.verifying, errorMessage: null),
    );

    final verifyResult = await iAuthUserRepository.verifyPhoneOTP(
      verificationId,
      otpCode,
    );

    await verifyResult.fold(
      (failure) async {
        emit(
          state.copyWith(
            status: VerificationStatus.error,
            errorMessage: failure.errorMesage ?? 'Invalid OTP code',
          ),
        );
      },
      (userCredential) async {
        final firebaseUser = userCredential.user!;

        // Check if user document exists
        final userResult = await iAuthUserRepository.getUserDetails(
          firebaseUser.uid,
        );

        userResult.fold(
          // User not found - need to create profile
          (failure) {
            emit(
              state.copyWith(
                status: VerificationStatus.verifiedNewUser,
                userExists: false,
                errorMessage: null,
              ),
            );
          },
          // User exists - can proceed to app
          (user) {
            emit(
              state.copyWith(
                status: VerificationStatus.verifiedExistingUser,
                userExists: true,
                currentUser: user,
                errorMessage: null,
              ),
            );
          },
        );
      },
    );
  }

  /// Create new user profile after phone verification
  Future<void> createUserProfile({required String fullName}) async {
    emit(state.copyWith(status: VerificationStatus.loading));

    try {
      final authUser = await iAuthUserRepository.authStream().first;
      final currentUserId = authUser?.uid;

      if (currentUserId == null) {
        emit(
          state.copyWith(
            status: VerificationStatus.error,
            errorMessage: 'User not authenticated',
          ),
        );
        return;
      }

      // Create new user document
      final newUser = UserVM(
        id: currentUserId,
        fullName: fullName,
        phoneNumber: state.phoneNumber,
        email: authUser?.email,
      );

      final result = await iAuthUserRepository.addUserDetails(newUser);

      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: VerificationStatus.error,
              errorMessage: failure.errorMesage ?? 'Failed to create profile',
            ),
          );
        },
        (user) async {
          // Updates the authenticated user
          await authUserCubit.setAuthenticatedUser(user);

          emit(
            state.copyWith(
              status: VerificationStatus.profileCreated,
              currentUser: user,
              errorMessage: null,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: VerificationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Clear any error messages
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  /// Reset state
  void reset() {
    emit(const VerificationState());
  }
}
