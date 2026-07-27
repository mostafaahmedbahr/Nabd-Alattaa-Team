import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_model/report_cubit.dart';
import '../view_model/report_state.dart';
import '../widgets/report_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.reports)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-report'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('الكل'),
                    onSelected: (selected) {
                      if (selected) context.read<ReportCubit>().loadReports();
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('مفتوح'),
                    onSelected: (selected) {
                      if (selected) context.read<ReportCubit>().loadReports(status: 'open');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('قيد التنفيذ'),
                    onSelected: (selected) {
                      if (selected) context.read<ReportCubit>().loadReports(status: 'in_progress');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ReportCubit, ReportState>(
              builder: (context, state) {
                if (state is ReportLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ReportError) {
                  return Center(child: Text(state.message));
                }
                if (state is ReportLoaded) {
                  if (state.reports.isEmpty) {
                    return const Center(child: Text(AppStrings.noData));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.reports.length,
                    itemBuilder: (context, index) {
                      return ReportCard(report: state.reports[index]);
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
