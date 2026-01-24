part of 'verification_cubit.dart';

/// Status of the verification process
enum VerificationStatus {
  idle,
  loading,
  otpSent,
  verifying,
  verifiedNewUser, // User verified but profile doesn't exist
  verifiedExistingUser, // User verified and profile exists
  profileCreated, // ✅ New status after creating profile
  phoneLinked,
  error,
}

@freezed
abstract class VerificationState with _$VerificationState {
  const factory VerificationState({
    @Default(VerificationStatus.idle) VerificationStatus status,
    String? verificationId,
    String? phoneNumber, // ✅ Store phone number
    String? errorMessage,
    @Default(false) bool userExists,
    UserVM? currentUser,
  }) = _VerificationState;
}
