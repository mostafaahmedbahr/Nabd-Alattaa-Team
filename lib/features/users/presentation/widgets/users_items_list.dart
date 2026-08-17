import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common_imports.dart';
import '../../../chat/data/models/chat_room_model.dart';
import '../../../chat/presentation/view_model/chat_cubit.dart';
import '../../../chat/presentation/view_model/chat_state.dart';
import '../../../chat/presentation/widgets/user_tile.dart';
import '../../data/models/user_model.dart';
import '../view_model/users_cubit.dart';

class UsersItemsList extends StatelessWidget {
  const UsersItemsList({super.key, required this.users});
  final List<UserModel> users;

  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    final chatRooms = context.select<ChatCubit, List<ChatRoomModel>>(
          (cubit) => cubit.state is ChatRoomsLoaded
          ? (cubit.state as ChatRoomsLoaded).chatRooms
          : const <ChatRoomModel>[],
    );
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => context.read<UsersCubit>().getAllUsers(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: users.length,
        separatorBuilder: (_, _) => SizedBox(height: 2.h),
        itemBuilder: (context, index) {
          final user = users[index];
          final chatRoom = _findChatRoom(chatRooms, user.id ?? '');
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
  ChatRoomModel? _findChatRoom(
      List<ChatRoomModel> chatRooms,
      String otherUserId,
      ) {
    for (final room in chatRooms) {
      if (room.participants.contains(otherUserId)) {
        return room;
      }
    }
    return null;
  }
}
