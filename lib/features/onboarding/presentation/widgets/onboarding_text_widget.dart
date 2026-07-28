import '../../../../common_imports.dart';

class OnboardingTextWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;

  const OnboardingTextWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16.sp,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
          SizedBox(height: 8.h),
        Text(
          title,
          style:   TextStyle(
            fontFamily: 'Cairo',
            fontSize: 30.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
          SizedBox(height: 20.h),
        Text(
          description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14.sp,
            height: 1.8.h,
            color: Colors.white.withValues(alpha: 0.75),
          ),
        ),
      ],
    );
  }
}
