import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;

  const TaskDetailsScreen({super.key, required this.taskId});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  double _completionPercentage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المهمة')),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoaded) {
            final task = state.tasks.firstWhere(
              (t) => t.id == widget.taskId,
              orElse: () => state.tasks.first,
            );

            _completionPercentage = task.completionPercentage.toDouble();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    task.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Status & Priority
                  Row(
                    children: [
                      _buildBadge(task.status, AppColors.info),
                      const SizedBox(width: 8),
                      _buildBadge(task.priority, AppColors.warning),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'الوصف',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(task.description),
                  const SizedBox(height: 24),

                  // Due Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'موعد التسليم: ${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Progress Slider
                  const Text(
                    'نسبة الإنجاز',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _completionPercentage,
                    min: 0,
                    max: 100,
                    divisions: 20,
                    label: '${_completionPercentage.round()}%',
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
                  const SizedBox(height: 24),

                  // Status Change Buttons
                  const Text(
                    'تغيير الحالة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildStatusButton(
                        context,
                        AppStrings.notStarted,
                        'not_started',
                      ),
                      _buildStatusButton(
                        context,
                        AppStrings.inProgress,
                        'in_progress',
                      ),
                      _buildStatusButton(
                        context,
                        AppStrings.inReview,
                        'in_review',
                      ),
                      _buildStatusButton(
                        context,
                        AppStrings.completed,
                        'completed',
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatusButton(
    BuildContext context,
    String label,
    String status,
  ) {
    return ElevatedButton(
      onPressed: () {
        context.read<TaskCubit>().updateTaskStatus(
              widget.taskId,
              status,
              _completionPercentage.round(),
            );
      },
      child: Text(label),
    );
  }
}
