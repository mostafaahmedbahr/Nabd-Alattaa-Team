import 'package:nabd_alattaa_team/features/tasks/presentation/widgets/tasks_view_widgets/stat_card.dart';

import '../../../../../common_imports.dart';

class TasksAppBarHeader extends StatelessWidget {
  const TasksAppBarHeader({super.key, required this.totalTasks, required this.inProgressTasks, required this.completedTasks});
  final int totalTasks;
  final int inProgressTasks;
  final int completedTasks;
  @override
  Widget build(BuildContext context) {
    return    SliverAppBar(
      expandedHeight: 220,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      title:   Text(
        AppStrings.tasks,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      StatCard(
                        icon: Icons.list_alt_rounded,
                        label: "الكل",
                        count: totalTasks,
                      ),
                        SizedBox(width: 10.w),
                      StatCard(
                        icon: Icons.play_circle_fill_rounded,
                        label: "قيد التنفيذ",
                        count: inProgressTasks,
                      ),
                        SizedBox(width: 10.w),
                      StatCard(
                        icon: Icons.check_circle_rounded,
                        label: "مكتملة",
                        count: completedTasks,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
