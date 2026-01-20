import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rain_check/core/repository/user_model/user_vm.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  otpVerified,
  phoneLinked,
  passwordResetSent,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? firebaseUser;
  final UserVM? user;
  final String? verificationId;
  final String? message;

  const AuthState({
    required this.status,
    this.firebaseUser,
    this.user,
    this.verificationId,
    this.message,
  });

  const AuthState.initial() : this(status: AuthStatus.initial);

  AuthState copyWith({
    AuthStatus? status,
    User? firebaseUser,
    UserVM? user,
    String? verificationId,
    String? message,
  }) {
    return AuthState(
      status: status ?? this.status,
      firebaseUser: firebaseUser ?? this.firebaseUser,
      user: user ?? this.user,
      verificationId: verificationId ?? this.verificationId,
      message: message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    firebaseUser,
    user,
    verificationId,
    message,
  ];
}
