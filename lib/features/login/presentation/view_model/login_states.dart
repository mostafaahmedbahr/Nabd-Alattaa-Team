import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginLoading extends LoginState {
  const LoginLoading();
}

class LoginSuccess extends LoginState {
  final String userId;

  const LoginSuccess({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoginError extends LoginState {
  final String message;

  const LoginError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ResetPasswordLoading extends LoginState {
  const ResetPasswordLoading();
}

class ResetPasswordSuccess extends LoginState {
  const ResetPasswordSuccess();
}

class ResetPasswordError extends LoginState {
  final String message;

  const ResetPasswordError({required this.message});

  @override
  List<Object?> get props => [message];
}
