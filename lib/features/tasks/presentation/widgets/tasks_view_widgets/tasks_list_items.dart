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
            sliver: SliverList.separated(
              itemCount: state.tasks.length,
              separatorBuilder: (_, _) => SizedBox(height: 10.h),
              itemBuilder: (context, index) {
                return TaskCard(task: state.tasks[index]);
              },
            ),
          );
        }

        return const SliverFillRemaining(child: SizedBox.shrink());
      },
    );
  }
}
