import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/notification_cubit.dart';
import '../view_model/notification_state.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    // FirebaseFunctions.instance
    //     .httpsCallable("sendNotificationToAll");
  }

  void _loadNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
      context.read<NotificationCubit>().loadNotifications(user.uid);
    }
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
            _buildSliverAppBar(context),
            BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return const SliverFillRemaining(
                    child: Center(child: LoadingWidget()),
                  );
                }

                if (state is NotificationError) {
                  return SliverFillRemaining(
                    child: CustomErrorWidget(
                      message: state.message,
                      onRetry: () {
                        if (_userId != null) {
                          context.read<NotificationCubit>().loadNotifications(_userId!);
                        }
                      },
                    ),
                  );
                }

                if (state is NotificationLoaded) {
                  if (state.notifications.isEmpty) {
                    return SliverFillRemaining(child: _buildEmptyState());
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final notification = state.notifications[index];
                          return _buildNotificationCard(context, notification);
                        },
                        childCount: state.notifications.length,
                      ),
                    ),
                  );
                }

                return const SliverFillRemaining(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      centerTitle: true,
      title: const Text(
        'التنبيهات',
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
      actions: [
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoaded && state.unreadCount > 0) {
              return TextButton(
                onPressed: () {
                  if (_userId != null) {
                    context.read<NotificationCubit>().markAllAsRead(_userId!);
                  }
                },
                child: const Text(
                  'قراءة الكل',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Cairo',
                    fontSize: 13,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'لا توجد تنبيهات',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ستظهر التنبيهات هنا عندما تكون هناك تحديثات',
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

  Widget _buildNotificationCard(BuildContext context, dynamic notification) {
    final isUnread = !notification.isRead;
    final iconData = _getNotificationIcon(notification.type);
    final iconColor = _getNotificationColor(notification.type);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isUnread ? AppColors.primary.withOpacity(0.03) : AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUnread ? AppColors.primary.withOpacity(0.15) : AppColors.grey100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(iconData, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isUnread)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  notification.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _formatDate(notification.createdAt),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'new_task':
        return Icons.task_alt_rounded;
      case 'task_due_soon':
        return Icons.timer_rounded;
      case 'new_announcement':
        return Icons.campaign_rounded;
      case 'complaint_reply':
        return Icons.reply_rounded;
      case 'report_update':
        return Icons.update_rounded;
      case 'new_message':
        return Icons.message_rounded;
      case 'meeting_reminder':
        return Icons.event_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'new_task':
        return AppColors.info;
      case 'task_due_soon':
        return AppColors.warning;
      case 'new_announcement':
        return AppColors.primary;
      case 'complaint_reply':
        return AppColors.secondary;
      case 'report_update':
        return AppColors.error;
      case 'new_message':
        return AppColors.info;
      case 'meeting_reminder':
        return AppColors.primary;
      default:
        return AppColors.primary;
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
