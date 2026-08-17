import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common_imports.dart';
import '../../../data/models/task_subtask_model.dart';

class MultipleTasksInput extends StatefulWidget {
  final List<TaskSubtask> items;
  final void Function(String title, String description) onAdd;
  final void Function(TaskSubtask updated) onUpdate;
  final void Function(String id) onRemove;
  final void Function(int oldIndex, int newIndex) onReorder;

  const MultipleTasksInput({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onUpdate,
    required this.onRemove,
    required this.onReorder,
  });

  @override
  State<MultipleTasksInput> createState() => _MultipleTasksInputState();
}

class _MultipleTasksInputState extends State<MultipleTasksInput> {
  void _submit() {
    widget.onAdd('', '');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المهام (${widget.items.length})',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.add_circle_outline, size: 18),
              label: const Text('إضافة مهمة'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        if (widget.items.isEmpty)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18.h),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.grey100),
            ),
            child: const Center(
              child: Text(
                'اضغط "إضافة مهمة" لإضافة عنصر جديد',
                style: TextStyle(color: AppColors.grey400),
              ),
            ),
          )
        else
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.items.length,
            onReorder: widget.onReorder,
            itemBuilder: (context, index) {
              final item = widget.items[index];
              return _MultipleTaskRow(
                key: ValueKey(item.id),
                item: item,
                index: index,
                onUpdate: widget.onUpdate,
                onRemove: widget.onRemove,
              );
            },
          ),
      ],
    );
  }
}

class _MultipleTaskRow extends StatefulWidget {
  final TaskSubtask item;
  final int index;
  final void Function(TaskSubtask updated) onUpdate;
  final void Function(String id) onRemove;

  const _MultipleTaskRow({
    super.key,
    required this.item,
    required this.index,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  State<_MultipleTaskRow> createState() => _MultipleTaskRowState();
}

class _MultipleTaskRowState extends State<_MultipleTaskRow> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title);
    _descController = TextEditingController(text: widget.item.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey(widget.item.id),
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Column(
        children: [
          Row(
            children: [
              ReorderableDragStartListener(
                index: widget.index,
                child: const Icon(Icons.drag_handle, color: AppColors.grey400),
              ),
              SizedBox(width: 8.w),
              CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  '${widget.index + 1}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 18),
                color: AppColors.error,
                onPressed: () => widget.onRemove(widget.item.id),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'عنوان المهمة',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) =>
                widget.onUpdate(widget.item.copyWith(title: value)),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: _descController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: 'وصف المهمة (اختياري)',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) =>
                widget.onUpdate(widget.item.copyWith(description: value)),
          ),
        ],
      ),
    );
  }
}
