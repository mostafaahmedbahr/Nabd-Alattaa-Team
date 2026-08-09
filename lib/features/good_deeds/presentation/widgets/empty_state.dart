import '../../../../common_imports.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:   EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120.w,
              height: 120.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.secondary.withValues(alpha: 0.1),
                    AppColors.secondary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child:   Icon(
                Icons.favorite_outline_rounded,
                size: 56.sp,
                color: AppColors.secondary,
              ),
            ),
              SizedBox(height: 24.h),
              Text(
              'لا توجد أعمال خير بعد',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
              SizedBox(height: 8.h),
              Text(
              'كن أول من يشارك عمل خير',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
              SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }
}
