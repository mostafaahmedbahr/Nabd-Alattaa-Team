import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class AnnouncementsEmptyState extends StatelessWidget {
  const AnnouncementsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
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
      ),
    );
  }
}