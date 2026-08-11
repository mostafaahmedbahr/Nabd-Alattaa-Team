// users_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nabd_alattaa_team/core/utils/log_util.dart';
import '../../data/repos/users_repo.dart';
import 'users_states.dart';

class UsersCubit extends Cubit<UsersStates> {
  final UsersRepo usersRepo;

  UsersCubit({required this.usersRepo}) : super( UsersInitialState());

  // دالة لجلب جميع المستخدمين
  Future<void> getAllUsers() async {
    emit( UsersLoadingState());
    final result = await usersRepo.getAllUsers();
    result.fold(
          (failure) {
        logError('🔴 [UsersCubit] Error: ${failure.message}');
        emit(UsersErrorState(message: failure.message));
      },
          (users) {
        if (users.isEmpty) {
          logSuccess('🟠 [UsersCubit] Users list is empty');
          emit( UsersEmptyState());
        } else {
          logSuccess('✅ [UsersCubit] Users fetched successfully: ${users.length} users');
          for (var user in users) {
            logSuccess('   👤 Name: ${user.name}, Email: ${user.email}, Role: ${user.role}');
          }
          emit(UsersSuccessState(users: users));
        }
      },
    );
  }




}