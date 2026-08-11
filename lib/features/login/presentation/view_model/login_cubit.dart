import '../../../../common_imports.dart';
import '../../data/repos/login_repos.dart';
import 'login_states.dart';

class LoginCubit extends Cubit<LoginStates> {
  final LoginRepository loginRepository;

  LoginCubit({required this.loginRepository}) : super(  LoginInitial());

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(  LoginLoadingState());
    final result = await loginRepository.login(
      email: email,
      password: password,
    );

    result.fold(
      (failure) => emit(LoginErrorState(message: failure.message)),
      (userId) => emit(LoginSuccessState(userId: userId)),
    );
  }

  Future<void> resetPassword({required String email}) async {
    emit(  ResetPasswordLoading());
    final result = await loginRepository.resetPassword(email: email);

    result.fold(
      (failure) => emit(ResetPasswordError(message: failure.message)),
      (_) => emit(  ResetPasswordSuccess()),
    );
  }

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(  LoginInitial());
  }
  Future<void> loginPressed() async {
    if (!formKey.currentState!.validate()) return;

    await login(
      email: emailController.text.trim(),
      password: passwordController.text,
    );
  }

  void clearFields() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }

}
