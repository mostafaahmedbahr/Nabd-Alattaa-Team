import 'package:nabd_alattaa_team/features/users/data/models/user_model.dart';

import '../../../../../common_imports.dart';

class DashboardTopEmployees extends StatelessWidget {
  const DashboardTopEmployees({super.key, required this.employees});
  final List<UserModel> employees;
  @override
  Widget build(BuildContext context) {
    if (employees.isEmpty) {
      return const EmptyStateWidget(
        message: 'لا يوجد موظفين بعد',
        icon: Icons.people_outline,
      );
    }

    final maxPoints = employees.first.points > 0 ? employees.first.points : 1;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(12),
        itemCount: employees.length,
        separatorBuilder: (_, _) =>   Divider(height: 1.h),
        itemBuilder: (context, index) {
          final employee = employees[index];
          final rank = index + 1;
          final rankColor = rank == 1
              ? const Color(0xFFF5B50A)
              : rank == 2
              ? const Color(0xFF9CA3AF)
              : rank == 3
              ? const Color(0xFFCD7F32)
              : AppColors.grey400;
          final progress =
          maxPoints > 0 ? employee.points / maxPoints : 0.0;

          return Padding(
            padding:   EdgeInsets.symmetric(vertical: 8.h, horizontal: 6.w),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  height: 30.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: rankColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$rank',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: rankColor,
                    ),
                  ),
                ),
                  SizedBox(width: 12.w),
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  child: Text(
                    employee.name.isNotEmpty ? employee.name[0] : '?',
                    style:   TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                  SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style:   TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                        SizedBox(height: 6.h),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6.r),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6.h,
                          backgroundColor: AppColors.grey200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            rankColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                  SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                          Icon(
                          Icons.stars_rounded,
                          size: 16.sp,
                          color: AppColors.accent,
                        ),
                          SizedBox(width: 4.w),
                        Text(
                          '${employee.points}',
                          style:   TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                      SizedBox(height: 2.h),
                    Text(
                      employee.department,
                      style:   TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
