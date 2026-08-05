import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../view_model/admin_cubit.dart';
import '../view_model/admin_state.dart';
import '../widgets/stat_card.dart';
import '../widgets/employee_card.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<AdminCubit, AdminState>(
        builder: (context, state) {
          if (state is AdminLoading) {
            return const LoadingWidget(message: AppStrings.loading);
          }

          if (state is AdminError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<AdminCubit>().loadDashboard(),
            );
          }

          if (state is DashboardLoaded) {
            return _buildDashboard(state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildDashboard(DashboardLoaded state) {
    return RefreshIndicator(
      onRefresh: () => context.read<AdminCubit>().loadDashboard(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppStrings.statistics,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatisticsGrid(state.statistics),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'الموظفين الأكثر نشاطاً',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to full employees list
                  },
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildTopEmployees(state.topEmployees),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(Map<String, int> stats) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        StatCard(
          title: 'عدد الموظفين',
          value: '${stats['totalEmployees'] ?? 0}',
          icon: Icons.people_outlined,
          color: AppColors.primary,
        ),
        StatCard(
          title: 'عدد المهام',
          value: '${stats['totalTasks'] ?? 0}',
          icon: Icons.task_alt_outlined,
          color: AppColors.info,
        ),
        StatCard(
          title: 'المهام المفتوحة',
          value: '${stats['openTasks'] ?? 0}',
          icon: Icons.pending_actions_outlined,
          color: AppColors.warning,
        ),
        StatCard(
          title: 'البلاغات المفتوحة',
          value: '${stats['openComplaints'] ?? 0}',
          icon: Icons.report_outlined,
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildTopEmployees(List employees) {
    if (employees.isEmpty) {
      return const EmptyStateWidget(
        message: 'لا يوجد موظفين بعد',
        icon: Icons.people_outline,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return EmployeeCard(employee: employees[index]);
      },
    );
  }
}
