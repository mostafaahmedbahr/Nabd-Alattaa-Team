import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants/app_colors.dart';
import '../constants/app_strings.dart';

class Helpers {
  Helpers._();

  static String generateId() => const Uuid().v4();

  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy', 'ar').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy hh:mm a', 'ar').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a', 'ar').format(date);
  }

  static String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  static Color getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return AppColors.priorityHigh;
      case 'medium':
        return AppColors.priorityMedium;
      case 'low':
        return AppColors.priorityLow;
      default:
        return AppColors.grey500;
    }
  }

  static String getPriorityText(String priority) {
    switch (priority) {
      case 'high':
        return AppStrings.high;
      case 'medium':
        return AppStrings.medium;
      case 'low':
        return AppStrings.low;
      default:
        return '';
    }
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case 'not_started':
        return AppColors.taskNotStarted;
      case 'in_progress':
        return AppColors.taskInProgress;
      case 'in_review':
        return AppColors.taskInReview;
      case 'completed':
        return AppColors.taskCompleted;
      case 'late':
        return AppColors.taskLate;
      case 'pending':
        return AppColors.warning;
      case 'resolved':
        return AppColors.success;
      case 'closed':
        return AppColors.grey500;
      case 'open':
        return AppColors.info;
      default:
        return AppColors.grey500;
    }
  }

  static String getStatusText(String status) {
    switch (status) {
      case 'not_started':
        return AppStrings.notStarted;
      case 'in_progress':
        return AppStrings.inProgress;
      case 'in_review':
        return AppStrings.inReview;
      case 'completed':
        return AppColors.success == const Color(0xFF4CAF50)
            ? AppStrings.completed
            : AppStrings.completed;
      case 'late':
        return AppStrings.late;
      case 'pending':
        return AppStrings.pending;
      case 'resolved':
        return AppStrings.approved;
      case 'closed':
        return AppStrings.close;
      case 'open':
        return AppStrings.open;
      default:
        return status;
    }
  }

  static void showSnackBar(BuildContext context, String message,
      {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
