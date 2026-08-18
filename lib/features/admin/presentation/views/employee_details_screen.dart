import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../users/data/models/user_model.dart';
import '../../data/models/employee_stats_model.dart';
import '../view_model/admin_cubit.dart';
import '../view_model/admin_state.dart';
import '../widgets/admin_dashboard_widgets/stat_card.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final UserModel user;

  const EmployeeDetailsScreen({super.key, required this.user});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadEmployeeStats(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state is AdminSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            context.read<AdminCubit>().loadEmployeeStats(widget.user);
          } else if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const LoadingWidget(message: 'جارٍ التحميل');
          }

          if (state is AdminError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () =>
                  context.read<AdminCubit>().loadEmployeeStats(widget.user),
            );
          }

          if (state is EmployeeStatsLoaded) {
            return _buildDetails(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDetails(EmployeeStatsLoaded state) {
    final user = state.user;
    final stats = state.stats;

    return RefreshIndicator(
      onRefresh: () => context.read<AdminCubit>().loadEmployeeStats(user),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(user, stats),
            const SizedBox(height: 20),
            const Text(
              'الإحصائيات',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                StatCard(
                  title: 'إجمالي المهام',
                  value: '${stats.totalTasks}',
                  icon: Icons.task_alt_outlined,
                  color: AppColors.primary,
                ),
                StatCard(
                  title: 'المهام المكتملة',
                  value: '${stats.completedTasks}',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
                StatCard(
                  title: 'قيد التنفيذ',
                  value: '${stats.inProgressTasks}',
                  icon: Icons.pending_actions_outlined,
                  color: AppColors.warning,
                ),
                StatCard(
                  title: 'المهام المفتوحة',
                  value: '${stats.openTasks}',
                  icon: Icons.assignment_outlined,
                  color: AppColors.info,
                ),
                statCardForCount('الشكاوى', stats.totalComplaints,
                    Icons.report_outlined, AppColors.error),
                statCardForCount('الأفكار', stats.totalIdeas,
                    Icons.lightbulb_outline, AppColors.accent),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'النقاط',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.stars_rounded, color: AppColors.accent),
                  const SizedBox(width: 10),
                  Text(
                    '${stats.points}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accent,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton.icon(
                    onPressed: () => _showAddPointsDialog(context, user),
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة نقاط'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: AppColors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel user, EmployeeStats stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: Text(
              user.name.isNotEmpty ? user.name[0] : '?',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${user.department} • ${user.position}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'حساب مفعل',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              Switch(
                value: stats.isActive,
                onChanged: (value) {
                  context
                      .read<AdminCubit>()
                      .toggleUserActive(user.id ?? '', value);
                },
                activeColor: AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget statCardForCount(
    String title,
    int value,
    IconData icon,
    Color color,
  ) {
    return StatCard(
      title: title,
      value: '$value',
      icon: icon,
      color: color,
    );
  }

  void _showAddPointsDialog(BuildContext context, UserModel user) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('إضافة نقاط'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('إلى: ${user.name}'),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'عدد النقاط',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = int.tryParse(controller.text);
              if (amount == null || amount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('أدخل عدد نقاط صحيح')),
                );
                return;
              }
              Navigator.pop(dialogContext);
              context.read<AdminCubit>().addUserPoints(user.id ?? '', amount);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.textPrimary,
            ),
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
