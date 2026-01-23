part of 'verification_cubit.dart';

/// Status of the verification process
enum VerificationStatus {
  idle,
  loading,
  otpSent,
  verifying,
  verified,
  phoneLinked,
  error,
}

@freezed
abstract class VerificationState with _$VerificationState {
  const factory VerificationState({
    @Default(VerificationStatus.idle) VerificationStatus status,
    String? verificationId,
    String? errorMessage,
  }) = _VerificationState;
}
