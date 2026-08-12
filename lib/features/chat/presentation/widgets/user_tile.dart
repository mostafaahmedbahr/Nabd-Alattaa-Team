import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../users/data/models/user_model.dart';
import '../view_model/chat_cubit.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final String currentUserId;
  final int unreadCount;
  final String lastMessage;
  final DateTime? lastMessageTime;

  const UserTile({super.key,
    required this.user,
    required this.currentUserId,
    required this.unreadCount,
    required this.lastMessage,
    this.lastMessageTime,
  });

  @override
  Widget build(BuildContext context) {
    final hasUnread = unreadCount > 0;
    final hasConversation = lastMessage.isNotEmpty;

    return ListTile(
      onTap: () async {
        final chatCubit = context.read<ChatCubit>();

        final currentUserDoc = await FirebaseFirestore.instance
            .collection(FirestoreConstants.users)
            .doc(currentUserId)
            .get();
        final currentUserName = currentUserDoc.data()?[
        FirestoreConstants.userName]
        as String? ??
            'مستخدم';

        final chatRoom = await chatCubit.getOrCreatePrivateChat(
          currentUserId: currentUserId,
          currentUserName: currentUserName,
          otherUserId: user.id ?? '',
          otherUserName: user.name,
        );

        if (chatRoom != null && context.mounted) {
          await context.push(
            '/chat-room/${chatRoom.id}',
            extra: {
              'roomName': user.name,
              'currentUserName': currentUserName,
              'currentUserId': currentUserId,
            },
          );
        }
      },
      contentPadding:   EdgeInsets.symmetric(horizontal: 16.w,
          vertical: 4.h),
      leading: Container(
        width: 52.w,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            user.name.isNotEmpty ? user.name[0] : '?',
            style:   TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
      title: Text(
        user.name,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),
      subtitle: hasConversation
          ? Text(
        lastMessage,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
          color: hasUnread
              ? AppColors.textPrimary
              : AppColors.textSecondary,
          fontFamily: 'Cairo',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )
          : Text(
        user.position.isNotEmpty ? user.position : user.department,
        style:   TextStyle(
          fontSize: 13.sp,
          color: AppColors.textSecondary,
          fontFamily: 'Cairo',
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: hasConversation
          ? Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (lastMessageTime != null)
            Text(
              _formatTime(lastMessageTime!),
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight:
                hasUnread ? FontWeight.w600 : FontWeight.normal,
                color:
                hasUnread ? AppColors.primary : AppColors.textHint,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 6.h),
          if (hasUnread)
            Container(
              padding:   EdgeInsets.symmetric(
                horizontal: 8.w,
                vertical: 3.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$unreadCount',
                style:   TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textWhite,
                  fontFamily: 'Cairo',
                ),
              ),
            )
          else
              SizedBox(height: 22.h),
        ],
      )
          :   Icon(
        Icons.chat_bubble_outline,
        color: AppColors.primary,
        size: 20.sp,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inDays == 0) {
      return DateFormat('hh:mm a', 'ar_SA').format(time);
    } else if (diff.inDays == 1) {
      return 'أمس';
    } else if (diff.inDays < 7) {
      return DateFormat('EEEE', 'ar_SA').format(time);
    } else {
      return DateFormat('dd/MM', 'ar_SA').format(time);
    }
  }
}