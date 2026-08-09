import '../../../../common_imports.dart';
import '../../data/models/good_deed_model.dart';

class GoodDeedContentText extends StatelessWidget {
  const GoodDeedContentText({super.key, required this.deed});

  final GoodDeedModel deed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          deed.title.isNotEmpty ? deed.title : deed.content,
          style:   TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),

        if (deed.title.isNotEmpty && deed.content.isNotEmpty) ...[
            SizedBox(height: 6.h),

          Text(
            deed.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:   TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.5.h,
            ),
          ),
        ],
      ],
    );
  }
}
