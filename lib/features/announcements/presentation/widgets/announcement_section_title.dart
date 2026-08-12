import '../../../../common_imports.dart';

class AnnouncementSectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const AnnouncementSectionTitle({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 18.r, color: AppColors.primary),
        ),
        SizedBox(width: 10.w),
        Text(
          title,
          style: AppTextStyles.titleCard.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}