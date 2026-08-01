abstract class LoginStates {}

class LoginInitial extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final String userId;
    LoginSuccessState({required this.userId});
}

class LoginErrorState extends LoginStates {
  final String message;
    LoginErrorState({required this.message});
}

class ResetPasswordLoading extends LoginStates {}

class ResetPasswordSuccess extends LoginStates {}

class ResetPasswordError extends LoginStates {
  final String message;
    ResetPasswordError({required this.message});
}