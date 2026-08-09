import '../../../../common_imports.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/good_deed_model.dart';
import 'like_button.dart';

class GoodDeedFooter extends StatelessWidget {
  const GoodDeedFooter({
    super.key,
    required this.deed,
    required this.isLiked,
    required this.onLike,
  });

  final GoodDeedModel deed;
  final bool isLiked;
  final VoidCallback onLike;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule_rounded, size: 14.sp, color: AppColors.grey400),

          SizedBox(width: 6.w),

          Text(
            Helpers.timeAgo(deed.createdAt),
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),

          const Spacer(),

          GoodDeedLikeButton(deed: deed, isLiked: isLiked, onLike: onLike),
        ],
      ),
    );
  }
}
