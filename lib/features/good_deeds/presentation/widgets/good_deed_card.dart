import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../data/models/good_deed_model.dart';

class GoodDeedCard extends StatelessWidget {
  final GoodDeedModel deed;
  final VoidCallback onLike;
  final VoidCallback onPray;
  final bool isLiked;
  final bool isPrayed;

  const GoodDeedCard({
    super.key,
    required this.deed,
    required this.onLike,
    required this.onPray,
    this.isLiked = false,
    this.isPrayed = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deed.content,
              style: const TextStyle(
                fontSize: 15,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _formatDate(deed.createdAt),
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
                const Spacer(),
                _buildReactionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  count: deed.likesCount,
                  color: isLiked ? AppColors.error : AppColors.grey500,
                  onTap: onLike,
                ),
                const SizedBox(width: 16),
                _buildReactionButton(
                  icon: isPrayed ? Icons.water_drop : Icons.water_drop_outlined,
                  count: deed.prayersCount,
                  color: isPrayed ? AppColors.info : AppColors.grey500,
                  onTap: onPray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton({
    required IconData icon,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 13,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else if (diff.inDays < 7) {
      return 'منذ ${diff.inDays} يوم';
    } else {
      return intl.DateFormat('dd/MM/yyyy', 'ar').format(date);
    }
  }
}
