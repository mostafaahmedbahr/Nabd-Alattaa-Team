import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../data/models/task_model.dart';
import 'section_title.dart';

class TaskDescriptionCard extends StatelessWidget {
  final TaskModel task;

  const TaskDescriptionCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
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
              title: "الوصف",
              icon: Icons.description_outlined,
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: task.description.isEmpty
                    ? AppColors.grey50
                    : AppColors.primary.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: task.description.isEmpty
                    ? null
                    : Border.all(
                        color: AppColors.primary.withOpacity(0.1),
                      ),
              ),
              child: Text(
                task.description.isEmpty
                    ? "لا يوجد وصف لهذه المهمة."
                    : task.description,
                style: TextStyle(
                  fontSize: 14,
                  color: task.description.isEmpty
                      ? AppColors.grey400
                      : AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
