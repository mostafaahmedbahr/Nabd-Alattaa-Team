import '../../../../common_imports.dart';

class ReportsHeader extends StatelessWidget {
  const ReportsHeader({super.key});

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
          'البلاغات',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.reportsGradientStart,
                AppColors.primary,
                AppColors.reportsGradientEnd,
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
                  Icons.report_outlined,
                  size: 48.sp,
                  color: Colors.white24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
