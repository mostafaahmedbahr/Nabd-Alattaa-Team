import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repos_impl/register_repo_impl.dart';
import '../../data/models/register_model.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepoImpl registerRepo;

  RegisterCubit({required this.registerRepo}) : super(const RegisterInitial());

  Future<void> register({
    required RegisterModel registerData,
  }) async {
    emit(const RegisterLoading());
    final result = await registerRepo.register(registerData: registerData);

    result.fold(
      (failure) => emit(RegisterError(message: failure.message)),
      (userId) => emit(RegisterSuccess(userId: userId)),
    );
  }
}
