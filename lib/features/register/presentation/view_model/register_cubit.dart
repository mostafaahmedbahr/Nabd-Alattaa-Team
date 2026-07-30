import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/register_model.dart';
import '../../data/repos/register_repos.dart';
import 'register_states.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  final RegisterRepo registerRepo;

  RegisterCubit({required this.registerRepo}) : super(const RegisterInitialState());

  Future<void> register({
    required RegisterModel registerData,
  }) async {
    emit(const RegisterLoadingState());

    final result = await registerRepo.register(registerData: registerData);

    result.fold(
          (failure) => emit(RegisterErrorState(message: failure.message)),
          (user) => emit(RegisterSuccessState(user: user)),
    );
  }
}