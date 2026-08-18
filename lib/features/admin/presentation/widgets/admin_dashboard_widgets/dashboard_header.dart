import '../../../../../common_imports.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 14.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child:   Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.admin_panel_settings,
                  color: Colors.white, size: 28.sp),
              SizedBox(width: 10.w),
              Text(
                'مرحبًا بك في لوحة التحكم',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'إدارة المستخدمين، المهام، الشكاوى والأفكار من مكان واحد',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.white70,
              height: 1.5.h,
            ),
          ),
        ],
      ),
    );
  }
}
