import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/library_item_model.dart';

class LibraryItemCard extends StatelessWidget {
  final LibraryItemModel item;
  final VoidCallback? onTap;

  const LibraryItemCard({super.key, required this.item, this.onTap});

  IconData _getCategoryIcon() {
    switch (item.category) {
      case 'logo':
        return Icons.image;
      case 'contracts':
        return Icons.description;
      case 'policies':
        return Icons.policy;
      case 'word':
        return Icons.article;
      case 'excel':
        return Icons.table_chart;
      case 'powerpoint':
        return Icons.slideshow;
      case 'pdf':
        return Icons.picture_as_pdf;
      default:
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Icon(_getCategoryIcon(), color: AppColors.primary),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.open_in_new),
        onTap: onTap,
      ),
    );
  }
}
