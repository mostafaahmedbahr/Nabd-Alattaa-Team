import '../../../../../common_imports.dart';
import '../meal_category_style.dart';

class EmptyCategory extends StatelessWidget {
  const EmptyCategory({super.key, required this.category});
  final String category;
  @override
  Widget build(BuildContext context) {
    final color = mealCategoryColor(category);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96.w,
            height: 96.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(mealCategoryIcon(category), size: 44.sp, color: color),
          ),
            SizedBox(height: 16.h),
          Text(
            'لا توجد وجبات متاحة في "$category"',
            style:   TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
