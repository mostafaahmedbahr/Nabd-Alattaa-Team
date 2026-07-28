import '../../../../common_imports.dart';

class OnboardingDots extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingDots({
    super.key,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 28.w : 8,
          height: 8.h,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Colors.white
                : Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}
