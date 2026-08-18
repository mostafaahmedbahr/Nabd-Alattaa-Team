import 'package:nabd_alattaa_team/features/admin/presentation/widgets/admin_dashboard_widgets/stat_card.dart';

import '../../../../../common_imports.dart';

class DashboardStatisticsGrid extends StatelessWidget {
  const DashboardStatisticsGrid({super.key, required this.stats});
  final Map<String, int> stats;
  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      children: [
        StatCard(
          title: 'عدد الموظفين',
          value: '${stats['totalEmployees'] ?? 0}',
          icon: Icons.people_outlined,
          color: AppColors.primary,
        ),
        StatCard(
          title: 'عدد المهام',
          value: '${stats['totalTasks'] ?? 0}',
          icon: Icons.task_alt_outlined,
          color: AppColors.info,
        ),
        StatCard(
          title: 'المهام المفتوحة',
          value: '${stats['openTasks'] ?? 0}',
          icon: Icons.pending_actions_outlined,
          color: AppColors.warning,
        ),
        StatCard(
          title: 'البلاغات المفتوحة',
          value: '${stats['openComplaints'] ?? 0}',
          icon: Icons.report_outlined,
          color: AppColors.error,
        ),
      ],
    );
  }
}
