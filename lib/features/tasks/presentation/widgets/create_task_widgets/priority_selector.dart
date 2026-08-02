import '../../../../../common_imports.dart';

class PrioritySelector extends StatefulWidget {
    PrioritySelector({super.key, required this.selectedPriority});
  String selectedPriority;
  @override
  State<PrioritySelector> createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {
  @override
  Widget build(BuildContext context) {
    final priorities = [
      ('عالية', AppColors.priorityHigh, Icons.keyboard_arrow_up_rounded),
      ('متوسطة', AppColors.priorityMedium, Icons.remove_rounded),
      ('منخفضة', AppColors.priorityLow, Icons.keyboard_arrow_down_rounded),
    ];
    return Row(
      children: priorities.map((p) {
        final isSelected = widget.selectedPriority == p.$1;
        final color = p.$2;

        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => widget.selectedPriority = p.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin:   EdgeInsets.symmetric(horizontal: 4.w),
              padding:   EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.1) : Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: isSelected ? color : AppColors.grey200,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.15),
                    blurRadius: 8.r,
                    offset: const Offset(0, 3),
                  ),
                ]
                    : null,
              ),
              child: Column(
                children: [
                  Icon(
                    p.$3,
                    size: 26.sp,
                    color: isSelected ? color : AppColors.grey400,
                  ),
                    SizedBox(height: 6.h),
                  Text(
                    p.$1,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? color : AppColors.grey500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
