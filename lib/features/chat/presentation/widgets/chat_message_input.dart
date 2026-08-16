import 'package:nabd_alattaa_team/common_imports.dart';

class ChatMessageInput extends StatefulWidget {
  final ValueChanged<String> onSend;

  const ChatMessageInput({super.key, required this.onSend});

  @override
  State<ChatMessageInput> createState() => _ChatMessageInputState();
}

class _ChatMessageInputState extends State<ChatMessageInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final hasText = _controller.text.trim().isNotEmpty;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: AppColors.grey200),
              ),
              child: TextField(
                controller: _controller,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 15,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ),
          const SizedBox(width: 8),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Container(
              decoration: BoxDecoration(
                gradient: hasText
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: hasText ? null : AppColors.grey200,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: hasText ? _send : null,
                icon: Icon(
                  Icons.send_rounded,
                  size: 22,
                  color: hasText ? Colors.white : AppColors.grey400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}