import '../../../../../common_imports.dart';
import '../../view_model/admin_cubit.dart';
import '../../view_model/admin_state.dart';
import 'dashboard_header.dart';
import 'dashboard_management_grid.dart';
import 'dashboard_statistics_grid.dart';
import 'dashboard_top_employees.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key, required this.state});
  final DashboardLoaded state;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<AdminCubit>().loadDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                    AppStrings.statistics,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                    SizedBox(height: 12.h),
                  DashboardStatisticsGrid(stats:state.statistics),
                    SizedBox(height: 24.h),
                    Text(
                    'الإدارة',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                    SizedBox(height: 12.h),
                  DashboardManagementGrid(),
                    SizedBox(height: 24.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                        Text(
                        'الموظفين الأكثر نشاطاً',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.push('/manage-employees');
                        },
                        child: const Text('عرض الكل'),
                      ),
                    ],
                  ),
                    SizedBox(height: 8.h),
                  DashboardTopEmployees(employees:state.topEmployees),
                    SizedBox(height: 16.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
