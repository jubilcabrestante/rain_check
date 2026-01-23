import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rain_check/core/domain/i_auth_user_repository.dart';
import 'package:rain_check/core/repository/user_model/user_vm.dart';

part 'auth_user_state.dart';
part 'auth_user_cubit.freezed.dart';

/// Manages user authentication state
class AuthUserCubit extends Cubit<AuthUserState> {
  final IAuthUserRepository _repository;
  StreamSubscription<dynamic>? _authSubscription;

  AuthUserCubit(IAuthUserRepository repository)
    : _repository = repository,
      super(const AuthUserState()) {
    _listenToAuthChanges();
  }

  /// Listen to Firebase Auth state changes
  void _listenToAuthChanges() {
    _authSubscription = _repository.authStream().listen(
      (user) async {
        if (user == null) {
          emit(const AuthUserState(status: AuthStatus.unauthenticated));
          return;
        }

        // User is authenticated, fetch their details
        final result = await _repository.getUserDetails(user.uid);

        result.fold(
          (failure) => emit(
            AuthUserState(
              status: AuthStatus.error,
              message: failure.errorMesage,
            ),
          ),
          (userVM) => emit(
            AuthUserState(
              status: AuthStatus.authenticated,
              currentUser: userVM,
            ),
          ),
        );
      },
      onError: (error) => emit(
        AuthUserState(status: AuthStatus.error, message: error.toString()),
      ),
    );
  }

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (user) async {
        // Fetch user details after login
        final userDetails = await _repository.getUserDetails(user.uid);

        userDetails.fold(
          (failure) => emit(
            state.copyWith(
              status: AuthStatus.error,
              message: failure.errorMesage,
            ),
          ),
          (userVM) => emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              currentUser: userVM,
            ),
          ),
        );
      },
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.signInWithGoogle();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (userVM) => emit(
        state.copyWith(status: AuthStatus.authenticated, currentUser: userVM),
      ),
    );
  }

  /// Register with email and password
  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.fold(
      (failure) async => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (user) async {
        // Create user document in Firestore
        final newUser = UserVM(id: user.uid, fullName: fullName, email: email);

        final addResult = await _repository.addUserDetails(newUser);

        addResult.fold(
          (failure) => emit(
            state.copyWith(
              status: AuthStatus.error,
              message: failure.errorMesage,
            ),
          ),
          (userVM) => emit(
            state.copyWith(
              status: AuthStatus.authenticated,
              currentUser: userVM,
            ),
          ),
        );
      },
    );
  }

  /// Send password reset email
  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.forgotPassword(email);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (_) => emit(
        state.copyWith(
          status: AuthStatus.passwordResetSent,
          message: 'Password reset email sent. Please check your inbox.',
        ),
      ),
    );
  }

  /// Send OTP to phone number
  Future<void> sendOTP(String phoneNumber) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.sendOTP(phoneNumber);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (verificationId) {
        if (verificationId != null) {
          emit(
            state.copyWith(
              status: AuthStatus.otpSent,
              verificationId: verificationId,
              message: 'OTP sent successfully',
            ),
          );
        } else {
          emit(
            state.copyWith(
              status: AuthStatus.phoneLinked,
              message: 'Phone number linked successfully',
            ),
          );
        }
      },
    );
  }

  /// Verify OTP code
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.verifyOTP(verificationId, smsCode);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (_) async {
        // Update user document with phone number
        final currentUser = state.currentUser;
        if (currentUser != null) {
          emit(
            state.copyWith(
              status: AuthStatus.otpVerified,
              message: 'Phone number verified successfully',
            ),
          );
        }
      },
    );
  }

  /// Logout user
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.logout();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (_) => emit(const AuthUserState(status: AuthStatus.unauthenticated)),
    );
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(message: null));
  }

  /// Clear user data (used internally)
  void clearUser() {
    emit(const AuthUserState(status: AuthStatus.unauthenticated));
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
