import '../../../../common_imports.dart';

class RegisterLink extends StatelessWidget {
  const RegisterLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'ليس لديك حساب؟ ',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        GestureDetector(
          onTap: () => context.go('/register'),
          child: Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
