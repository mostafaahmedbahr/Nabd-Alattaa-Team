import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../chat/data/models/chat_room_model.dart';
import '../../../chat/presentation/view_model/chat_cubit.dart';
import '../../../chat/presentation/view_model/chat_state.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/view_model/users_cubit.dart';
import '../../../users/presentation/view_model/users_states.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  List<ChatRoomModel> _chatRooms = [];
  StreamSubscription? _chatRoomsSubscription;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    _chatRoomsSubscription?.cancel();
    final chatCubit = context.read<ChatCubit>();
    _chatRoomsSubscription = chatCubit.chatRepository
        .getChatRooms(currentUserId: _currentUserId)
        .listen(
      (result) {
        result.fold(
          (failure) {},
          (chatRooms) {
            if (mounted) {
              setState(() {
                _chatRooms = chatRooms;
              });
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _chatRoomsSubscription?.cancel();
    super.dispose();
  }

  ChatRoomModel? _findChatRoom(String otherUserId) {
    for (final room in _chatRooms) {
      if (room.participants.contains(otherUserId)) {
        return room;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
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

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async => context.read<UsersCubit>().getAllUsers(),
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: users.length,
                separatorBuilder: (_, __) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final user = users[index];
                  final chatRoom = _findChatRoom(user.id ?? '');
                  final unread = chatRoom?.unreadCount(_currentUserId) ?? 0;

                  return _UserTile(
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
      ),
    );
  }

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
}

class _UserTile extends StatelessWidget {
  final UserModel user;
  final String currentUserId;
  final int unreadCount;
  final String lastMessage;
  final DateTime? lastMessageTime;

  const _UserTile({
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
        final currentUserDoc = await FirebaseFirestore.instance
            .collection(FirestoreConstants.users)
            .doc(currentUserId)
            .get();
        final currentUserName = currentUserDoc.data()?[
                    FirestoreConstants.userName]
                as String? ??
            'مستخدم';

        final chatRoom = await context.read<ChatCubit>().getOrCreatePrivateChat(
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
              'senderName': currentUserName,
              'senderId': currentUserId,
            },
          );
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
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
            user.name.isNotEmpty ? user.name[0] : '?',
            style: const TextStyle(
              fontSize: 22,
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
          fontSize: 16,
          fontWeight: hasUnread ? FontWeight.bold : FontWeight.w600,
          color: AppColors.textPrimary,
          fontFamily: 'Cairo',
        ),
      ),
      subtitle: hasConversation
          ? Text(
              lastMessage,
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
            )
          : Text(
              user.position.isNotEmpty ? user.position : user.department,
              style: const TextStyle(
                fontSize: 13,
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
                      fontSize: 11,
                      fontWeight:
                          hasUnread ? FontWeight.w600 : FontWeight.normal,
                      color:
                          hasUnread ? AppColors.primary : AppColors.textHint,
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
                      '$unreadCount',
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
            )
          : const Icon(
              Icons.chat_bubble_outline,
              color: AppColors.primary,
              size: 20,
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
