import '../../../../../common_imports.dart';

class TaskBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const TaskBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:   EdgeInsets.symmetric(
        horizontal: 14.w,
        vertical: 8.h,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: color.withValues(alpha: .4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16.sp,
              color: color,
            ),
              SizedBox(width: 6.w),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}