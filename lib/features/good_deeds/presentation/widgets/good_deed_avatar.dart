import '../../../../common_imports.dart';

class GoodDeedAvatar extends StatelessWidget {
  const GoodDeedAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary, AppColors.secondaryDark],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child:   Icon(
        Icons.volunteer_activism_rounded,
        color: AppColors.textWhite,
        size: 24.sp,
      ),
    );
  }
}
