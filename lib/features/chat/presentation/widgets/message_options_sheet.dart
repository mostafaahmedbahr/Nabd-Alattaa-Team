import 'package:nabd_alattaa_team/common_imports.dart';
import 'package:nabd_alattaa_team/features/chat/data/models/message_model.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/view_model/chat_cubit.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/edit_message_dialog.dart';

class MessageOptionsSheet extends StatelessWidget {
  final MessageModel message;
  final String roomId;

  const MessageOptionsSheet({
    super.key,
    required this.message,
    required this.roomId,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
              ),
              title: const Text('تعديل الرسالة', style: TextStyle(fontFamily: 'Cairo')),
              onTap: () => _showEditDialog(context),
            ),
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              ),
              title: const Text(
                'حذف الرسالة',
                style: TextStyle(color: AppColors.error, fontFamily: 'Cairo'),
              ),
              onTap: () => _showDeleteDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (_) => EditMessageDialog(
        message: message,
        roomId: roomId,
      ),
    );
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'حذف الرسالة',
          style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'هل أنت متأكد من حذف هذه الرسالة؟',
          style: TextStyle(fontFamily: 'Cairo'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
          ),
          TextButton(
            onPressed: () {
              context.read<ChatCubit>().deleteMessage(
                    roomId: roomId,
                    messageId: message.id,
                  );
              Navigator.pop(ctx, true);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: const Text(
              'حذف',
              style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      Navigator.pop(context);
    }
  }
}