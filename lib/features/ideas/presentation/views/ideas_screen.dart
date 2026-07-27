import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../view_model/idea_cubit.dart';
import '../view_model/idea_state.dart';
import '../widgets/idea_card.dart';

class IdeasScreen extends StatelessWidget {
  const IdeasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.ideas)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create-idea'),
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
                    if (selected) context.read<IdeaCubit>().loadIdeas();
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('قيد الانتظار'),
                  onSelected: (selected) {
                    if (selected) context.read<IdeaCubit>().loadIdeas(status: 'pending');
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: const Text('مقبولة'),
                  onSelected: (selected) {
                    if (selected) context.read<IdeaCubit>().loadIdeas(status: 'accepted');
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<IdeaCubit, IdeaState>(
              builder: (context, state) {
                if (state is IdeaLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is IdeaError) {
                  return Center(child: Text(state.message));
                }
                if (state is IdeaLoaded) {
                  if (state.ideas.isEmpty) {
                    return const Center(child: Text(AppStrings.noData));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.ideas.length,
                    itemBuilder: (context, index) {
                      return IdeaCard(idea: state.ideas[index]);
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
