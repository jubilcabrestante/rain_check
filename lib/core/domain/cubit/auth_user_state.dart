part of 'auth_user_cubit.dart';

/// Authentication status enum
enum AuthStatus {
  initial,
  loading,
  authenticated,
  googleSignInLoading,
  unauthenticated,
  error,
  googleError,
  successRegistration,
  passwordResetSent,
}

@freezed
abstract class AuthUserState with _$AuthUserState {
  const factory AuthUserState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserVM? currentUser,
    UserVM? user,
    String? message,
    String? verificationId,
  }) = _AuthUserState;
}
