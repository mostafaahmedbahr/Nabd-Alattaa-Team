// users_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repos/users_repo.dart';
import 'users_states.dart';

class UsersCubit extends Cubit<UsersStates> {
  final UsersRepo usersRepo;

  UsersCubit({required this.usersRepo}) : super( UsersInitialState()) {
    print('🟢 [UsersCubit] Constructor called');
  }

  // دالة لجلب جميع المستخدمين
  Future<void> getAllUsers() async {
    print('🟢 [UsersCubit] getAllUsers() called');
    emit( UsersLoadingState());
    print('🟡 [UsersCubit] Loading state emitted');

    final result = await usersRepo.getAllUsers();

    result.fold(
          (failure) {
        print('🔴 [UsersCubit] Error: ${failure.message}');
        emit(UsersErrorState(message: failure.message));
      },
          (users) {
        if (users.isEmpty) {
          print('🟠 [UsersCubit] Users list is empty');
          emit( UsersEmptyState());
        } else {
          print('✅ [UsersCubit] Users fetched successfully: ${users.length} users');
          for (var user in users) {
            print('   👤 Name: ${user.name}, Email: ${user.email}, Role: ${user.role}');
          }
          emit(UsersSuccessState(users: users));
        }
      },
    );
  }

  // دالة لجلب المستخدمين حسب الدور (مثال)
  Future<void> getUsersByRole(String role) async {
    emit( UsersLoadingState());

    final result = await usersRepo.getUsersByRole(role);

    result.fold(
          (failure) => emit(UsersErrorState(message: failure.message)),
          (users) {
        if (users.isEmpty) {
          emit( UsersEmptyState());
        } else {
          emit(UsersSuccessState(users: users));
        }
      },
    );
  }

  // دالة لجلب المستخدمين حسب الحالة (مثال: pending, approved, rejected)
  Future<void> getUsersByStatus(String status) async {
    emit( UsersLoadingState());

    final result = await usersRepo.getUsersByStatus(status);

    result.fold(
          (failure) => emit(UsersErrorState(message: failure.message)),
          (users) {
        if (users.isEmpty) {
          emit( UsersEmptyState());
        } else {
          emit(UsersSuccessState(users: users));
        }
      },
    );
  }

  // دالة لتحديث حالة المستخدم (موافقة/رفض)
  Future<void> updateUserStatus(String userId, String newStatus) async {
    emit( UsersLoadingState());

    final result = await usersRepo.updateUserStatus(userId, newStatus);

    result.fold(
          (failure) => emit(UsersErrorState(message: failure.message)),
          (_) {
        // بعد التحديث، نجلب المستخدمين مرة أخرى لتحديث القائمة
        getAllUsers();
      },
    );
  }
}