import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

Color mealCategoryColor(String category) {
  switch (category) {
    case 'ساندوتشات':
      return AppColors.warning;
    case 'فطير':
      return AppColors.info;
    case 'بيتزا':
      return AppColors.error;
    case 'إفطار':
      return AppColors.secondary;
    case 'شاورما':
      return AppColors.primary;
    case 'مشويات':
      return AppColors.info;
    case 'مشروبات':
      return AppColors.info;
    case 'حلويات':
      return AppColors.error;
    default:
      return AppColors.primary;
  }
}

IconData mealCategoryIcon(String category) {
  switch (category) {
    case 'ساندوتشات':
      return Icons.lunch_dining_outlined;
    case 'فطير':
      return Icons.cake_outlined;
    case 'بيتزا':
      return Icons.local_pizza_outlined;
    case 'إفطار':
      return Icons.free_breakfast_outlined;
    case 'شاورما':
      return Icons.kebab_dining_outlined;
    case 'مشويات':
      return Icons.outdoor_grill_outlined;
    case 'مشروبات':
      return Icons.local_cafe_outlined;
    case 'حلويات':
      return Icons.icecream_outlined;
    default:
      return Icons.restaurant_menu_outlined;
  }
}
