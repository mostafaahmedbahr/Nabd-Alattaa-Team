import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/task-details/${task.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildPriorityBadge(),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: AppColors.grey500),
                  const SizedBox(width: 4),
                  Text(task.assigneeName),
                  const Spacer(),
                  Icon(Icons.calendar_today, size: 16, color: AppColors.grey500),
                  const SizedBox(width: 4),
                  Text(
                    '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: task.completionPercentage / 100,
                      backgroundColor: AppColors.grey200,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.completionPercentage == 100
                            ? AppColors.success
                            : AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${task.completionPercentage}%'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge() {
    Color color;
    switch (task.priority) {
      case 'high':
        color = AppColors.priorityHigh;
        break;
      case 'medium':
        color = AppColors.priorityMedium;
        break;
      case 'low':
        color = AppColors.priorityLow;
        break;
      default:
        color = AppColors.grey500;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        Helpers.getPriorityText(task.priority),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
