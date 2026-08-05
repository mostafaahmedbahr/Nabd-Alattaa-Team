import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../common_imports.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: AppColors.primary),
              title: const Text(AppStrings.editProfile),
              trailing:   Icon(Icons.arrow_forward_ios, size: 16.sp),
              onTap: () {
                context.push('/edit-profile');
              },
            ),
              Divider(height: 1.h),
            ListTile(
              leading: const Icon(Icons.restaurant_menu_outlined, color: AppColors.primary),
              title: const Text('إدارة قائمة الطعام'),
              trailing:   Icon(Icons.arrow_forward_ios, size: 16.sp),
              onTap: () {
                context.push('/manage-meals');
              },
            ),
              Divider(height: 1.h),
            ListTile(
              leading: const Icon(Icons.lock_outline, color: AppColors.primary),
              title: const Text('تغيير كلمة المرور'),
              trailing:   Icon(Icons.arrow_forward_ios, size: 16.sp),
              onTap: () {
                _showChangePasswordDialog(context);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.error),
              title: const Text(
                AppStrings.logout,
                style: TextStyle(color: AppColors.error),
              ),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: .12),
                  child: Icon(
                    Icons.lock_reset_rounded,
                    size: 34,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'تغيير كلمة المرور',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  'سيتم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني المسجل بالحساب.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text(AppStrings.cancel),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: FilledButton.icon(
                        icon: const Icon(Icons.send_rounded),
                        label: const Text(AppStrings.send),
                        onPressed: () async {
                          // TODO:
                          // await context.read<ProfileCubit>().resetPassword();

                          Navigator.pop(dialogContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              margin: const EdgeInsets.all(16),
                              backgroundColor: Colors.green,
                              content: const Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, anim1, anim2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: anim1, curve: Curves.easeOutBack),
          child: FadeTransition(
            opacity: anim1,
            child: child,
          ),
        );
      },
      pageBuilder: (context, anim1, anim2) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.error,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  AppStrings.logout,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'هل أنت متأكد من تسجيل الخروج؟',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.grey300),
                          ),
                        ),
                        child: const Text(
                          AppStrings.no,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) context.go('/login');
                          await FirebaseMessaging.instance.unsubscribeFromTopic(
                            "all_users",
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          AppStrings.yes,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

