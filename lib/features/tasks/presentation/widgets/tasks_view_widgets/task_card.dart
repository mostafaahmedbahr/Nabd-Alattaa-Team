import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/helpers.dart';
import '../../../data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;

  const TaskCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(task.status);
    final priorityColor = Helpers.getPriorityColor(task.priority);
    final date = DateFormat('dd MMM', 'ar').format(task.dueDate);
    final isOverdue = task.dueDate.isBefore(DateTime.now()) &&
        task.completionPercentage < 100;

    return GestureDetector(
      onTap: () => context.push('/task-details/${task.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grey100),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 5,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _Badge(
                            text: Helpers.getPriorityText(task.priority),
                            color: priorityColor,
                          ),
                        ],
                      ),
                      if (task.description.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Text(
                          task.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.grey500,
                            height: 1.4,
                          ),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.person_outline_rounded,
                            text: task.assigneeName,
                          ),
                          const SizedBox(width: 8),
                          _InfoChip(
                            icon: Icons.calendar_today_rounded,
                            text: date,
                            textColor: isOverdue ? AppColors.error : null,
                          ),
                          const Spacer(),
                          _Badge(
                            text: task.status,
                            color: statusColor,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: LinearProgressIndicator(
                                value: task.completionPercentage / 100,
                                minHeight: 5,
                                backgroundColor: AppColors.grey100,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  task.completionPercentage == 100
                                      ? AppColors.success
                                      : AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "${task.completionPercentage}%",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: task.completionPercentage == 100
                                  ? AppColors.success
                                  : AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "مكتملة":
        return AppColors.success;
      case "جاري التنفيذ":
        return AppColors.taskInProgress;
      case "لم تبدأ":
        return AppColors.taskNotStarted;
      default:
        return AppColors.primary;
    }
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;

  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? textColor;

  const _InfoChip({
    required this.icon,
    required this.text,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.grey400),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: textColor ?? AppColors.grey500,
            fontWeight: textColor != null ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}