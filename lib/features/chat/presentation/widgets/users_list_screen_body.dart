import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/user_tile.dart';

import '../../../../common_imports.dart';
import '../../../users/presentation/view_model/users_cubit.dart';
import '../../../users/presentation/view_model/users_states.dart';
import '../../data/models/chat_room_model.dart';

class UsersListScreenBody extends StatefulWidget {
  const UsersListScreenBody({super.key, required this.chatRooms});
final List<ChatRoomModel> chatRooms;
  @override
  State<UsersListScreenBody> createState() => _UsersListScreenBodyState();
}

class _UsersListScreenBodyState extends State<UsersListScreenBody> {
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  ChatRoomModel? _findChatRoom(String otherUserId) {
    for (final room in widget.chatRooms) {
      if (room.participants.contains(otherUserId)) {
        return room;
      }
    }
    return null;
  }
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
              .where((u) => u.id != currentUserId && u.isActive)
              .toList();

          if (users.isEmpty) {
            return const EmptyStateWidget(
              message: 'لا يوجد مستخدمون آخرون',
              icon: Icons.people_outline,
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => context.read<UsersCubit>().getAllUsers(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding:   EdgeInsets.symmetric(vertical: 8.h),
              itemCount: users.length,
              separatorBuilder: (_, _) =>   SizedBox(height: 2.h),
              itemBuilder: (context, index) {
                final user = users[index];
                final chatRoom = _findChatRoom(user.id ?? '');
                final unread = chatRoom?.unreadCount(_currentUserId) ?? 0;

                return UserTile(
                  user: user,
                  currentUserId: _currentUserId,
                  unreadCount: unread,
                  lastMessage: chatRoom?.lastMessage ?? '',
                  lastMessageTime: chatRoom?.lastMessageTime,
                );
              },
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
