import '../../../../common_imports.dart';

class TitleLabel extends StatelessWidget {
  const TitleLabel({super.key, required this.label});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
