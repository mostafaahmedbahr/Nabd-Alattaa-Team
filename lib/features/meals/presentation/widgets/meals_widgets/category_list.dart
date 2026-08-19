import '../../../../../common_imports.dart';
import '../../view_model/meal_cubit.dart';
import '../../view_model/meal_state.dart';
import '../meal_item_card.dart';
import 'empty_category.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key, required this.category});
  final String category;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MealCubit, MealState>(
      builder: (context, state) {
        final cubit = context.read<MealCubit>();
        final items = cubit.menuItems
            .where((item) => item.category == category && item.isAvailable)
            .toList();

        if (items.isEmpty) {
          return SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyCategory(category : category),
          );
        }

        return SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 96),
          sliver: SliverList.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return MealItemCard(
                item: items[index],
                quantity: cubit.cartItems[items[index].id] ?? 0,
                onAdd: () => cubit.addToCart(items[index].id),
                onRemove: () => cubit.removeFromCart(items[index].id),
              );
            },
          ),
        );
      },
    );
  }
}
