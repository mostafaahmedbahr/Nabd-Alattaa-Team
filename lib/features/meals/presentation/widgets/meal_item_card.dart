import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
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
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.grey100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildIcon(color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${item.price.toStringAsFixed(0)} ر.س',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13,
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
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        mealCategoryIcon(item.category),
        color: color,
        size: 28,
      ),
    );
  }

  Widget _buildQuantitySelector(Color color) {
    if (quantity == 0) {
      return FilledButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add, size: 18),
        label: const Text(
          'أضف',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color,
          foregroundColor: AppColors.textWhite,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          visualDensity: VisualDensity.compact,
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(
            icon: Icons.add,
            color: color,
            onTap: onAdd,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 16,
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: AppColors.textWhite),
      ),
    );
  }
}
