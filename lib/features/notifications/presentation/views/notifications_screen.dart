import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/notification_cubit.dart';
import '../view_model/notification_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.notifications,
          actions: [
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoaded && state.unreadCount > 0) {
                  return TextButton(
                    onPressed: () {
                      context.read<NotificationCubit>().markAllAsRead('current_user_id');
                    },
                    child: const Text(
                      ' قراءة الكل',
                      style: TextStyle(color: AppColors.textWhite),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const LoadingWidget(message: AppStrings.loading);
            }

            if (state is NotificationError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: () {
                  context.read<NotificationCubit>().loadNotifications('current_user_id');
                },
              );
            }

            if (state is NotificationLoaded) {
              if (state.notifications.isEmpty) {
                return const EmptyStateWidget(
                  message: 'لا توجد تنبيهات',
                  icon: Icons.notifications_none_outlined,
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  final isUnread = !notification.isRead;

                  return ListTile(
                    tileColor: isUnread
                        ? AppColors.primary.withOpacity(0.05)
                        : null,
                    leading: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          backgroundColor: isUnread
                              ? AppColors.primary.withOpacity(0.1)
                              : AppColors.grey200,
                          child: Icon(
                            _getNotificationIcon(notification.type),
                            color: isUnread ? AppColors.primary : AppColors.grey500,
                            size: 20,
                          ),
                        ),
                        if (isUnread)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: AppColors.error,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notification.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatDate(notification.createdAt),
                          style: const TextStyle(
                            color: AppColors.textHint,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (isUnread) {
                        context.read<NotificationCubit>().markAsRead(notification.id);
                      }
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

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_task':
        return Icons.task_alt_outlined;
      case 'task_due_soon':
        return Icons.timer_outlined;
      case 'new_announcement':
        return Icons.campaign_outlined;
      case 'complaint_reply':
        return Icons.reply_outlined;
      case 'report_update':
        return Icons.update_outlined;
      case 'new_message':
        return Icons.message_outlined;
      case 'meeting_reminder':
        return Icons.event_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return intl.DateFormat('dd/MM/yyyy', 'ar').format(date);
    }
  }
}
