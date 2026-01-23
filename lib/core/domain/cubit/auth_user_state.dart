part of 'auth_user_cubit.dart';

/// Authentication status enum
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  success,
  passwordResetSent,
}

@freezed
abstract class AuthUserState with _$AuthUserState {
  const factory AuthUserState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserVM? currentUser,
    String? message,
    String? verificationId,
  }) = _AuthUserState;
}
