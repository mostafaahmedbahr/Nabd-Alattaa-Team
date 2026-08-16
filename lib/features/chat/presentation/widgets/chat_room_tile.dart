import 'package:intl/intl.dart' as intl;
import 'package:nabd_alattaa_team/common_imports.dart';
import 'package:nabd_alattaa_team/features/chat/data/models/chat_room_model.dart';

class ChatRoomTile extends StatelessWidget {
  final ChatRoomModel room;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ChatRoomTile({
    super.key,
    required this.room,
    required this.currentUserId,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final otherUserName = room.otherUserName(currentUserId);
    final unread = room.unreadCount(currentUserId);
    final hasUnread = unread > 0;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: hasUnread
                      ? [AppColors.primary, AppColors.primaryLight]
                      : [AppColors.grey400, AppColors.grey300],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Center(
                child: Text(
                  otherUserName.isNotEmpty ? otherUserName[0] : '?',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName.isNotEmpty ? otherUserName : 'مستخدم',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.lastMessage.isNotEmpty ? room.lastMessage : 'ابدأ المحادثة',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                      color: hasUnread ? AppColors.textPrimary : AppColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(room.lastMessageTime),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: hasUnread ? FontWeight.w600 : FontWeight.normal,
                    color: hasUnread ? AppColors.primary : AppColors.textHint,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 8),
                if (hasUnread)
                  Container(
                    constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Center(
                      child: Text(
                        '$unread',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  )
                else
                  const Icon(
                    Icons.done_all_rounded,
                    size: 18,
                    color: AppColors.grey400,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return intl.DateFormat('hh:mm a', 'ar_SA').format(time);
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else if (diff.inDays < 7) {
      return intl.DateFormat('EEEE', 'ar_SA').format(time);
    } else {
      return intl.DateFormat('dd/MM', 'ar_SA').format(time);
    }
  }
}