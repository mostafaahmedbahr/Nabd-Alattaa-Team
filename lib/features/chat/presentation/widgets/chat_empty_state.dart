import 'package:nabd_alattaa_team/common_imports.dart';

class ChatEmptyState extends StatelessWidget {
  const ChatEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 56,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ابدأ المحادثة',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أرسل رسالة للبدء في المحادثة',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}