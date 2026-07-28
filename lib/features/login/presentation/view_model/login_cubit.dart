import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos/login_repos.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepository loginRepository;

  LoginCubit({required this.loginRepository}) : super(const LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(const LoginLoading());
    final result = await loginRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginError(message: failure.message)),
      (userId) => emit(LoginSuccess(userId: userId)),
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(const ResetPasswordLoading());
    final result = await loginRepository.resetPassword(email: email);

    result.fold(
      (failure) => emit(ResetPasswordError(message: failure.message)),
      (_) => emit(const ResetPasswordSuccess()),
    );
  }
}
