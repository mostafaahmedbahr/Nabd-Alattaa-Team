import '../../../../common_imports.dart';
import 'meals_item_dialog.dart';

class MealsFloatingActionButtonWidget extends StatelessWidget {
  const MealsFloatingActionButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => mealsItemDialog(context),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.add_rounded, color: AppColors.textWhite),
      label: const Text(
        'إضافة أكلة',
        style: TextStyle(
          color: AppColors.textWhite,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }



}
