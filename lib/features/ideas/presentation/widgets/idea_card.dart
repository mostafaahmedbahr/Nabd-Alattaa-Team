import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/idea_model.dart';

class IdeaCard extends StatelessWidget {
  final IdeaModel idea;

  const IdeaCard({super.key, required this.idea});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    idea.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildStatusBadge(),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              idea.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(idea.creatorName),
                const Spacer(),
                Icon(Icons.calendar_today, size: 16, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(
                  Helpers.timeAgo(idea.createdAt),
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;

    switch (idea.status) {
      case 'pending':
        color = AppColors.warning;
        text = 'قيد الانتظار';
        break;
      case 'accepted':
        color = AppColors.success;
        text = 'مقبولة';
        break;
      case 'rejected':
        color = AppColors.error;
        text = 'مرفوضة';
        break;
      case 'implemented':
        color = AppColors.info;
        text = 'تم التنفيذ';
        break;
      default:
        color = AppColors.grey500;
        text = idea.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
