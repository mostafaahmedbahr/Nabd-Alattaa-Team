import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/chat_cubit.dart';
import '../view_model/chat_state.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(title: AppStrings.chat),
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            if (state is ChatRoomsLoading) {
              return const LoadingWidget(message: AppStrings.loading);
            }

            if (state is ChatRoomsError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<ChatCubit>().loadChatRooms('current_user_id');
                },
              );
            }

            if (state is ChatRoomsLoaded) {
              if (state.chatRooms.isEmpty) {
                return const EmptyStateWidget(
                  message: 'لا توجد محادثات',
                  icon: Icons.chat_outlined,
                );
              }

              return ListView.separated(
                itemCount: state.chatRooms.length,
                separatorBuilder: (_, __) => const Divider(
                  height: 1,
                  indent: 72,
                ),
                itemBuilder: (context, index) {
                  final room = state.chatRooms[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        room.type == 'individual'
                            ? Icons.person_outline
                            : Icons.group_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    title: Text(
                      room.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      room.lastMessage ?? 'لا توجد رسائل',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: room.lastMessage != null
                            ? AppColors.textSecondary
                            : AppColors.textHint,
                      ),
                    ),
                    trailing: room.lastMessageTime != null
                        ? Text(
                            _formatDate(room.lastMessageTime!),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          )
                        : null,
                    onTap: () {
                      context.push('/chat/${room.id}');
                    },
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} د';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} س';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} ي';
    } else {
      return intl.DateFormat('dd/MM', 'ar').format(date);
    }
  }
}
