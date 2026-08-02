
import '../../../../../common_imports.dart';
import 'section_title.dart';

class TaskProgressCard extends StatelessWidget {
  final double percentage;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const TaskProgressCard({
    super.key,
    required this.percentage,
    required this.onChanged,
    required this.onChangeEnd,
  });

  Color get _progressColor {
    if (percentage >= 100) {
      return AppColors.success;
    } else if (percentage >= 70) {
      return AppColors.secondary;
    } else if (percentage >= 40) {
      return AppColors.warning;
    }
    return AppColors.error;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding:   EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const SectionTitle(
                  title: "نسبة الإنجاز",
                  icon: Icons.analytics_outlined,
                ),
                const Spacer(),
                Container(
                  padding:   EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: _progressColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    "${percentage.round()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                      color: _progressColor,
                    ),
                  ),
                ),
              ],
            ),
              SizedBox(height: 12.h),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: _progressColor,
                thumbColor: _progressColor,
                overlayColor: _progressColor.withValues(alpha: .15),
                inactiveTrackColor: AppColors.grey200,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 8,
                ),
                overlayShape: const RoundSliderOverlayShape(
                  overlayRadius: 18,
                ),
                trackHeight: 4.h,
              ),
              child: Slider(
                value: percentage,
                min: 0,
                max: 100,
                divisions: 20,
                label: "${percentage.round()}%",
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
