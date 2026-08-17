import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/users/presentation/widgets/users_items_list.dart';
import '../../../../common_imports.dart';
import '../view_model/users_cubit.dart';
import '../view_model/users_states.dart';

class UsersListScreenBody extends StatelessWidget {
  const UsersListScreenBody({super.key});

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersStates>(
      builder: (context, state) {
        if (state is UsersLoadingState) {
          return const LoadingWidget(message: AppStrings.loading);
        }

        if (state is UsersErrorState) {
          return CustomErrorWidget(
            message: state.message,
            onRetry: () => context.read<UsersCubit>().getAllUsers(),
          );
        }

        if (state is UsersEmptyState) {
          return const EmptyStateWidget(
            message: 'لا يوجد مستخدمون',
            icon: Icons.people_outline,
          );
        }

        if (state is UsersSuccessState) {
          final users = state.users
              .where((u) => u.id != _currentUserId && u.isActive)
              .toList();

          if (users.isEmpty) {
            return const EmptyStateWidget(
              message: 'لا يوجد مستخدمون آخرون',
              icon: Icons.people_outline,
            );
          }

          return UsersItemsList(users: users,);
        }

        return const SizedBox.shrink();
      },
    );
  }


}