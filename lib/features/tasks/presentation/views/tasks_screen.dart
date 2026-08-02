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

  final List<Map<String, dynamic>> _statuses = [
    {'key': null, 'label': 'الكل', 'icon': Icons.grid_view_rounded, 'color': AppColors.primary},
    {'key': 'not_started', 'label': AppStrings.notStarted, 'icon': Icons.hourglass_empty_rounded, 'color': AppColors.taskNotStarted},
    {'key': 'in_progress', 'label': AppStrings.inProgress, 'icon': Icons.play_circle_fill_rounded, 'color': AppColors.taskInProgress},
    {'key': 'completed', 'label': AppStrings.completed, 'icon': Icons.check_circle_rounded, 'color': AppColors.taskCompleted},
  ];

  @override
  void initState() {
    super.initState();
    context.read<TaskCubit>().loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          int totalTasks = 0;
          int completedTasks = 0;
          int inProgressTasks = 0;

          if (state is TaskLoaded) {
            totalTasks = state.tasks.length;
            completedTasks = state.tasks.where((t) => t.status == 'مكتملة' || t.status == 'completed').length;
            inProgressTasks = state.tasks.where((t) => t.status == 'جاري التنفيذ' || t.status == 'in_progress').length;
          }

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 220,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                centerTitle: true,
                title: const Text(
                  AppStrings.tasks,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                _StatCard(
                                  icon: Icons.list_alt_rounded,
                                  label: "الكل",
                                  count: totalTasks,
                                ),
                                const SizedBox(width: 10),
                                _StatCard(
                                  icon: Icons.play_circle_fill_rounded,
                                  label: "قيد التنفيذ",
                                  count: inProgressTasks,
                                ),
                                const SizedBox(width: 10),
                                _StatCard(
                                  icon: Icons.check_circle_rounded,
                                  label: "مكتملة",
                                  count: completedTasks,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _statuses.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final status = _statuses[index];
                        final isSelected = _selectedStatus == status['key'];
                        final color = status['color'] as Color;

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedStatus = status['key']);
                            context.read<TaskCubit>().loadTasks(status: status['key']);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected ? color : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? color : AppColors.grey200,
                                width: 1.5,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withOpacity(0.3),
                                        blurRadius: 8,
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
                                  size: 18,
                                  color: isSelected ? Colors.white : color,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  status['label'],
                                  style: TextStyle(
                                    fontSize: 13,
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
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: BlocBuilder<TaskCubit, TaskState>(
                    builder: (context, state) {
                      if (state is TaskLoaded) {
                        return Text(
                          "${state.tasks.length} مهمة",
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.grey500,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ),
              BlocBuilder<TaskCubit, TaskState>(
                builder: (context, state) {
                  if (state is TaskLoading) {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary),
                      ),
                    );
                  }

                  if (state is TaskError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.error.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.error_outline_rounded,
                                  size: 60,
                                  color: AppColors.error,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              FilledButton.icon(
                                onPressed: () => context.read<TaskCubit>().loadTasks(),
                                icon: const Icon(Icons.refresh),
                                label: const Text("إعادة المحاولة"),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is TaskLoaded) {
                    if (state.tasks.isEmpty) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.task_alt_rounded,
                                size: 80,
                                color: AppColors.grey300,
                              ),
                              SizedBox(height: 16),
                              Text(
                                "لا توجد مهام حالياً",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey500,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "ابدأ بإنشاء مهمة جديدة",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.grey400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      sliver: SliverList.separated(
                        itemCount: state.tasks.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          return TaskCard(task: state.tasks[index]);
                        },
                      ),
                    );
                  }

                  return const SliverFillRemaining(child: SizedBox.shrink());
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-task'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, size: 24),
        label: const Text(
          "مهمة جديدة",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 6),
            Text(
              "$count",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
