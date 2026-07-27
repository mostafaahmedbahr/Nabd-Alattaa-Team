import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildFilterChip(context, 'الكل', null),
                const SizedBox(width: 8),
                _buildFilterChip(context, AppStrings.notStarted, 'not_started'),
                const SizedBox(width: 8),
                _buildFilterChip(context, AppStrings.inProgress, 'in_progress'),
                const SizedBox(width: 8),
                _buildFilterChip(context, AppStrings.completed, 'completed'),
              ],
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

  Widget _buildFilterChip(BuildContext context, String label, String? status) {
    return FilterChip(
      label: Text(label),
      onSelected: (selected) {
        if (selected) {
          context.read<TaskCubit>().loadTasks(status: status);
        }
      },
    );
  }
}
