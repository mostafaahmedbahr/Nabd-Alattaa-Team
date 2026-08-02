import '../../../../../common_imports.dart';
import '../../view_model/task_cubit.dart';

class TasksFilterSection extends StatefulWidget {
    TasksFilterSection({
    super.key,
    required this.statuses,
    required this.selectedStatus,
  });

  final List<Map<String, dynamic>> statuses;
  String selectedStatus;

  @override
  State<TasksFilterSection> createState() => _TasksFilterSectionState();
}

class _TasksFilterSectionState extends State<TasksFilterSection> {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: SizedBox(
          height: 44.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.statuses.length,
            separatorBuilder: (_, __) =>   SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final status = widget.statuses[index];
              final isSelected = widget.selectedStatus == status['key'];
              final color = status['color'] as Color;

              return GestureDetector(
                onTap: () {
                  setState(() => widget.selectedStatus = status['key']);
                  context.read<TaskCubit>().loadTasks(status: status['key']);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:   EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: isSelected ? color : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected ? color : AppColors.grey200,
                      width: 1.5.w,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 8.r,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        status['icon'],
                        size: 18.sp,
                        color: isSelected ? Colors.white : color,
                      ),
                        SizedBox(width: 8.w),
                      Text(
                        status['label'],
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : AppColors.grey600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
