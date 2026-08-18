import '../../../../../common_imports.dart';

class DashboardManagementGrid extends StatelessWidget {
  const DashboardManagementGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.people_alt_outlined, 'الموظفين', AppColors.primary,
      '/manage-employees'),
      (Icons.report_problem_outlined, 'الشكاوى', AppColors.error,
      '/manage-complaints'),
      (Icons.lightbulb_outline, 'الأفكار', AppColors.accent, '/manage-ideas'),
      (Icons.business_outlined, 'الأقسام', AppColors.info,
      '/manage-departments'),
      (Icons.restaurant_menu_outlined, 'الوجبات', AppColors.warning,
      '/manage-meals'),
      (Icons.campaign_outlined, 'الإعلانات', AppColors.primary,
      '/announcements'),
    ];
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: items.map((item) {
        return InkWell(
          onTap: () => context.push(item.$4),
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item.$1, color: item.$3, size: 28),
                  SizedBox(height: 8.h),
                Text(
                  item.$2,
                  style:   TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
