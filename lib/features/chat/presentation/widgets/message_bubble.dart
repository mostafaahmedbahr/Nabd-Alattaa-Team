import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showSenderName;
  final String? senderName;
  final VoidCallback? onLongPress;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showSenderName = false,
    this.senderName,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (message.isDeleted) {
      return _buildDeletedMessage(isMe);
    }

    return GestureDetector(
      onLongPress: onLongPress,
      child: Align(
        alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          margin: EdgeInsets.only(
            left: isMe ? 16 : 48,
            right: isMe ? 48 : 16,
            top: 4,
            bottom: 4,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isMe ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMe ? 4 : 18),
              bottomRight: Radius.circular(isMe ? 18 : 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showSenderName && !isMe)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    senderName ?? message.senderName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isMe
                          ? AppColors.textWhite.withOpacity(0.8)
                          : AppColors.primary,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 15,
                        color: isMe ? AppColors.textWhite : AppColors.textPrimary,
                        fontFamily: 'Cairo',
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (message.isEdited)
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            'تعديل',
                            style: TextStyle(
                              fontSize: 10,
                              color: isMe
                                  ? AppColors.textWhite.withOpacity(0.6)
                                  : AppColors.textHint,
                              fontFamily: 'Cairo',
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      Text(
                        _formatTime(message.timestamp),
                        style: TextStyle(
                          fontSize: 11,
                          color: isMe
                              ? AppColors.textWhite.withOpacity(0.6)
                              : AppColors.textHint,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.readBy.length > 1
                              ? Icons.done_all
                              : Icons.done,
                          size: 16,
                          color: message.readBy.length > 1
                              ? const Color(0xFF53BDEB)
                              : AppColors.textWhite.withOpacity(0.6),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeletedMessage(bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          left: isMe ? 16 : 48,
          right: isMe ? 48 : 16,
          top: 4,
          bottom: 4,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.block,
              size: 14,
              color: AppColors.grey400,
            ),
            const SizedBox(width: 6),
            Text(
              'تم حذف هذه الرسالة',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.grey400,
                fontFamily: 'Cairo',
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm a', 'ar_SA').format(time);
  }
}
