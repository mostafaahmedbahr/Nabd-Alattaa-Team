import '../../../../common_imports.dart';
import '../../data/models/meal_item_model.dart';
import 'meal_category_style.dart';

class MealItemCard extends StatelessWidget {
  final MealItemModel item;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const MealItemCard({
    super.key,
    required this.item,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final color = mealCategoryColor(item.category);

    return Card(
      margin:   EdgeInsets.symmetric(vertical: 6.h, horizontal: 4.w),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
        side: BorderSide(color: AppColors.grey100),
      ),
      child: Padding(
        padding:   EdgeInsets.all(12.r),
        child: Row(
          children: [
            _buildIcon(color),
              SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style:   TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                    SizedBox(height: 6.h),
                  Container(
                    padding:   EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      '${item.price} ر.س',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildQuantitySelector(color),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    return Container(
      width: 52.w,
      height: 52.h,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Icon(
        mealCategoryIcon(item.category),
        color: color,
        size: 28.sp,
      ),
    );
  }

  Widget _buildQuantitySelector(Color color) {
    if (quantity == 0) {
      return FilledButton.icon(
        onPressed: onAdd,
        icon:   Icon(Icons.add, size: 18.sp),
        label: const Text(
          'أضف',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.textWhite,
          padding:   EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          visualDensity: VisualDensity.compact,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14.r),
      ),
      padding:   EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(
            icon: Icons.add,
            color: color,
            onTap: onAdd,
          ),
          Padding(
            padding:   EdgeInsets.symmetric(horizontal: 10.w),
            child: Text(
              '$quantity',
              style:   TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _stepperButton(
            icon: Icons.remove,
            color: color,
            onTap: onRemove,
          ),
        ],
      ),
    );
  }

  Widget _stepperButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        width: 28.w,
        height: 28.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.textWhite),
      ),
    );
  }
}
