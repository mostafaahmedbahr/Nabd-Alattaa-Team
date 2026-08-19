import '../../../../common_imports.dart';
import '../../data/models/meal_item_model.dart';
import '../view_model/meal_cubit.dart';
import 'meals_confirm_delete.dart';
import 'meals_item_dialog.dart';

class MealsItemCard extends StatelessWidget {
  const MealsItemCard({super.key, required this.item});
  final MealItemModel item;
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MealCubit>();
    return Card(
      margin:   EdgeInsets.only(bottom: 8.h),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding:   EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: const Icon(
                Icons.fastfood_outlined,
                color: AppColors.primary,
              ),
            ),
              SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style:   TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                    SizedBox(height: 2.h),
                  Text(
                    '${item.price} ر.س',
                    style:   TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.secondaryDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Switch(
                  value: item.isAvailable,
                  onChanged: (_) => cubit.toggleAvailability(item.id),
                  activeTrackColor: AppColors.success,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                Text(
                  item.isAvailable ? 'متاح' : 'غير متاح',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: item.isAvailable
                        ? AppColors.success
                        : AppColors.error,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () => mealsItemDialog(context, item: item),
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppColors.primary,
            ),
            IconButton(
              onPressed: () => mealsConfirmDelete(item, context),
              icon:   Icon(Icons.delete_outline, size: 20.sp),
              color: AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}
