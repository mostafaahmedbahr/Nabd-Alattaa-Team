import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../data/models/meal_item_model.dart';
import '../view_model/meal_cubit.dart';
import '../view_model/meal_state.dart';
import '../widgets/cart_bottom_sheet.dart';
import '../widgets/meal_category_style.dart';
import '../widgets/meal_item_card.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List<String> _categories = MealCategory.all;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<MealCubit>().loadMenu();
  }

  void _handleMenuLoaded(List<MealItemModel> items) {
    final categories = <String>[...MealCategory.all];
    for (final item in items) {
      if (item.category.isNotEmpty && !categories.contains(item.category)) {
        categories.add(item.category);
      }
    }

    setState(() {
      _categories = categories;
      if (_selectedIndex >= _categories.length) {
        _selectedIndex = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(),
        body: BlocListener<MealCubit, MealState>(
          listener: (context, state) {
            if (state is MealMenuLoaded) {
              _handleMenuLoaded(state.menuItems);
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildCategoryChips(),
                Expanded(
                  child: BlocBuilder<MealCubit, MealState>(
                    builder: (context, state) {
                      if (state is MealLoading &&
                          context.read<MealCubit>().menuItems.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      if (state is MealError &&
                          state.message.contains('فشل')) {
                        return _buildError(state.message);
                      }

                      final category = _categories[
                          _selectedIndex.clamp(0, _categories.length - 1)];
                      return _buildCategoryList(category);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildCartFab(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [AppColors.primaryDark, AppColors.primary, AppColors.primaryLight],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.restaurant_menu_outlined,
                color: AppColors.textWhite,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.meals,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'اطلب واختار اللي يعجبك',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ),
            BlocBuilder<MealCubit, MealState>(
              builder: (context, state) {
                final count = context.read<MealCubit>().cartItems.length;
                return IconButton(
                  onPressed: () => _showCartBottomSheet(context),
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.textWhite,
                        size: 26,
                      ),
                      if (count > 0)
                        Positioned(
                          left: -6,
                          bottom: -2,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$count',
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textWhite,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _categories.length,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = index == _selectedIndex;
            final color = mealCategoryColor(category);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: isSelected ? color : AppColors.surface,
                borderRadius: BorderRadius.circular(19),
                border: Border.all(
                  color: isSelected ? color : AppColors.grey300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(19),
                  onTap: () => setState(() => _selectedIndex = index),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          mealCategoryIcon(category),
                          size: 16,
                          color: isSelected
                              ? AppColors.textWhite
                              : color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.textWhite
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryList(String category) {
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        final cubit = context.read<MealCubit>();
        final items = cubit.menuItems
            .where((item) => item.category == category && item.isAvailable)
            .toList();

        if (items.isEmpty) {
          return _buildEmptyCategory(category);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return MealItemCard(
              item: items[index],
              quantity: cubit.cartItems[items[index].id] ?? 0,
              onAdd: () => cubit.addToCart(items[index].id),
              onRemove: () => cubit.removeFromCart(items[index].id),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyCategory(String category) {
    final color = mealCategoryColor(category);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              mealCategoryIcon(category),
              size: 44,
              color: color,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد وجبات متاحة في "$category"',
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => context.read<MealCubit>().loadMenu(),
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartFab() {
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        final cubit = context.read<MealCubit>();
        final count = cubit.cartItems.values.fold<int>(0, (sum, q) => sum + q);

        if (count == 0) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: FloatingActionButton.extended(
            onPressed: () => _showCartBottomSheet(context),
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textWhite,
            elevation: 4,
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              '$count صنف · ${cubit.cartTotal.toStringAsFixed(0)} ر.س',
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CartBottomSheet(),
    );
  }
}
