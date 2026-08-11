import '../../../../common_imports.dart';
///
class ComplaintEmptyState extends StatelessWidget {
  const ComplaintEmptyState({super.key});
///mostafa
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.r),
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
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: const Icon(
                Icons.feedback_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'لا توجد شكاوى بعد',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'ابدأ بإرسال شكوى أو اقتراح',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
