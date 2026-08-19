import '../../../../common_imports.dart';
import '../view_model/meal_cubit.dart';
import '../view_model/meal_state.dart';
import 'meals_empty_state.dart';
import 'meals_grouped_list.dart';
import 'meals_snack_bar.dart';

class ManageMealsViewBody extends StatelessWidget {
  const ManageMealsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MealCubit, MealState>(
      listener: (context, state) {
        if (state is MealItemSaved) {
          mealsShowSnackBar(context, 'تم حفظ الوجبة بنجاح', AppColors.success);
        } else if (state is MealItemDeleted) {
          mealsShowSnackBar(context, 'تم حذف الوجبة', AppColors.success);
        } else if (state is MealError) {
          mealsShowSnackBar(context, state.message, AppColors.error);
        }
      },
      builder: (context, state) {
        final cubit = context.read<MealCubit>();

        if (state is MealLoading && cubit.menuItems.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MealError && state.message.contains('فشل')) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  Icon(
                  Icons.error_outline,
                  size: 56.sp,
                  color: AppColors.error,
                ),
                  SizedBox(height: 12.h),
                Text(state.message, textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                ElevatedButton(
                  onPressed: () => context.read<MealCubit>().loadMenu(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        if (cubit.menuItems.isEmpty) {
          return MealsEmptyState();
        }

        return AdaptiveContainer(child: MealsGroupedList(items:cubit.menuItems));
      },
    );
  }
}
