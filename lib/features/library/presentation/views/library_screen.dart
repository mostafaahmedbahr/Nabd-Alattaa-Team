import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/library_cubit.dart';
import '../view_model/library_state.dart';
import '../widgets/library_item_card.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _selectedCategory = '';

  static const _categories = [
    ('الكل', ''),
    ('اللوجو', 'logo'),
    ('العقود', 'contracts'),
    ('السياسات', 'policies'),
    ('Word', 'word'),
    ('Excel', 'excel'),
    ('PDF', 'pdf'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<LibraryCubit>().loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<LibraryCubit, LibraryState>(
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
                    AppStrings.library,
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
                          right: -30,
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
                          left: -20,
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
                          left: 20,
                          child: Icon(
                            Icons.library_books_outlined,
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
          final cubit = context.read<LibraryCubit>();
          await context.push(Routes.createLibraryItem);
          if (mounted) {
            setState(() => _selectedCategory = '');
            cubit.loadItems();
          }
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 28),
        label: const Text(
          'إضافة رابط',
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((c) {
            final label = c.$1;
            final category = c.$2;
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: _buildCategoryChip(label, category),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildContent(LibraryState state) {
    if (state is LibraryLoading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'جاري التحميل...'),
      );
    }
    if (state is LibraryError) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: state.message,
          onRetry: () => context.read<LibraryCubit>().loadItems(),
        ),
      );
    }
    if (state is LibraryLoaded) {
      if (state.items.isEmpty) {
        return SliverFillRemaining(child: _buildEmptyState());
      }
      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        sliver: SliverList.separated(
          itemCount: state.items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 4),
          itemBuilder: (context, index) {
            return LibraryItemCard(
              item: state.items[index],
              index: index,
              onTap: () async {
                final url = Uri.parse(state.items[index].fileUrl);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
            );
          },
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  Widget _buildCategoryChip(String label, String category) {
    final isSelected = _selectedCategory == category;
    final color = _getCategoryColor(category);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() => _selectedCategory = category);
            if (category.isEmpty) {
              context.read<LibraryCubit>().loadItems();
            } else {
              context.read<LibraryCubit>().loadItemsByCategory(category);
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

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'logo':
        return AppColors.info;
      case 'contracts':
        return AppColors.primary;
      case 'policies':
        return AppColors.warning;
      case 'word':
        return AppColors.info;
      case 'excel':
        return AppColors.secondary;
      case 'pdf':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
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
                Icons.library_books_outlined,
                size: 56,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'لا توجد روابط بعد',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'ابدأ بإضافة الروابط المهمة لفريقك',
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
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
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
                    'اضغط على + لإضافة رابط',
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
