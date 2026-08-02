import '../../../../common_imports.dart';

class MainContent extends StatelessWidget {
    const MainContent({super.key, required this.controller, required this.fadeAnimation, required this.scaleAnimation, required this.slideAnimation, required this.dotAnimation});
  final AnimationController controller;
    final Animation<double>  fadeAnimation;
    final Animation<double>  scaleAnimation;
    final Animation<Offset>  slideAnimation;
    final    Animation<double>  dotAnimation;
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          AnimatedBuilder(
            animation:  controller,
            builder: (context, child) {
              return FadeTransition(
                opacity:  fadeAnimation,
                child: ScaleTransition(
                  scale:  scaleAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10.r),
                      child: Image.asset(
                        AppAssets.logo,
                        width: 120.w,
                        height: 120.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
            SizedBox(height: 30.h),

          // App name
          SlideTransition(
            position:  slideAnimation,
            child: FadeTransition(
              opacity:  fadeAnimation,
              child: Column(
                children: [
                    Text(
                    'مؤسسة نبض العطاء',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                    SizedBox(height: 8.h),
                  Text(
                    'يداً_بيد_عطاءً_ممتد',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16.sp,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
            SizedBox(height: 60.h),

          // Loading dots
          AnimatedBuilder(
            animation:  dotAnimation,
            builder: (context, child) {
              return Opacity(
                opacity:  dotAnimation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return AnimatedContainer(
                      duration: Duration(
                        milliseconds: 300 + (index * 200),
                      ),
                      margin:   EdgeInsets.symmetric(horizontal: 4.w),
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:
                           dotAnimation.value,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
