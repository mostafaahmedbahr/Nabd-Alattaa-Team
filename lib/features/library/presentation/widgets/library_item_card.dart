import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/library_item_model.dart';

class LibraryItemCard extends StatelessWidget {
  final LibraryItemModel item;
  final VoidCallback? onTap;
  final int index;

  const LibraryItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.index = 0,
  });

  IconData _getCategoryIcon() {
    switch (item.category) {
      case 'logo':
        return Icons.image_rounded;
      case 'contracts':
        return Icons.description_rounded;
      case 'policies':
        return Icons.policy_rounded;
      case 'word':
        return Icons.article_rounded;
      case 'excel':
        return Icons.table_chart_rounded;
      case 'powerpoint':
        return Icons.slideshow_rounded;
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      default:
        return Icons.folder_rounded;
    }
  }

  String _getCategoryLabel() {
    switch (item.category) {
      case 'logo':
        return 'لوجو';
      case 'contracts':
        return 'عقود';
      case 'policies':
        return 'سياسات';
      case 'word':
        return 'Word';
      case 'excel':
        return 'Excel';
      case 'pdf':
        return 'PDF';
      default:
        return 'عام';
    }
  }

  Color _getCategoryColor() {
    switch (item.category) {
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

  List<Color> _getGradientColors() {
    final color = _getCategoryColor();
    return [color, color.withValues(alpha: 0.6)];
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor();

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 400 + (index * 100)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    gradient: LinearGradient(colors: _getGradientColors()),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              categoryColor.withValues(alpha: 0.15),
                              categoryColor.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          _getCategoryIcon(),
                          size: 28,
                          color: categoryColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                            if (item.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                item.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: categoryColor.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: categoryColor.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: Text(
                                    _getCategoryLabel(),
                                    style: TextStyle(
                                      color: categoryColor,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  Icons.access_time_rounded,
                                  size: 12,
                                  color: AppColors.grey400,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  Helpers.timeAgo(item.createdAt),
                                  style: const TextStyle(
                                    color: AppColors.textHint,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.open_in_new_rounded,
                          size: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
