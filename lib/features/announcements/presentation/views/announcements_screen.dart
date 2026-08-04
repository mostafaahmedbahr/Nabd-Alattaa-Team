import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../view_model/announcement_cubit.dart';
import '../view_model/announcement_state.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnnouncementCubit>().loadAnnouncements();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              centerTitle: true,
              title: const Text(
                'الإعلانات',
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
            ),
            BlocBuilder<AnnouncementCubit, AnnouncementState>(
              builder: (context, state) {
                if (state is AnnouncementLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                  );
                }

                if (state is AnnouncementError) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                          SizedBox(height: 16.h),
                          Text(state.message, style: AppTextStyles.bodyMedium),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => context.read<AnnouncementCubit>().loadAnnouncements(),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is AnnouncementLoaded) {
                  if (state.announcements.isEmpty) {
                    return SliverFillRemaining(child: _buildEmptyState());
                  }

                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final announcement = state.announcements[index];
                          return _buildAnnouncementCard(context, announcement);
                        },
                        childCount: state.announcements.length,
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push(Routes.createAnnouncement);
          if (mounted) {
            context.read<AnnouncementCubit>().loadAnnouncements();
          }
        },
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: Icon(Icons.add_rounded, size: 24.sp),
        label: Text(
          "إعلان جديد",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.campaign_outlined,
              size: 48.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'لا توجد إعلانات بعد',
            style: AppTextStyles.h3.copyWith(color: AppColors.textPrimary),
          ),
          SizedBox(height: 8.h),
          Text(
            'ستظهر الإعلانات هنا عندما تُنشر',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(BuildContext context, Map<String, dynamic> announcement) {
    final type = announcement['type'] ?? 'news';
    final typeColor = _getTypeColor(type);
    final typeName = context.read<AnnouncementCubit>().getAnnouncementTypeName(type);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14.r),
                topLeft: Radius.circular(14.r),
              ),
            ),
            child: Row(
              children: [
                Icon(_getTypeIcon(type), color: typeColor, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  typeName,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: typeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  context.read<AnnouncementCubit>().formatDate(announcement['createdAt']),
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  announcement['title'] ?? '',
                  style: AppTextStyles.titleCard.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.h),
                Text(
                  announcement['content'] ?? '',
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 14.r, color: AppColors.textHint),
                    SizedBox(width: 4.w),
                    Text(
                      announcement['creatorName'] ?? '',
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textHint),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'meeting':
        return Icons.event_rounded;
      case 'holiday':
        return Icons.beach_access_rounded;
      case 'decision':
        return Icons.gavel_rounded;
      case 'alert':
        return Icons.warning_amber_rounded;
      default:
        return Icons.campaign_rounded;
    }
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'meeting':
        return AppColors.info;
      case 'holiday':
        return AppColors.secondary;
      case 'decision':
        return AppColors.primary;
      case 'alert':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }
}
