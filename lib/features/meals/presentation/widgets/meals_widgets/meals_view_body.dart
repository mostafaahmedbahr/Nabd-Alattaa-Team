import '../../../../../common_imports.dart';
import '../../../../../core/constants/firestore_constants.dart';
import '../../../data/models/meal_item_model.dart';
import '../../view_model/meal_cubit.dart';
import '../../view_model/meal_state.dart';
import 'category_chips.dart';
import 'category_list.dart';
import 'chips_header_delegate.dart';
import 'meals_header.dart';

class MealsViewBody extends StatefulWidget {
  const MealsViewBody({super.key});

  @override
  State<MealsViewBody> createState() => _MealsViewBodyState();
}

class _MealsViewBodyState extends State<MealsViewBody> {
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

    debugPrint('--- Meals menu loaded (${items.length} item) ---');
    for (final item in items) {
      debugPrint(
        'Item: id=${item.id} | name=${item.name} | price=${item.price} | '
        'category=${item.category} | available=${item.isAvailable}',
      );
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
    return BlocListener<MealCubit, MealState>(
      listener: (context, state) {
        if (state is MealMenuLoaded) {
          _handleMenuLoaded(state.menuItems);
        }
      },
      child: AdaptiveContainer(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const MealsHeader(),
            SliverPersistentHeader(
              pinned: true,
              delegate: ChipsHeaderDelegate(
                child: CategoryChips(
                  categories: _categories,
                  selectedIndex: _selectedIndex,
                  onChanged: (index) {
                    debugPrint(
                      'Selected category index=$index: ${_categories[index]}',
                    );
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.only(bottom: 96.h),
              sliver: BlocBuilder<MealCubit, MealState>(
                builder: (context, state) {
                  if (state is MealLoading &&
                      context.read<MealCubit>().menuItems.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }

                  if (state is MealError && state.message.contains('فشل')) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: CustomErrorWidget(message: state.message),
                    );
                  }

                  final category =
                      _categories[_selectedIndex.clamp(
                        0,
                        _categories.length - 1,
                      )];
                  return CategoryList(category: category);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
