import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;

  const ReportCard({super.key, required this.report});

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
                    report.title,
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
              report.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(report.creatorName),
                const Spacer(),
                Icon(Icons.calendar_today, size: 16, color: AppColors.grey500),
                const SizedBox(width: 4),
                Text(
                  Helpers.timeAgo(report.createdAt),
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

    switch (report.status) {
      case 'open':
        color = AppColors.info;
        text = 'مفتوح';
        break;
      case 'in_progress':
        color = AppColors.warning;
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
