import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../view_model/task_cubit.dart';

class TasksFilterSection extends StatefulWidget {
  const TasksFilterSection({
    super.key,
    required this.statuses,
    this.initialStatus,
    this.onStatusChanged,
  });

  final List<Map<String, dynamic>> statuses;
  final String? initialStatus;
  final ValueChanged<String?>? onStatusChanged;

  @override
  State<TasksFilterSection> createState() => _TasksFilterSectionState();
}

class _TasksFilterSectionState extends State<TasksFilterSection> {
  late String? _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialStatus;
  }

  @override
  void didUpdateWidget(covariant TasksFilterSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialStatus != widget.initialStatus) {
      _selected = widget.initialStatus;
    }
  }

  void _onTap(String? key) {
    if (_selected == key) return;
    setState(() => _selected = key);
    widget.onStatusChanged?.call(key);
    context.read<TaskCubit>().loadTasks(status: key);
  }

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
            separatorBuilder: (_, __) => SizedBox(width: 8.w),
            itemBuilder: (context, index) {
              final status = widget.statuses[index];
              final statusKey = status['key'] as String?;
              final isSelected = _selected == statusKey;
              final color = status['color'] as Color;

              return GestureDetector(
                onTap: () => _onTap(statusKey),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
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
