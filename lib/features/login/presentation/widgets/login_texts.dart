import 'package:flutter/cupertino.dart';
import 'package:nabd_alattaa_team/common_imports.dart';

class LoginTexts extends StatelessWidget {
  const LoginTexts({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'تسجيل الدخول',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'أدخل بياناتك للدخول إلى الحساب',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13.sp,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 28.h),
      ],
    );
  }
}
