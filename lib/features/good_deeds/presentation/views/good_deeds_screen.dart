import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../data/models/good_deed_model.dart';
import '../view_model/good_deed_cubit.dart';
import '../view_model/good_deed_state.dart';
import '../widgets/good_deed_card.dart';

class GoodDeedsScreen extends StatefulWidget {
  const GoodDeedsScreen({super.key});

  @override
  State<GoodDeedsScreen> createState() => _GoodDeedsScreenState();
}

class _GoodDeedsScreenState extends State<GoodDeedsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GoodDeedCubit>().loadGoodDeeds();
  }

  void _showDeedDetails(GoodDeedModel deed) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _DeedDetailsBottomSheet(deed: deed),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<GoodDeedCubit, GoodDeedState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<GoodDeedCubit>().loadGoodDeeds();
            },
            color: AppColors.secondary,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 160,
                  pinned: true,
                  stretch: true,
                  backgroundColor: AppColors.secondary,
                  surfaceTintColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'عملت خير',
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
                            AppColors.secondaryDark,
                            AppColors.secondary,
                            AppColors.secondaryLight,
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
                              Icons.favorite_outline_rounded,
                              size: 48,
                              color: Colors.white24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                _buildContent(state),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cubit = context.read<GoodDeedCubit>();
          await context.push(Routes.createGoodDeed);
          if (mounted) {
            cubit.loadGoodDeeds();
          }
        },
        backgroundColor: AppColors.secondary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 28),
        label: const Text(
          'عمل جديد',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(GoodDeedState state) {
    if (state is GoodDeedLoading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'جاري التحميل...'),
      );
    }
    if (state is GoodDeedError) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: state.message,
          onRetry: () => context.read<GoodDeedCubit>().loadGoodDeeds(),
        ),
      );
    }
    if (state is GoodDeedLoaded) {
      if (state.goodDeeds.isEmpty) {
        return SliverFillRemaining(child: _buildEmptyState());
      }
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        sliver: SliverList.separated(
          itemCount: state.goodDeeds.length,
          separatorBuilder: (_, _) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            final deed = state.goodDeeds[index];
            return GoodDeedCard(
              deed: deed,
              index: index,
              isLiked: false,
              onLike: () {
                context.read<GoodDeedCubit>().likeDeed(
                      deed.id,
                      'current_user_id',
                    );
              },
              onTap: () => _showDeedDetails(deed),
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
                    AppColors.secondary.withValues(alpha: 0.1),
                    AppColors.secondary.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: const Icon(
                Icons.favorite_outline_rounded,
                size: 56,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد أعمال خير بعد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'كن أول من يشارك عمل خير',
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
                  colors: [AppColors.secondary, AppColors.secondaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
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
                    'اضغط على + لمشاركة عمل خير',
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

class _DeedDetailsBottomSheet extends StatelessWidget {
  final GoodDeedModel deed;

  const _DeedDetailsBottomSheet({required this.deed});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.error.withValues(alpha: 0.15),
                            AppColors.error.withValues(alpha: 0.08),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        color: AppColors.error,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        deed.title.isNotEmpty ? deed.title : 'عمل خير',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (deed.content.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      deed.content,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textPrimary,
                        height: 1.7,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 16,
                      color: AppColors.grey400,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      Helpers.timeAgo(deed.createdAt),
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.favorite_rounded,
                      size: 16,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${deed.likesCount} إعجاب',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
