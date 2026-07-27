import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../data/models/message_model.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isSelf;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSelf ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isSelf ? AppColors.primary : AppColors.grey100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isSelf ? 16 : 4),
            bottomRight: Radius.circular(isSelf ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isSelf)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary.withOpacity(0.8),
                  ),
                ),
              ),
            Text(
              message.content,
              style: TextStyle(
                fontSize: 14,
                color: isSelf ? AppColors.textWhite : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.timestamp),
                  style: TextStyle(
                    fontSize: 10,
                    color: isSelf
                        ? AppColors.textWhite.withOpacity(0.7)
                        : AppColors.textHint,
                  ),
                ),
                if (isSelf) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all : Icons.done,
                    size: 14,
                    color: message.isRead
                        ? AppColors.textWhite.withOpacity(0.9)
                        : AppColors.textWhite.withOpacity(0.5),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return intl.DateFormat('HH:mm', 'ar').format(date);
  }
}
