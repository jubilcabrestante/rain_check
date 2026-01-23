import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rain_check/core/domain/i_auth_user_repository.dart';
import 'package:rain_check/core/enum/enum_password_type.dart';

part 'verification_state.dart';
part 'verification_cubit.freezed.dart';

/// Handles OTP verification logic
class VerificationCubit extends Cubit<VerificationState> {
  final IAuthUserRepository _repository;
  final String phoneNumber;
  final AuthMode authMode;

  VerificationCubit({
    required IAuthUserRepository repository,
    required this.phoneNumber,
    required this.authMode,
  }) : _repository = repository,
       super(const VerificationState());

  /// Send OTP to phone number
  Future<void> sendOTP(String phoneNumber) async {
    emit(
      state.copyWith(status: VerificationStatus.loading, errorMessage: null),
    );

    final result = await _repository.sendOTP(phoneNumber);

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

  /// Verify the entered OTP code
  Future<void> verifyOTP(String otpCode) async {
    if (otpCode.length != 4) {
      emit(
        state.copyWith(
          status: VerificationStatus.error,
          errorMessage: 'Please enter a valid 4-digit code',
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

    final result = await _repository.verifyOTP(verificationId, otpCode);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: VerificationStatus.error,
          errorMessage: failure.errorMesage ?? 'Invalid OTP code',
        ),
      ),
      (_) {
        emit(
          state.copyWith(
            status: VerificationStatus.verified,
            errorMessage: null,
          ),
        );

        // Emit success event that UI can listen to
        Future.delayed(const Duration(milliseconds: 100), () {
          emit(state.copyWith(status: VerificationStatus.idle));
        });
      },
    );
  }

  /// Resend OTP code
  Future<void> resendOTP() async {
    await sendOTP(phoneNumber);
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
