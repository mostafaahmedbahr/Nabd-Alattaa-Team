import '../../../../../common_imports.dart';
import '../../../data/models/task_subtask_model.dart';
import 'section_header.dart' show SectionHeader;

class SubtasksInput extends StatefulWidget {
  final List<TaskSubtask> subtasks;
  final void Function(String title) onAdd;
  final void Function(String id, String title) onUpdate;
  final void Function(String id) onRemove;
  final void Function(String id) onToggle;
  final void Function(int oldIndex, int newIndex) onReorder;

  const SubtasksInput({
    super.key,
    required this.subtasks,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
    required this.onToggle,
    required this.onReorder,
  });

  @override
  State<SubtasksInput> createState() => _SubtasksInputState();
}

class _SubtasksInputState extends State<SubtasksInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onAdd(text);
    _controller.clear();
  }

  void _showEditDialog(TaskSubtask subtask) {
    final editController = TextEditingController(text: subtask.title);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل المهمة الفرعية'),
        content: TextField(
          controller: editController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'عنوان المهمة الفرعية',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            final t = editController.text.trim();
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
              final t = editController.text.trim();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'المهام الفرعية',
          icon: Icons.checklist_rounded,
        ),
        SizedBox(height: 14.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.add_task_rounded, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'أضف مهمة فرعية...',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
              TextButton(
                onPressed: _submit,
                child: const Text('إضافة'),
              ),
              const SizedBox(width: 6),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        if (widget.subtasks.isEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            child: Text(
              'لا توجد مهام فرعية بعد',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.grey400,
              ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.subtasks.length,
            onReorder: widget.onReorder,
            itemBuilder: (context, index) {
              final subtask = widget.subtasks[index];
              return Container(
                key: ValueKey(subtask.id),
                margin: EdgeInsets.only(bottom: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.grey100),
                ),
                child: ListTile(
                  leading: ReorderableDragStartListener(
                    index: index,
                    child: const Icon(Icons.drag_handle, color: AppColors.grey400),
                  ),
                  title: Text(
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
                  trailing: Row(
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
                        onPressed: () => widget.onRemove(subtask.id),
                      ),
                    ],
                  ),
                  onTap: () => widget.onToggle(subtask.id),
                ),
              );
            },
          ),
      ],
    );
  }
}
