
import '../../data/models/register_model.dart';

abstract class RegisterStates {
  const RegisterStates();
}

class RegisterInitialState extends RegisterStates {
  const RegisterInitialState();
}

class RegisterLoadingState extends RegisterStates {
  const RegisterLoadingState();
}

class RegisterSuccessState extends RegisterStates {
  final RegisterModel user;

  const RegisterSuccessState({required this.user});
}

class RegisterErrorState extends RegisterStates {
  final String message;

  const RegisterErrorState({required this.message});
}
// New state for UI updates (form changes, step changes, etc.)
class RegisterStateUpdated extends RegisterStates {
  const RegisterStateUpdated();
}