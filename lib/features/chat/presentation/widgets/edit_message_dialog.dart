import 'package:nabd_alattaa_team/common_imports.dart';
import 'package:nabd_alattaa_team/features/chat/data/models/message_model.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/view_model/chat_cubit.dart';

class EditMessageDialog extends StatefulWidget {
  final MessageModel message;
  final String roomId;

  const EditMessageDialog({
    super.key,
    required this.message,
    required this.roomId,
  });

  @override
  State<EditMessageDialog> createState() => _EditMessageDialogState();
}

class _EditMessageDialogState extends State<EditMessageDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message.content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final newContent = _controller.text.trim();
    if (newContent.isNotEmpty && newContent != widget.message.content) {
      context.read<ChatCubit>().editMessage(
            roomId: widget.roomId,
            messageId: widget.message.id,
            newContent: newContent,
          );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 16),
            const Text(
              'تعديل الرسالة',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              maxLines: null,
              autofocus: true,
              style: const TextStyle(fontFamily: 'Cairo'),
              decoration: InputDecoration(
                hintText: 'اكتب الرسالة...',
                hintStyle: const TextStyle(fontFamily: 'Cairo', color: AppColors.textHint),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.grey200),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: AppColors.grey300),
                      ),
                    ),
                    child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'حفظ',
                      style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}