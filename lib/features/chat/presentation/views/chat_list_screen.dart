import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/chat_cubit.dart';
import '../view_model/chat_state.dart';
import '../../data/models/chat_room_model.dart';
import '../widgets/chat_room_tile.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(child: LoadingWidget()),
                    );
                  }

                  if (state is ChatError) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: CustomErrorWidget(
                        message: state.message,
                        onRetry: _loadChatRooms,
                      ),
                    );
                  }

                  if (state is ChatRoomsLoaded) {
                    if (state.chatRooms.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildChatList(state.chatRooms);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () async {
              await context.push(Routes.usersList);
              if (mounted) _loadChatRooms();
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add_comment_rounded, color: Colors.white, size: 26),
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      centerTitle: true,
      title: const Text(
        'المحادثات',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryDark],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          const SizedBox(height: 80),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد محادثات بعد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ابدأ محادثة جديدة مع أعضاء الفريق',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatList(List<ChatRoomModel> chatRooms) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _loadChatRooms(),
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: chatRooms.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final room = chatRooms[index];
          return ChatRoomTile(
            room: room,
            currentUserId: _currentUserId,
            onTap: () => _openChatRoom(room),
            onLongPress: () => _showDeleteDialog(room),
          );
        },
      ),
    );
  }

  void _openChatRoom(ChatRoomModel room) async {
    final otherUserName = room.otherUserName(_currentUserId);

    final currentUserSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(_currentUserId)
        .get();
    final currentUserName = currentUserSnapshot.data()?['user_name'] as String? ?? '';

    if (!mounted) return;

    await context.push(
      '/chat-room/${room.id}',
      extra: {
        'roomName': otherUserName,
        'currentUserId': _currentUserId,
        'currentUserName': currentUserName,
      },
    );
    if (mounted) _loadChatRooms();
  }

  void _showDeleteDialog(ChatRoomModel room) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'حذف المحادثة',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'هل أنت متأكد من حذف هذه المحادثة؟',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.grey300),
                        ),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.read<ChatCubit>().deleteChatRoom(roomId: room.id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'حذف',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
