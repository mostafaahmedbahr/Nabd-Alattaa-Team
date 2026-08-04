import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/complaint_cubit.dart';
import '../view_model/complaint_state.dart';
import '../widgets/complaint_card.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    context.read<ComplaintCubit>().loadComplaints();
  }

  Color _getChipColor(String filter) {
    switch (filter) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ComplaintCubit, ComplaintState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 160,
                pinned: true,
                stretch: true,
                backgroundColor: AppColors.warning,
                surfaceTintColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text(
                    'الشكاوى والاقتراحات',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color(0xFFF57F17),
                          AppColors.warning,
                          Color(0xFFFFCA28),
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
                            Icons.feedback_outlined,
                            size: 48,
                            color: Colors.white24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
          final cubit = context.read<ComplaintCubit>();
          await context.push('/create-complaint');
          if (mounted) {
            setState(() => _selectedFilter = 'all');
            cubit.loadComplaints();
          }
        },
        backgroundColor: AppColors.warning,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 28),
        label: const Text(
          'شكوى جديدة',
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
          _buildChip('الكل', 'all'),
          const SizedBox(width: 8),
          _buildChip('قيد الانتظار', 'pending'),
          const SizedBox(width: 8),
          _buildChip('قيد التنفيذ', 'in_progress'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String filter) {
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
              context.read<ComplaintCubit>().loadComplaints();
            } else {
              context.read<ComplaintCubit>().loadComplaints(status: filter);
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

  Widget _buildContent(ComplaintState state) {
    if (state is ComplaintLoading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'جاري التحميل...'),
      );
    }
    if (state is ComplaintError) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: state.message,
          onRetry: () => context.read<ComplaintCubit>().loadComplaints(),
        ),
      );
    }
    if (state is ComplaintLoaded) {
      if (state.complaints.isEmpty) {
        return SliverFillRemaining(child: _buildEmptyState());
      }
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        sliver: SliverList.separated(
          itemCount: state.complaints.length,
          separatorBuilder: (_, _) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            return ComplaintCard(
              complaint: state.complaints[index],
              index: index,
            );
          },
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
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
                    AppColors.warning.withValues(alpha: 0.1),
                    AppColors.warning.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: const Icon(
                Icons.feedback_outlined,
                size: 56,
                color: AppColors.warning,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد شكاوى بعد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ابدأ بإرسال شكوى أو اقتراح',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.warning, Color(0xFFFFCA28)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, color: AppColors.textWhite, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'اضغط على + لإرسال شكوى',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.w600,
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
