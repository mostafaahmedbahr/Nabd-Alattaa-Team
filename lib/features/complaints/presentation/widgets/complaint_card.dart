import '../../../../common_imports.dart';
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
        margin:   EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.grey100, width: 1.w),
          boxShadow: [
            BoxShadow(
              color: _getStatusColor().withValues(alpha: 0.08),
              blurRadius: 20.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24.r),
          child: InkWell(
            borderRadius: BorderRadius.circular(24.r),
            onTap: () {},
            splashColor: _getStatusColor().withValues(alpha: 0.05),
            highlightColor: _getStatusColor().withValues(alpha: 0.03),
            child: Padding(
              padding:   EdgeInsets.all(20.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _buildAvatar(),
                        SizedBox(width: 14.w),
                      Expanded(child: _buildContent()),
                      _buildStatusBadge(),
                    ],
                  ),
                    SizedBox(height: 16.h),
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
      case 'complete':
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
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getStatusColor(),
            _getStatusColor().withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withValues(alpha: 0.3),
            blurRadius: 8.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        _getTypeIcon(),
        color: AppColors.textWhite,
        size: 24.sp,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          complaint.title,
          style:   TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        if (complaint.content.isNotEmpty) ...[
            SizedBox(height: 6.h),
          Text(
            complaint.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style:   TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.5.h,
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
      case 'complete':
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
      padding:   EdgeInsets.symmetric(horizontal: 10.w,
          vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.w,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
            SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11.sp,
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
            size: 14.sp,
            color: AppColors.grey400,
          ),
            SizedBox(width: 6.w),
          Text(
            complaint.isAnonymous ? 'مجهول' : complaint.creatorName,
            style:   TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
            SizedBox(width: 12.w),
          Icon(
            Icons.schedule_rounded,
            size: 14.sp,
            color: AppColors.grey400,
          ),
            SizedBox(width: 4.w),
          Text(
            Helpers.timeAgo(complaint.createdAt),
            style:   TextStyle(
              color: AppColors.textHint,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
