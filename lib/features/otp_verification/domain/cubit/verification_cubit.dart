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
  Future<void> sendOTP(String phone) async {
    emit(
      state.copyWith(status: VerificationStatus.loading, errorMessage: null),
    );

    final result = await iAuthUserRepository.sendOTP(phone);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: VerificationStatus.error,
          errorMessage: failure.errorMesage ?? 'Failed to send OTP',
        ),
      ),
      (verificationId) {
        if (verificationId != null) {
          emit(
            state.copyWith(
              status: VerificationStatus.otpSent,
              verificationId: verificationId,
              errorMessage: null,
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: VerificationStatus.phoneLinked,
              errorMessage: null,
            ),
          );
        }
      },
    );
  }

  /// Verify the entered OTP code and check if user exists
  Future<void> verifyOTP(String otpCode) async {
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

    // Step 1: Verify the OTP
    final verifyResult = await iAuthUserRepository.verifyOTP(
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
      (_) async {
        // Step 2: Check if user exists in Firestore
        final authUser = await iAuthUserRepository.authStream().first;
        final currentUserId = authUser?.uid;

        if (currentUserId == null) {
          emit(
            state.copyWith(
              status: VerificationStatus.error,
              errorMessage: 'Authentication failed. Please try again.',
            ),
          );
          return;
        }

        final userResult = await iAuthUserRepository.getUserDetails(
          currentUserId,
        );

        userResult.fold(
          // User not found - need to create profile
          (failure) => emit(
            state.copyWith(
              status: VerificationStatus.verifiedNewUser,
              userExists: false,
              errorMessage: null,
            ),
          ),
          // User exists - can proceed to app
          (user) => emit(
            state.copyWith(
              status: VerificationStatus.verifiedExistingUser,
              userExists: true,
              currentUser: user,
              errorMessage: null,
            ),
          ),
        );
      },
    );
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
