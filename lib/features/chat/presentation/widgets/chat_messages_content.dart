import 'package:nabd_alattaa_team/common_imports.dart';
import 'package:nabd_alattaa_team/features/chat/data/models/message_model.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/view_model/chat_cubit.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/view_model/chat_state.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/chat_empty_state.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/message_bubble.dart';

class ChatMessagesContent extends StatelessWidget {
  final ChatState state;
  final String roomId;
  final String senderId;
  final String roomName;
  final ScrollController? scrollController;
  final void Function(MessageModel message) onMessageLongPress;

  const ChatMessagesContent({
    super.key,
    required this.state,
    required this.roomId,
    required this.senderId,
    required this.roomName,
    this.scrollController,
    required this.onMessageLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (state is ChatLoading) {
      return const LoadingWidget();
    }

    if (state is ChatError) {
      return CustomErrorWidget(
        message: (state as ChatError).message,
        onRetry: () =>
            context.read<ChatCubit>().loadMessages(roomId: roomId),
      );
    }

    if (state is MessagesLoaded) {
      final messages = (state as MessagesLoaded).messages;

      if (messages.isEmpty) {
        return const ChatEmptyState();
      }

      return ListView.builder(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isMe = message.senderId == senderId;
          final previousMessage = index > 0 ? messages[index - 1] : null;
          final showSenderName = !isMe &&
              (previousMessage?.senderId != message.senderId);
          final senderName = message.senderName.isNotEmpty
              ? message.senderName
              : roomName;

          return MessageBubble(
            message: message,
            isMe: isMe,
            showSenderName: showSenderName,
            senderName: senderName,
            onLongPress: () {
              if (isMe && !message.isDeleted) {
                onMessageLongPress(message);
              }
            },
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}