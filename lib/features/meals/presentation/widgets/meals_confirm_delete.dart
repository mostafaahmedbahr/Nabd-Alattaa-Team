import '../../../../common_imports.dart';
import '../../data/models/meal_item_model.dart';
import '../view_model/meal_cubit.dart';

void mealsConfirmDelete(MealItemModel item ,BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('حذف الوجبة'),
      content: Text('هل أنت متأكد من حذف "${item.name}"؟'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<MealCubit>().deleteMealItem(item.id);
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          child: const Text('حذف'),
        ),
      ],
    ),
  );
}