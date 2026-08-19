import '../../../../../common_imports.dart';
import '../../view_model/meal_cubit.dart';
import '../../view_model/meal_state.dart';
import 'cart_bottom_sheet.dart';

class MealsHeader extends StatelessWidget {
  const MealsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration:   BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24.r),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 16),
          child: Row(
            children: [
              // الأيقونة
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child:   Icon(
                  Icons.restaurant_menu_outlined,
                  color: AppColors.textWhite,
                  size: 26.sp,
                ),
              ),

                SizedBox(width: 12.w),

              // العنوان
                Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.meals,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textWhite,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'اطلب واختار اللي يعجبك',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 13.sp,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ],
                ),
              ),

              // السلة
              BlocBuilder<MealCubit, MealState>(
                builder: (context, state) {
                  final count =
                      context.read<MealCubit>().cartItems.length;

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
                              constraints:   BoxConstraints(
                                minWidth: 20.w,
                                minHeight: 20.h,
                              ),
                              alignment: Alignment.center,
                              padding:   EdgeInsets.symmetric(
                                horizontal: 5.w,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$count',
                                style:   TextStyle(
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
            ],
          ),
        ),
      ),
    );
  }
}
