
import '../../../../common_imports.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 100.w,
              height: 100.h,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Text(
          'نبض العطاء',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 28.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textWhite,
            letterSpacing: 1,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'مرحباً بعودتك',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14.sp,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
