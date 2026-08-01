// users_states.dart

import '../../data/models/user_model.dart';

abstract class UsersStates {}

class UsersInitialState extends UsersStates {}

class UsersLoadingState extends UsersStates {}

class UsersSuccessState extends UsersStates {
  final List<UserModel> users;
   UsersSuccessState({required this.users});
}

class UsersEmptyState extends UsersStates {}

class UsersErrorState extends UsersStates {
  final String message;
   UsersErrorState({required this.message});
}