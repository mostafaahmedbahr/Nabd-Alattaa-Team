import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/complaint_model.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;

  const ComplaintCard({super.key, required this.complaint});

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
                    complaint.title,
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
              complaint.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                if (complaint.isAnonymous) ...[
                  Icon(Icons.person_off, size: 16, color: AppColors.grey500),
                  const SizedBox(width: 4),
                  const Text('مجهول'),
                ] else ...[
                  Icon(Icons.person, size: 16, color: AppColors.grey500),
                  const SizedBox(width: 4),
                  Text(complaint.creatorName),
                ],
                const Spacer(),
                Icon(Icons.calendar_today, size: 16, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(
                  Helpers.timeAgo(complaint.createdAt),
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

    switch (complaint.status) {
      case 'pending':
        color = AppColors.warning;
        text = 'قيد الانتظار';
        break;
      case 'in_progress':
        color = AppColors.info;
        text = 'قيد التنفيذ';
        break;
      case 'resolved':
        color = AppColors.success;
        text = 'تم الحل';
        break;
      default:
        color = AppColors.grey500;
        text = 'مغلق';
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
