import '../../../../common_imports.dart';

class MealsEmptyState extends StatelessWidget {
  const MealsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:   EdgeInsets.all(32.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
              Icon(
              Icons.restaurant_menu_outlined,
              size: 64.sp,
              color: AppColors.grey400,
            ),
              SizedBox(height: 16.h),
              Text(
              'لا توجد وجبات بعد',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
              SizedBox(height: 8.h),
            const Text(
              'اضغط على زر إضافة أكلة لإضافة أول وجبة',
              style: TextStyle(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}
