import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  String? _selectedStatus;

  final Map<String?, Color> _statusColors = {
    null: AppColors.primary,
    'not_started': Colors.orange,
    'in_progress': Colors.blue,
    'completed': Colors.green,
  };

  final Map<String?, String> _statusLabels = {
    null: 'عرض الكل',
    'not_started': AppStrings.notStarted,
    'in_progress': AppStrings.inProgress,
    'completed': AppStrings.completed,
  };

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tasks)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-task'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
      body: Column(
        children: [
          // Filter Chips
          SizedBox(
            height: 60,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              scrollDirection: Axis.horizontal,
              itemCount: _statusColors.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = _statusColors.keys.elementAt(index);
                final color = _statusColors[status]!;
                final label = _statusLabels[status]!;
                final isSelected = _selectedStatus == status;

                return ChoiceChip(
                  label: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: color,
                  backgroundColor: color.withValues(alpha: 0.1),
                  side: BorderSide(color: color),
                  onSelected: (_) {
                    setState(() => _selectedStatus = status);
                    context.read<TaskCubit>().loadTasks(status: status);
                  },
                );
              },
            ),
          ),

          // Tasks List
          Expanded(
            child: BlocBuilder<TaskCubit, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is TaskError) {
                  return Center(child: Text(state.message));
                }

                if (state is TaskLoaded) {
                  if (state.tasks.isEmpty) {
                    return const Center(
                      child: Text(AppStrings.noData),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      return TaskCard(task: state.tasks[index]);
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
