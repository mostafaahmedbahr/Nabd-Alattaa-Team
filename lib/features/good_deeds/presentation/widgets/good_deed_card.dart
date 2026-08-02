import 'package:intl/intl.dart' as intl;
import 'package:nabd_alattaa_team/common_imports.dart';
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
      margin:   EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              deed.content,
              style:   TextStyle(
                fontSize: 15.sp,
                color: AppColors.textPrimary,
                height: 1.5.h,
              ),
            ),
              SizedBox(height: 12.h),
            Row(
              children: [
                Text(
                  _formatDate(deed.createdAt),
                  style:   TextStyle(
                    fontSize: 11.sp,
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
                  SizedBox(width: 16.w),
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
          Icon(icon, size: 20.sp, color: color),
            SizedBox(width: 4.w),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 13.sp,
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
