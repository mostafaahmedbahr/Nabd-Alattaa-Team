import '../../../../common_imports.dart';
import '../../data/models/meal_item_model.dart';
import 'meals_item_card.dart';

class MealsGroupedList extends StatelessWidget {
  const MealsGroupedList({super.key, required this.items});
  final List<MealItemModel> items;
  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<MealItemModel>>{};
    for (final item in items) {
      grouped.putIfAbsent(item.category, () => []).add(item);
    }

    final categories = grouped.keys.toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 88),
      children: [
        for (final category in categories) ...[
          Padding(
            padding:   EdgeInsets.symmetric(vertical: 8.h),
            child: Row(
              children: [
                  Icon(
                  Icons.category_outlined,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
                  SizedBox(width: 8.w),
                Text(
                  category.isEmpty ? 'بدون قسم' : category,
                  style:   TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                  SizedBox(width: 8.w),
                Text(
                  '(${grouped[category]!.length})',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          for (final item in grouped[category]!) MealsItemCard(item:item),
        ],
      ],
    );
  }
}
