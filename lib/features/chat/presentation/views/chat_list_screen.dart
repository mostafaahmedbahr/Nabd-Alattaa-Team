import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/chat_cubit.dart';
import '../view_model/chat_state.dart';
import '../../data/models/chat_room_model.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    context.read<ChatCubit>().loadChatRooms(currentUserId: _currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.chat),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push(Routes.usersList);
          if (mounted) {
            _loadChatRooms();
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat_bubble_outline, color: AppColors.textWhite),
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingWidget(message: AppStrings.loading);
          }

          if (state is ChatError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: _loadChatRooms,
            );
          }

          if (state is ChatRoomsLoaded) {
            if (state.chatRooms.isEmpty) {
              return const EmptyStateWidget(
                message: 'لا توجد محادثات بعد',
                icon: Icons.chat_bubble_outline,
              );
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => _loadChatRooms(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.chatRooms.length,
                separatorBuilder: (_, __) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final room = state.chatRooms[index];
                  return _ChatRoomTile(
                    room: room,
                    currentUserId: _currentUserId,
                    onTap: () => _openChatRoom(room),
                    onLongPress: () => _showDeleteDialog(room),
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _openChatRoom(ChatRoomModel room) async {
    final otherUserName = room.otherUserName(_currentUserId);
    await context.push(
      '/chat-room/${room.id}',
      extra: {
        'roomName': otherUserName,
      },
    );
    if (mounted) {
      _loadChatRooms();
    }
  }

  void _showDeleteDialog(ChatRoomModel room) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف المحادثة'),
        content: const Text('هل أنت متأكد من حذف هذه المحادثة؟'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChatCubit>().deleteChatRoom(roomId: room.id);
            },
            child: const Text(
              AppStrings.delete,
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatRoomTile extends StatelessWidget {
  final ChatRoomModel room;
  final String currentUserId;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ChatRoomTile({
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
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  otherUserName.isNotEmpty ? otherUserName[0] : '?',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textWhite,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName.isNotEmpty ? otherUserName : 'مستخدم',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
                      color: AppColors.textPrimary,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.lastMessage.isNotEmpty
                        ? room.lastMessage
                        : 'ابدأ المحادثة',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: hasUnread ? FontWeight.w500 : FontWeight.normal,
                      color: hasUnread
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontFamily: 'Cairo',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
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
                const SizedBox(height: 6),
                if (hasUnread)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$unread',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 22),
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
