import 'package:intl/intl.dart';
import '../../../../../common_imports.dart';
import '../../../data/models/task_model.dart';
import 'compact_info_item.dart';
import 'section_title.dart';

class TaskInfoCard extends StatelessWidget {
  final TaskModel task;

  const TaskInfoCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('dd MMM yyyy', 'ar').format(task.dueDate);
    return Card(
      elevation: 0,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding:   EdgeInsets.all(12.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(
              title: "معلومات المهمة",
              icon: Icons.info_outline,
            ),
              SizedBox(height: 14.h),
            Container(
              padding:   EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  CompactInfoItem(
                    icon: Icons.calendar_today_rounded,
                    label: "الموعد",
                    value: date,
                    color: AppColors.primary,
                  ),
                  SizedBox(width: 10.w,),
                  Container(
                    width: 1.w,
                    height: 36.h,
                    color: AppColors.grey200,
                  ),
                  SizedBox(width: 10.w,),
                  CompactInfoItem(
                    icon: Icons.flag_outlined,
                    label: "الحالة",
                    value: task.status,
                    color: _statusColor(task.status),
                  ),
                ],
              ),
            ),
              SizedBox(height: 10.h),
            Container(
              padding:   EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  CompactInfoItem(
                    icon: Icons.priority_high_rounded,
                    label: "الأولوية",
                    value: task.priority,
                    color: _priorityColor(task.priority),
                  ),
                  SizedBox(width: 10.w,),
                  Container(
                    width: 1.w,
                    height: 36.h,
                    color: AppColors.grey200,
                  ),
                  SizedBox(width: 10.w,),
                  CompactInfoItem(
                    icon: Icons.person_outline_rounded,
                    label: "المسؤول",
                    value: task.assigneeName.isNotEmpty
                        ? task.assigneeName
                        : "غير محدد",
                    color: AppColors.info,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
      case "مكتملة":
        return Colors.green;
      case "in_progress":
      case "جاري التنفيذ":
        return Colors.blue;
      case "not_started":
      case "لم تبدأ":
      case "لم يبدأ":
        return Colors.grey;
      default:
        return AppColors.primary;
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case "high":
      case "عالية":
        return Colors.red;
      case "medium":
      case "متوسطة":
        return Colors.orange;
      case "low":
      case "منخفضة":
        return Colors.green;
      default:
        return Colors.deepPurple;
    }
  }
}


