import 'package:nabd_alattaa_team/core/widgets/error_widget.dart';

import '../../../../common_imports.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';
import '../widgets/task_details_widgets/task_app_bar_title_and_des.dart';
import '../widgets/task_details_widgets/task_description_card.dart';
import '../widgets/task_details_widgets/task_info_card.dart';
import '../widgets/task_details_widgets/task_progress_card.dart';
import '../widgets/task_details_widgets/task_status_section.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  double _completionPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is TaskLoaded) {
            final task = state.tasks.firstWhere(
              (t) => t.id == widget.taskId,
              orElse: () => state.tasks.first,
            );

            _completionPercentage = task.completionPercentage.toDouble();

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                TaskAppBarTitleAndDes(task: task),
                SliverToBoxAdapter(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<TaskCubit>().loadTasks();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TaskDescriptionCard(task: task),
                            SizedBox(height: 12.h),
                          TaskInfoCard(task: task),
                            SizedBox(height: 12.h),
                          TaskProgressCard(
                            percentage: _completionPercentage,
                            onChanged: (value) {
                              setState(() {
                                _completionPercentage = value;
                              });
                            },
                            onChangeEnd: (value) {
                              context.read<TaskCubit>().updateTaskStatus(
                                    widget.taskId,
                                    task.status,
                                    value.round(),
                                  );
                            },
                          ),
                          SizedBox(height: 12.h),
                          TaskStatusSection(
                            currentStatus: task.status,
                            taskId: widget.taskId,
                            completionPercentage:
                                _completionPercentage.round(),
                          ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          if (state is TaskError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: (){
                context.read<TaskCubit>().loadTasks();
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }




}


