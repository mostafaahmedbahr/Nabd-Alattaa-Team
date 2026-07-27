import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/auth_repo.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
    on<ResetPasswordEvent>(_onResetPassword);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await authRepository.login(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (userId) => emit(AuthAuthenticated(userId: userId)),
    );
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    final result = await authRepository.logout();

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onResetPassword(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await authRepository.resetPassword(email: event.email);

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(const PasswordResetSent()),
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      final result = await authRepository.getCurrentUserId();
      result.fold(
        (failure) => emit(const AuthUnauthenticated()),
        (userId) => emit(AuthAuthenticated(userId: userId)),
      );
    } else {
      emit(const AuthUnauthenticated());
    }
  }
}
