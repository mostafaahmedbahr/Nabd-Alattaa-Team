
import '../../../../common_imports.dart';

class OnboardingButton extends StatelessWidget {
  final bool isLastPage;
  final VoidCallback onPressed;

  const OnboardingButton({
    super.key,
    required this.isLastPage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.sp,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastPage ? 'ابدأ الآن' : 'التالي',
              style:   TextStyle(
                fontFamily: 'Cairo',
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
              SizedBox(width: 8.w),
            Icon(
              isLastPage
                  ? Icons.rocket_launch_rounded
                  : Icons.arrow_forward_ios_outlined,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
