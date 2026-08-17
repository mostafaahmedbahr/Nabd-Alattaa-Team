import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/idea_cubit.dart';
import '../view_model/idea_state.dart';
import '../widgets/idea_card.dart';

class IdeasScreen extends StatefulWidget {
  const IdeasScreen({super.key});

  @override
  State<IdeasScreen> createState() => _IdeasScreenState();
}

class _IdeasScreenState extends State<IdeasScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<IdeaCubit>().loadIdeas();
  }

  Color _getChipColor(String filter) {
    switch (filter) {
      case 'accepted':
        return AppColors.secondary;
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<IdeaCubit, IdeaState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.primary,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    AppStrings.ideas,
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          AppColors.primaryDark,
                          AppColors.primary,
                          AppColors.primaryLight,
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: -30,
                          left: -30,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.08),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          right: -20,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.06),
                            ),
                          ),
                        ),
                        const Positioned(
                          bottom: 20,
                          right: 20,
                          child: Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 48,
                            color: Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  const SizedBox(width: 8),
                ],
              ),
              SliverPersistentHeader(
                pinned: false,
                delegate: _FilterChipsDelegate(
                  child: _buildFilterChips(),
                ),
              ),
              _buildContent(state),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cubit = context.read<IdeaCubit>();
          await context.push('/create-idea');
          if (mounted) {
            setState(() => _selectedFilter = 'all');
            cubit.loadIdeas();
          }
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 28),
        label: const Text(
          'فكرة جديدة',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _buildFilterChip('الكل', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('قيد الانتظار', 'pending'),
          const SizedBox(width: 8),
          _buildFilterChip('مقبولة', 'accepted'),
        ],
      ),
    );
  }

  Widget _buildContent(IdeaState state) {
    if (state is IdeaLoading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'جاري التحميل...'),
      );
    }
    if (state is IdeaError) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: state.message,
          onRetry: () => context.read<IdeaCubit>().loadIdeas(),
        ),
      );
    }
    if (state is IdeaLoaded) {
      if (state.ideas.isEmpty) {
        return SliverFillRemaining(child: _buildEmptyState());
      }
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        sliver: SliverList.separated(
          itemCount: state.ideas.length,
          separatorBuilder: (_, _) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            return IdeaCard(
              idea: state.ideas[index],
              index: index,
            );
          },
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildFilterChip(String label, String filter) {
    final isSelected = _selectedFilter == filter;
    final color = _getChipColor(filter);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedFilter = filter);
            if (filter == 'all') {
              context.read<IdeaCubit>().loadIdeas();
            } else {
              context.read<IdeaCubit>().loadIdeas(status: filter);
            }
          }
        },
        selectedColor: color,
        backgroundColor: AppColors.surface,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 13,
        ),
        checkmarkColor: AppColors.textWhite,
        side: BorderSide(
          color: isSelected ? color : AppColors.border,
          width: isSelected ? 0 : 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: const Icon(
                Icons.lightbulb_outline_rounded,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد أفكار بعد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'كن أول من يشارك فكرة جديدة',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChipsDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FilterChipsDelegate({required this.child});

  @override
  double get minExtent => 65;

  @override
  double get maxExtent => 65;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _FilterChipsDelegate oldDelegate) => false;
}
