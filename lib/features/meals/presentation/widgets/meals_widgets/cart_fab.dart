import '../../../../../common_imports.dart';
import '../../view_model/meal_cubit.dart';
import '../../view_model/meal_state.dart';
import 'cart_bottom_sheet.dart';

class CartFab extends StatelessWidget {
  const CartFab({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => showCartBottomSheet(context),
            backgroundColor: AppColors.secondary,
            foregroundColor: AppColors.textWhite,
            elevation: 4,
            icon: const Icon(Icons.shopping_cart),
            label: Text(
              '$count صنف · ${cubit.cartTotal.toStringAsFixed(0)} ر.س',
              style:   TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }
}
