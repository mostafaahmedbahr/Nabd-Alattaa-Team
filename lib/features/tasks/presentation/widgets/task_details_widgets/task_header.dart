import 'package:flutter/material.dart';
import 'package:nabd_alattaa_team/core/constants/app_colors.dart';
import '../../../data/models/task_model.dart';
import 'task_badge.dart';

class TaskHeader extends StatelessWidget {
  final TaskModel task;

  const TaskHeader({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = task.completionPercentage.clamp(0, 100) / 100;

    return Card(
      elevation: 0,
      shadowColor: Colors.black12,
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
            Text(
              task.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                TaskBadge(
                  text: task.status,
                  color: _statusColor(task.status),
                  icon: Icons.flag_circle,
                ),
                TaskBadge(
                  text: task.priority,
                  color: _priorityColor(task.priority),
                  icon: Icons.priority_high_rounded,
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 6,
                      backgroundColor: AppColors.grey100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "${task.completionPercentage}%",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
      case "مكتملة":
        return Colors.green;
      case "in_progress":
      case "جاري التنفيذ":
        return Colors.blue;
      case "not_started":
      case "لم تبدأ":
      case "لم تبدأ":
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
      case "عالية":
        return Colors.red;
      case "medium":
      case "متوسطة":
        return Colors.orange;
      case "low":
      case "منخفضة":
        return Colors.green;
      default:
        return Colors.deepPurple;
    }
  }
}
