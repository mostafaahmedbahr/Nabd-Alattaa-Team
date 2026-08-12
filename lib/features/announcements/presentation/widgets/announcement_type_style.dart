import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';

IconData announcementTypeIcon(String type) {
  switch (type) {
    case 'meeting':
      return Icons.event_rounded;
    case 'holiday':
      return Icons.beach_access_rounded;
    case 'decision':
      return Icons.gavel_rounded;
    case 'alert':
      return Icons.warning_amber_rounded;
    default:
      return Icons.campaign_rounded;
  }
}

Color announcementTypeColor(String type) {
  switch (type) {
    case 'meeting':
      return AppColors.info;
    case 'holiday':
      return AppColors.secondary;
    case 'decision':
      return AppColors.primary;
    case 'alert':
      return AppColors.warning;
    default:
      return AppColors.primary;
  }
}

String announcementTypeName(String type) {
  switch (type) {
    case 'meeting':
      return 'اجتماع';
    case 'holiday':
      return 'عطلة';
    case 'decision':
      return 'قرار';
    case 'news':
      return 'أخبار';
    case 'alert':
      return 'تنبيه';
    default:
      return 'إعلان';
  }
}

String formatAnnouncementDate(DateTime? date) {
  if (date == null) return '';
  final now = DateTime.now();
  final diff = now.difference(date);
  if (diff.inHours < 1) return 'منذ ${diff.inMinutes} دقيقة';
  if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعات';
  if (diff.inDays < 7) return 'منذ ${diff.inDays} أيام';
  return DateFormat('dd/MM/yyyy').format(date);
}