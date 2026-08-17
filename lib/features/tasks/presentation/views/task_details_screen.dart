import 'package:firebase_auth/firebase_auth.dart';

import '../../../../common_imports.dart';
import '../../data/models/task_model.dart';
import '../../data/models/task_subtask_model.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';
import '../widgets/task_details_widgets/task_app_bar_title_and_des.dart';
import '../widgets/task_details_widgets/task_description_card.dart';
import '../widgets/task_details_widgets/task_info_card.dart';
import '../widgets/task_details_widgets/task_progress_card.dart';
import '../widgets/task_details_widgets/task_status_section.dart';
import '../widgets/task_details_widgets/task_subtasks_section.dart';
import '../widgets/task_details_widgets/forward_task_sheet.dart';

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
    final currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<TaskCubit, TaskState>(
        listener: (context, state) {
          if (state is TaskForwarded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تم توجيه المهمة بنجاح'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is TaskLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is TaskForwarding) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is TaskLoaded || state is TaskForwarded) {
            final loaded = state is TaskLoaded ? state : state as TaskForwarded;
            final task = loaded.tasks.firstWhere(
              (t) => t.id == widget.taskId,
              orElse: () => loaded.tasks.first,
            );

            _completionPercentage = task.effectiveCompletionPercentage.toDouble();
            final displayStatus = task.hasChecklist
                ? task.derivedStatus
                : task.status;
            final canForward = task.assigneeId == currentUserId;

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
                          if (task.isForwarded &&
                              task.forwardedFromUserName != null)
                            _ForwardedBanner(name: task.forwardedFromUserName!),
                          if (canForward) _ForwardButton(task: task),
                          TaskDescriptionCard(task: task),
                          const SizedBox(height: 12),
                          TaskInfoCard(task: task),
                          const SizedBox(height: 12),
                          TaskProgressCard(
                            percentage: _completionPercentage,
                            enabled: !task.hasChecklist,
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
                          const SizedBox(height: 12),
                          TaskSubtasksSection(
                            subtasks: task.subtasks,
                            currentUserId: currentUserId,
                            onToggle: (subtaskId, isCompleted) {
                              context.read<TaskCubit>().toggleSubtask(
                                    taskId: widget.taskId,
                                    subtaskId: subtaskId,
                                    isCompleted: isCompleted,
                                    userId: currentUserId,
                                  );
                            },
                            onUpdate: (subtaskId, title) {
                              final subtask = task.subtasks.firstWhere(
                                (s) => s.id == subtaskId,
                                orElse: () => TaskSubtask(id: subtaskId, title: title),
                              );
                              context.read<TaskCubit>().updateSubtask(
                                    widget.taskId,
                                    subtask.copyWith(title: title),
                                  );
                            },
                            onDelete: (subtaskId) {
                              context.read<TaskCubit>().deleteSubtask(
                                    widget.taskId,
                                    subtaskId,
                                  );
                            },
                          ),
                          const SizedBox(height: 12),
                          if (task.hasChecklist)
                            _DerivedStatusChip(status: displayStatus)
                          else
                            TaskStatusSection(
                              currentStatus: task.status,
                              taskId: widget.taskId,
                              completionPercentage: _completionPercentage.round(),
                            ),
                          const SizedBox(height: 24),
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
              onRetry: () {
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

class _ForwardedBanner extends StatelessWidget {
  final String name;

  const _ForwardedBanner({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.forward_to_inbox_rounded,
              color: AppColors.warning, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'موجهة بواسطة: $name',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForwardButton extends StatelessWidget {
  final TaskModel task;

  const _ForwardButton({required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton.icon(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => ForwardTaskSheet(task: task),
          );
        },
        icon: const Icon(Icons.send_rounded),
        label: const Text('توجيه'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _DerivedStatusChip extends StatelessWidget {
  final String status;

  const _DerivedStatusChip({required this.status});

  Color _color(String status) {
    switch (status) {
      case 'مكتملة':
        return AppColors.success;
      case 'جاري التنفيذ':
        return AppColors.taskInProgress;
      default:
        return AppColors.taskNotStarted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(status);
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'حالة المهمة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Row(
                children: [
                  Icon(Icons.sync_alt_rounded, color: color),
                  const SizedBox(width: 10),
                  Text(
                    status,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'محسوبة تلقائياً',
                    style: TextStyle(fontSize: 12, color: AppColors.grey400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
