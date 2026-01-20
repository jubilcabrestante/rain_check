import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rain_check/core/domain/i_user_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final IAuthUserRepository repository;
  StreamSubscription<User?>? _authSub;

  AuthCubit(this.repository) : super(const AuthState.initial()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    _authSub = repository.authStream().listen((user) {
      if (user == null) {
        emit(state.copyWith(status: AuthStatus.unauthenticated));
      } else {
        emit(
          state.copyWith(status: AuthStatus.authenticated, firebaseUser: user),
        );
      }
    });
  }

  // --------------------
  // EMAIL LOGIN
  // --------------------
  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await repository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (user) => emit(
        state.copyWith(status: AuthStatus.authenticated, firebaseUser: user),
      ),
    );
  }

  // --------------------
  // GOOGLE SIGN-IN
  // --------------------
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await repository.signInWithGoogle();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (user) =>
          emit(state.copyWith(status: AuthStatus.authenticated, user: user)),
    );
  }

  // --------------------
  // REGISTER
  // --------------------
  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await repository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (user) => emit(
        state.copyWith(status: AuthStatus.authenticated, firebaseUser: user),
      ),
    );
  }

  // --------------------
  // FORGOT PASSWORD
  // --------------------
  Future<void> forgotPassword(String email) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await repository.forgotPassword(email);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.passwordResetSent)),
    );
  }

  // --------------------
  // SEND OTP
  // --------------------
  Future<void> sendOTP(String phoneNumber) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await repository.sendOTP(phoneNumber);

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
            ),
          );
        } else {
          emit(state.copyWith(status: AuthStatus.phoneLinked));
        }
      },
    );
  }

  // --------------------
  // VERIFY OTP
  // --------------------
  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await repository.verifyOTP(verificationId, smsCode);

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.otpVerified)),
    );
  }

  // --------------------
  // LOGOUT
  // --------------------
  Future<void> logout() async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await repository.logout();

    result.fold(
      (failure) => emit(
        state.copyWith(status: AuthStatus.error, message: failure.errorMesage),
      ),
      (_) => emit(state.copyWith(status: AuthStatus.unauthenticated)),
    );
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
