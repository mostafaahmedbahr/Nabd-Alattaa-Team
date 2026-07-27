import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_model/complaint_cubit.dart';
import '../view_model/complaint_state.dart';
import '../widgets/complaint_card.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.complaints)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-complaint'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.textWhite),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('الكل'),
                  onSelected: (selected) {
                    if (selected) {
                      context.read<ComplaintCubit>().loadComplaints();
                    }
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('قيد الانتظار'),
                  onSelected: (selected) {
                    if (selected) {
                      context.read<ComplaintCubit>().loadComplaints(status: 'pending');
                    }
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('قيد التنفيذ'),
                  onSelected: (selected) {
                    if (selected) {
                      context.read<ComplaintCubit>().loadComplaints(status: 'in_progress');
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<ComplaintCubit, ComplaintState>(
              builder: (context, state) {
                if (state is ComplaintLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ComplaintError) {
                  return Center(child: Text(state.message));
                }
                if (state is ComplaintLoaded) {
                  if (state.complaints.isEmpty) {
                    return const Center(child: Text(AppStrings.noData));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.complaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintCard(complaint: state.complaints[index]);
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
