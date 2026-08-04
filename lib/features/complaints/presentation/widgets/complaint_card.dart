import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/helpers.dart';
import '../../data/models/complaint_model.dart';

class ComplaintCard extends StatelessWidget {
  final ComplaintModel complaint;
  final int index;

  const ComplaintCard({
    super.key,
    required this.complaint,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 500 + (index * 80)),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.grey100, width: 1),
          boxShadow: [
            BoxShadow(
              color: _getStatusColor().withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () {},
            splashColor: _getStatusColor().withValues(alpha: 0.05),
            highlightColor: _getStatusColor().withValues(alpha: 0.03),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAvatar(),
                      const SizedBox(width: 14),
                      Expanded(child: _buildContent()),
                      _buildStatusBadge(),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (complaint.status) {
      case 'pending':
        return AppColors.warning;
      case 'in_progress':
        return AppColors.info;
      case 'resolved':
        return AppColors.success;
      default:
        return AppColors.grey500;
    }
  }

  IconData _getTypeIcon() {
    switch (complaint.type) {
      case 'breakdown':
        return Icons.build_rounded;
      case 'printer':
        return Icons.print_rounded;
      case 'internet':
        return Icons.wifi_off_rounded;
      case 'ac':
        return Icons.ac_unit_rounded;
      case 'cleanliness':
        return Icons.cleaning_services_rounded;
      case 'electricity':
        return Icons.bolt_rounded;
      default:
        return Icons.help_outline_rounded;
    }
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor(),
            _getStatusColor().withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        _getTypeIcon(),
        color: AppColors.textWhite,
        size: 24,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          complaint.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        if (complaint.content.isNotEmpty) ...[
          const SizedBox(height: 6),
          Text(
            complaint.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    IconData icon;

    switch (complaint.status) {
      case 'pending':
        color = AppColors.warning;
        text = 'قيد الانتظار';
        icon = Icons.hourglass_empty_rounded;
        break;
      case 'in_progress':
        color = AppColors.info;
        text = 'قيد التنفيذ';
        icon = Icons.autorenew_rounded;
        break;
      case 'resolved':
        color = AppColors.success;
        text = 'تم الحل';
        icon = Icons.check_circle_outline_rounded;
        break;
      default:
        color = AppColors.grey500;
        text = 'مغلق';
        icon = Icons.archive_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            complaint.isAnonymous ? Icons.person_off_rounded : Icons.person_rounded,
            size: 14,
            color: AppColors.grey400,
          ),
          const SizedBox(width: 6),
          Text(
            complaint.isAnonymous ? 'مجهول' : complaint.creatorName,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.schedule_rounded,
            size: 14,
            color: AppColors.grey400,
          ),
          const SizedBox(width: 4),
          Text(
            Helpers.timeAgo(complaint.createdAt),
            style: const TextStyle(
              color: AppColors.textHint,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
