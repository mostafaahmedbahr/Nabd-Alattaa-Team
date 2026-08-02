import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../view_model/task_cubit.dart';
import 'section_title.dart';

class TaskStatusSection extends StatelessWidget {
  final String currentStatus;
  final String taskId;
  final int completionPercentage;

  const TaskStatusSection({
    super.key,
    required this.currentStatus,
    required this.taskId,
    required this.completionPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      (
        "لم تبدأ",
        Icons.hourglass_empty_rounded,
        AppColors.taskNotStarted,
      ),
      (
        "جاري التنفيذ",
        Icons.play_circle_fill_rounded,
        AppColors.taskInProgress,
      ),
      (
        "مكتملة",
        Icons.check_circle_rounded,
        AppColors.taskCompleted,
      ),
    ];

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
            const SectionTitle(
              title: "حالة المهمة",
              icon: Icons.sync_alt_rounded,
            ),
            const SizedBox(height: 14),
            Row(
              children: statuses.map((status) {
                final isSelected = currentStatus == status.$1;
                final statusColor = status.$3;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () {
                        context.read<TaskCubit>().updateTaskStatus(
                              taskId,
                              status.$1,
                              completionPercentage,
                            );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? statusColor.withOpacity(0.12)
                              : AppColors.grey50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected
                                ? statusColor.withOpacity(0.4)
                                : AppColors.grey200,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              status.$2,
                              size: 24,
                              color: isSelected ? statusColor : AppColors.grey400,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              status.$1,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? statusColor : AppColors.grey500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
