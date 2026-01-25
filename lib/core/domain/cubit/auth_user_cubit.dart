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
  bool _isRegistering = false;

  AuthUserCubit(IAuthUserRepository repository)
    : _repository = repository,
      super(const AuthUserState()) {
    _listenToAuthChanges();
  }

  /// Listen to Firebase Auth state changes
  void _listenToAuthChanges() {
    _authSubscription = _repository.authStream().listen((user) async {
      if (user == null) {
        emit(const AuthUserState(status: AuthStatus.unauthenticated));
        return;
      }

      if (_isRegistering) {
        return;
      }

      final result = await _repository.getUserDetails(user.uid);

      result.fold(
        (_) {
          emit(const AuthUserState(status: AuthStatus.unauthenticated));
        },
        (userVM) {
          emit(
            AuthUserState(
              status: AuthStatus.authenticated,
              currentUser: userVM,
            ),
          );
        },
      );
    });
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
    emit(state.copyWith(status: AuthStatus.googleSignInLoading, message: null));

    final result = await _repository.signInWithGoogle();

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: AuthStatus.googleError,
          message: failure.errorMesage,
        ),
      ),
      (userVM) => emit(
        state.copyWith(status: AuthStatus.authenticated, currentUser: userVM),
      ),
    );
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _isRegistering = true; // ✅ Set flag
    emit(state.copyWith(status: AuthStatus.loading, message: null));

    final result = await _repository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );

    await result.fold(
      (failure) async {
        _isRegistering = false; // ✅ Clear flag
        emit(
          state.copyWith(
            status: AuthStatus.error,
            message: failure.errorMesage,
          ),
        );
      },
      (user) async {
        final newUser = UserVM(id: user.uid, fullName: fullName, email: email);
        final addResult = await _repository.addUserDetails(newUser);

        await addResult.fold(
          (failure) async {
            _isRegistering = false; // ✅ Clear flag
            emit(
              state.copyWith(
                status: AuthStatus.error,
                message: failure.errorMesage,
              ),
            );
          },
          (userVM) async {
            _isRegistering = false; // ✅ Clear flag
            emit(
              state.copyWith(
                status: AuthStatus.successRegistration,
                message: 'Account created successfully!',
              ),
            );
          },
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
      (_) => emit(state.copyWith(status: AuthStatus.passwordResetSent)),
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

  Future<void> setAuthenticatedUser(UserVM user) async {
    emit(
      state.copyWith(
        status: AuthStatus.authenticated,
        currentUser: user,
        message: null,
      ),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
