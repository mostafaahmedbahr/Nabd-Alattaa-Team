


import '../../../../../common_imports.dart';

class AdminDashboardCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminDashboardCustomAppBar({
    super.key,
    this.title = 'لوحة التحكم',
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions:   [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Icon(
            Icons.dashboard_rounded,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}