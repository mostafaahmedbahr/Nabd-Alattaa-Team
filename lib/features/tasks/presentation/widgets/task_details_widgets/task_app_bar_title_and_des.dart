import '../../../../../common_imports.dart';
import '../../../data/models/task_model.dart';
import 'compact_badge.dart';

class TaskAppBarTitleAndDes extends StatelessWidget {
  const TaskAppBarTitleAndDes({super.key, required this.task});
  final TaskModel task;
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      title:   Text(
        "تفاصيل المهمة",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.sp,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    task.title,
                    style:   TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.3.h,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                    SizedBox(height: 12.h),
                  Row(
                    children: [
                       CompactBadge(
                        text: task.status,
                        color: _statusColor(task.status),
                      ),
                        SizedBox(width: 10.w),
                       CompactBadge(
                        text: task.priority,
                        color: _priorityColor(task.priority),
                      ),
                      const Spacer(),
                      Container(
                        padding:   EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          "${task.completionPercentage}%",
                          style:   TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
Color _priorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case "عالية":
      return Colors.red;
    case "متوسطة":
      return Colors.orange;
    case "منخفضة":
      return Colors.green;
    default:
      return Colors.deepPurple;
  }
}
Color _statusColor(String status) {
  switch (status.toLowerCase()) {
    case "مكتملة":
      return Colors.green;
    case "جاري التنفيذ":
      return Colors.blue;
    case "لم تبدأ":
    case "لم يبدأ":
      return Colors.grey;
    default:
      return AppColors.primary;
  }
}