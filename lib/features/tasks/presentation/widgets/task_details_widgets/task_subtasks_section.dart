import '../../../../../common_imports.dart';
import '../../../data/models/task_subtask_model.dart';

class TaskSubtasksSection extends StatefulWidget {
  final List<TaskSubtask> subtasks;
  final String currentUserId;
  final void Function(String subtaskId, bool isCompleted) onToggle;
  final void Function(String subtaskId, String title) onUpdate;
  final void Function(String subtaskId) onDelete;

  const TaskSubtasksSection({
    super.key,
    required this.subtasks,
    required this.currentUserId,
    required this.onToggle,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<TaskSubtasksSection> createState() => _TaskSubtasksSectionState();
}

class _TaskSubtasksSectionState extends State<TaskSubtasksSection> {
  void _showEditDialog(TaskSubtask subtask) {
    final controller = TextEditingController(text: subtask.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل المهمة الفرعية'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'عنوان المهمة الفرعية',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            final t = controller.text.trim();
            if (t.isNotEmpty) widget.onUpdate(subtask.id, t);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final t = controller.text.trim();
              if (t.isNotEmpty) widget.onUpdate(subtask.id, t);
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.subtasks.isEmpty) return const SizedBox.shrink();

    final done = widget.subtasks.where((s) => s.isCompleted).length;
    final total = widget.subtasks.length;
    final percent = total == 0 ? 0 : ((done / total) * 100).round();

    return Card(
      elevation: 0,
      shadowColor: Colors.black12,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.r),
        side: BorderSide(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.checklist_rounded, color: AppColors.primary),
                SizedBox(width: 8.w),
                const Text(
                  'المهام الفرعية',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                // const Spacer(),
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                //   decoration: BoxDecoration(
                //     color: AppColors.primary.withValues(alpha: 0.1),
                //     borderRadius: BorderRadius.circular(20.r),
                //   ),
                //   child: Text(
                //     '$percent%',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 14.sp,
                //       color: AppColors.primary,
                //     ),
                //   ),
                // ),
              ],
            ),
            // SizedBox(height: 12.h),
            // LinearProgressIndicator(
            //   value: percent / 100,
            //   minHeight: 6.h,
            //   backgroundColor: AppColors.grey100,
            //   valueColor: AlwaysStoppedAnimation<Color>(
            //     percent == 100 ? AppColors.success : AppColors.primary,
            //   ),
            // ),
            SizedBox(height: 14.h),
            ...widget.subtasks.map((subtask) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: subtask.isCompleted
                      ? AppColors.success.withValues(alpha: 0.05)
                      : AppColors.grey50,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: subtask.isCompleted
                        ? AppColors.success.withValues(alpha: 0.25)
                        : AppColors.grey100,
                  ),
                ),
                child: CheckboxListTile(
                  value: subtask.isCompleted,
                  onChanged: (value) =>
                      widget.onToggle(subtask.id, value ?? false),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subtask.title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          decoration: subtask.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: subtask.isCompleted
                              ? AppColors.grey400
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (subtask.description != null &&
                          subtask.description!.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            subtask.description!,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.grey400,
                              decoration: subtask.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
                  secondary: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: AppColors.grey400,
                        onPressed: () => _showEditDialog(subtask),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        color: AppColors.error,
                        onPressed: () {
                          final isLast = widget.subtasks.length == 1;
                          showDialog(
                            context: context,
                            builder: (ctx) => Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: AppColors.error.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.delete_outline_rounded,
                                        color: AppColors.error,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      isLast ? 'حذف المهمة بالكامل' : 'حذف المهمة الفرعية',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isLast
                                          ? 'هذه المهمة الفرعية الوحيدة. حذفها سيؤدي لحذف المهمة بالكامل. هل أنت متأكد؟'
                                          : 'هل أنت متأكد من حذف هذه المهمة الفرعية؟',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 14,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            style: TextButton.styleFrom(
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                                side: const BorderSide(color: AppColors.grey300),
                                              ),
                                            ),
                                            child: const Text(
                                              'إلغاء',
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                color: AppColors.textPrimary,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              widget.onDelete(subtask.id);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.error,
                                              foregroundColor: Colors.white,
                                              padding: const EdgeInsets.symmetric(vertical: 12),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              elevation: 0,
                                            ),
                                            child: const Text(
                                              'حذف',
                                              style: TextStyle(
                                                fontFamily: 'Cairo',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
