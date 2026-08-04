import 'package:nabd_alattaa_team/core/widgets/error_widget.dart';
import 'package:nabd_alattaa_team/features/tasks/presentation/widgets/tasks_view_widgets/task_card.dart';

import '../../../../../common_imports.dart';
import '../../view_model/task_cubit.dart';
import '../../view_model/task_state.dart';

class TasksListItems extends StatelessWidget {
  const TasksListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskCubit, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        if (state is TaskError) {
          return SliverFillRemaining(
            child: CustomErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<TaskCubit>().loadTasks();
              },
            ),
          );
        }

        if (state is TaskLoaded) {
          if (state.tasks.isEmpty) {
            return SliverFillRemaining(
              child: EmptyStateWidget(
                message: "لا توجد مهام حالياً",
                icon: Icons.hourglass_empty,
              ),
            );
          }

          return SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (state.myAssignedTasks.isNotEmpty) ...[
                  _SectionHeader(
                    title: "مهام أوكلتها للآخرين",
                    icon: Icons.group_outlined,
                    count: state.myAssignedTasks.length,
                  ),
                  SizedBox(height: 8.h),
                  ...state.myAssignedTasks.map((task) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: TaskCard(task: task),
                      )),
                  SizedBox(height: 16.h),
                ],
                if (state.assignedToMeTasks.isNotEmpty) ...[
                  _SectionHeader(
                    title: "مهام مسندة إليك",
                    icon: Icons.person_outlined,
                    count: state.assignedToMeTasks.length,
                  ),
                  SizedBox(height: 8.h),
                  ...state.assignedToMeTasks.map((task) => Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: TaskCard(task: task),
                      )),
                ],
                if (state.myAssignedTasks.isEmpty &&
                    state.assignedToMeTasks.isEmpty)
                  EmptyStateWidget(
                    message: "لا توجد مهام حالياً",
                    icon: Icons.hourglass_empty,
                  ),
              ]),
            ),
          );
        }

        return const SliverFillRemaining(child: SizedBox.shrink());
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final int count;

  const _SectionHeader({
    required this.title,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            "$count",
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
