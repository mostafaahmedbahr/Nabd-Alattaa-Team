import '../../../../common_imports.dart';

class InfoRow extends StatelessWidget {
  const InfoRow(this.icon, this.label, this.value, {super.key,   });
 final IconData? icon;
     final String? label;
         final String? value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: AppColors.primary),
            SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label!,
                  style:   TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
                  SizedBox(height: 2.h),
                Text(
                  value!.isNotEmpty ? value! : '-',
                  style:   TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
