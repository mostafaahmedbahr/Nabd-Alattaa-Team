import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';

class MealsCategoryChips extends StatelessWidget {
  const MealsCategoryChips({super.key, required this.selectedCategory, required this.onSelect});
  final   String selectedCategory;
  final void Function(String) onSelect;
  @override
  Widget build(BuildContext context) {
    final categories = MealCategory.all;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = category == selectedCategory;
        return ChoiceChip(
          label: Text(category),
          selected: isSelected,
          onSelected: (_) => onSelect(category),
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          ),
          checkmarkColor: AppColors.textWhite,
        );
      }).toList(),
    );
  }
}
