import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../view_model/meal_cubit.dart';
import '../view_model/meal_state.dart';
import '../widgets/meal_item_card.dart';
import '../widgets/cart_bottom_sheet.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _categories = [
    {'name': 'ساندوتشات', 'key': 'ساندوتشات'},
    {'name': 'فطير', 'key': 'فطير'},
    {'name': 'بيتزا', 'key': 'بيتزا'},
    {'name': 'مشروبات', 'key': 'مشروبات'},
    {'name': 'حلويات', 'key': 'حلويات'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    context.read<MealCubit>().loadMenu();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title:   Text("AppStrings.mealsTitle"),
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: _categories
                .map((cat) => Tab(text: cat['name']))
                .toList(),
          ),
        ),
        body: BlocBuilder<MealCubit, MealState>(
          builder: (context, state) {
            if (state is MealLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MealError) {
              return Center(child: Text(state.message));
            }

            return TabBarView(
              controller: _tabController,
              children: _categories.map((category) {
                return _buildCategoryList(category['key']!);
              }).toList(),
            );
          },
        ),
        floatingActionButton: BlocBuilder<MealCubit, MealState>(
          builder: (context, state) {
            final cubit = context.read<MealCubit>();
            if (cubit.cartItems.isEmpty) {
              return const SizedBox.shrink();
            }
            return FloatingActionButton.extended(
              onPressed: () => _showCartBottomSheet(context),
              icon: const Icon(Icons.shopping_cart),
              label: Text(
                '${cubit.cartItems.length} - السلة',
                style: const TextStyle(fontWeight: FontWeight.bold),
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
          return const Center(
            child: Text(
              'لا توجد وجبات متاحة',
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(8),
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

  void _showCartBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CartBottomSheet(),
    );
  }
}
