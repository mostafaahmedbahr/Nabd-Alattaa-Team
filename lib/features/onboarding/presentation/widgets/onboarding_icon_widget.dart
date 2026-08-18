import 'dart:math' as math;

import '../../../../common_imports.dart';

class OnboardingIconWidget extends StatelessWidget {
  final IconData icon;
  final double size;

  const OnboardingIconWidget({super.key, required this.icon, this.size = 0.5});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final base = math.min(screenWidth * size, 240.0);

    return SizedBox(
      width: base,
      height: base,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: base,
            height: base,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 2.w,
              ),
            ),
          ),
          Container(
            width: base * 0.76,
            height: base * 0.76,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Container(
            width: base * 0.56,
            height: base * 0.56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30.r,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, size: base * 0.4, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
