import '../../../../common_imports.dart';

class VersionText extends StatelessWidget {
  const VersionText({super.key, required this.dotAnimation});
  final    Animation<double>  dotAnimation;
  @override
  Widget build(BuildContext context) {
    return  Positioned(
      bottom: 40.h,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: dotAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: dotAnimation.value * 0.6,
            child:   Text(
              'version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}
