import '../../../../common_imports.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/good_deed_model.dart';

class DeedDetailsBottomSheet extends StatelessWidget {
  final GoodDeedModel deed;
  const DeedDetailsBottomSheet({super.key, required this.deed});
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
            SizedBox(height: 12.h),
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.error.withValues(alpha: 0.15),
                            AppColors.error.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child:   Icon(
                        Icons.favorite_rounded,
                        color: AppColors.error,
                        size: 24.sp,
                      ),
                    ),
                      SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        deed.title.isNotEmpty ? deed.title : 'عمل خير',
                        style:   TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                  SizedBox(height: 20.h),
                if (deed.content.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      deed.content,
                      style:   TextStyle(
                        fontSize: 15.sp,
                        color: AppColors.textPrimary,
                        height: 1.7.h,
                      ),
                    ),
                  ),
                    SizedBox(height: 20.h),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16.sp,
                      color: AppColors.grey400,
                    ),
                      SizedBox(width: 6.w),
                    Text(
                      Helpers.timeAgo(deed.createdAt),
                      style:   TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13.sp,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.favorite_rounded,
                      size: 16.sp,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${deed.likesCount} إعجاب',
                      style:   TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}