import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../chat/presentation/view_model/chat_cubit.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/view_model/users_cubit.dart';
import '../../../users/presentation/view_model/users_states.dart';

class UsersListScreen extends StatelessWidget {
  const UsersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('بدء محادثة'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
      ),
      body: BlocBuilder<UsersCubit, UsersStates>(
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
                .where((u) => u.id != currentUserId && u.isActive)
                .toList();

            if (users.isEmpty) {
              return const EmptyStateWidget(
                message: 'لا يوجد مستخدمون آخرون',
                icon: Icons.people_outline,
              );
            }

            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final user = users[index];
                return _UserTile(
                  user: user,
                  currentUserId: currentUserId,
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final String currentUserId;

  const _UserTile({
    required this.user,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        final chatRoom = await context.read<ChatCubit>().getOrCreatePrivateChat(
              currentUserId: currentUserId,
              currentUserName:
                  FirebaseAuth.instance.currentUser?.displayName ?? 'مستخدم',
              otherUserId: user.id ?? '',
              otherUserName: user.name,
            );

        if (chatRoom != null && context.mounted) {
          context.push(
            '/chat-room/${chatRoom.id}',
            extra: {
              'roomName': user.name,
            },
          );
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            user.name.isNotEmpty ? user.name[0] : '?',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),
      subtitle: Text(
        user.position.isNotEmpty ? user.position : user.department,
        style: const TextStyle(
          fontSize: 13,
          color: AppColors.textSecondary,
          fontFamily: 'Cairo',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: const Icon(
        Icons.chat_bubble_outline,
        color: AppColors.primary,
        size: 20,
      ),
    );
  }
}
