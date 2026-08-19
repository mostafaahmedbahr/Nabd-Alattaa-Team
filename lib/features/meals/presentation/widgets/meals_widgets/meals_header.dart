import '../../../../../common_imports.dart';
import '../../view_model/meal_cubit.dart';
import '../../view_model/meal_state.dart';
import 'cart_bottom_sheet.dart';

class MealsHeader extends StatelessWidget {
  const MealsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 160,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          AppStrings.meals,
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30.h,
                left: -30.w,
                child: Container(
                  width: 140.w,
                  height: 140.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -20.h,
                right: -20.w,
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
              Positioned(
                bottom: 20.h,
                right: 20.w,
                child: Icon(
                  Icons.restaurant_menu_outlined,
                  size: 48.sp,
                  color: Colors.white24,
                ),
              ),
              Positioned(
                bottom: 18.h,
                left: 24.w,
                child: Text(
                  'اطلب واختار اللي يعجبك',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 13.sp,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(left: 8.w),
          child: BlocBuilder<MealCubit, MealState>(
            builder: (context, state) {
              final count = context.read<MealCubit>().cartItems.length;

              return IconButton(
                onPressed: () => showCartBottomSheet(context),
                padding: EdgeInsets.zero,
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.textWhite,
                      size: 27.sp,
                    ),
                    if (count > 0)
                      Positioned(
                        top: -8.h,
                        right: -8.w,
                        child: Container(
                          constraints: BoxConstraints(
                            minWidth: 20.w,
                            minHeight: 20.h,
                          ),
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$count',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 11.sp,
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
        ),
      ],
    );
  }
}
