import '../../../../common_imports.dart';

class CreateGoodDeedHeader extends StatelessWidget {
  const CreateGoodDeedHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return    SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.secondary,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title:   Text(
          'مشاركة عمل خير',
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
                AppColors.secondaryDark,
                AppColors.secondary,
                AppColors.secondaryLight,
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -40.h,
                right: -40.w,
                child: Container(
                  width: 160.w,
                  height: 160.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                bottom: -30.h,
                left: -30.w,
                child: Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
              ),
                Positioned(
                top: 60.h,
                left: 24.w,
                child: Icon(
                  Icons.favorite_outline_rounded,
                  size: 80.sp,
                  color: Colors.white12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
