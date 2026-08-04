import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../view_model/chat_cubit.dart';
import '../view_model/chat_state.dart';
import '../../data/models/message_model.dart';
import '../widgets/message_bubble.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String senderName;
  final String senderId;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.senderName,
    required this.senderId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMessages(roomId: widget.roomId);
    context.read<ChatCubit>().markMessagesAsRead(
          roomId: widget.roomId,
          currentUserId: widget.senderId,
        );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final message = MessageModel(
      id: '',
      content: text,
      senderId: widget.senderId,
      senderName: widget.senderName,
      timestamp: DateTime.now(),
    );

    context.read<ChatCubit>().sendMessage(
          roomId: widget.roomId,
          message: message,
        );

    _messageController.clear();
    _scrollToBottom();
  }

  void _showMessageOptions(MessageModel message) {
    if (message.senderId != widget.senderId) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
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
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                ),
                title: const Text('تعديل الرسالة', style: TextStyle(fontFamily: 'Cairo')),
                onTap: () {
                  Navigator.pop(ctx);
                  _showEditDialog(message);
                },
              ),
              ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
                ),
                title: const Text(
                  'حذف الرسالة',
                  style: TextStyle(color: AppColors.error, fontFamily: 'Cairo'),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  context.read<ChatCubit>().deleteMessage(
                        roomId: widget.roomId,
                        messageId: message.id,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(MessageModel message) {
    final controller = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
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
                controller: controller,
                maxLines: null,
                style: const TextStyle(fontFamily: 'Cairo'),
                decoration: InputDecoration(
                  hintText: 'اكتب الرسالة...',
                  hintStyle: const TextStyle(fontFamily: 'Cairo', color: AppColors.textHint),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.grey200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
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
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: AppColors.grey300),
                        ),
                      ),
                      child: const Text('إلغاء', style: TextStyle(fontFamily: 'Cairo')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final newContent = controller.text.trim();
                        if (newContent.isNotEmpty && newContent != message.content) {
                          context.read<ChatCubit>().editMessage(
                                roomId: widget.roomId,
                                messageId: message.id,
                                newContent: newContent,
                              );
                        }
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('حفظ', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          context.read<ChatCubit>().stopMessagesStream();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F3F8),
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatCubit, ChatState>(
                listener: (context, state) {
                  if (state is MessagesLoaded) {
                    _scrollToBottom();
                    context.read<ChatCubit>().markMessagesAsRead(
                          roomId: widget.roomId,
                          currentUserId: widget.senderId,
                        );
                  } else if (state is ChatError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const LoadingWidget();
                  }

                  if (state is ChatError) {
                    return CustomErrorWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<ChatCubit>().loadMessages(roomId: widget.roomId);
                      },
                    );
                  }

                  if (state is MessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return _buildEmptyChat();
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        final isMe = message.senderId == widget.senderId;
                        final previousMessage = index > 0 ? state.messages[index - 1] : null;
                        final showSenderName = !isMe &&
                            (previousMessage?.senderId != message.senderId);
                        final senderName = message.senderName.isNotEmpty
                            ? message.senderName
                            : widget.roomName;

                        return MessageBubble(
                          message: message,
                          isMe: isMe,
                          showSenderName: showSenderName,
                          senderName: senderName,
                          onLongPress: () => _showMessageOptions(message),
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      leadingWidth: 40,
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                widget.roomName.isNotEmpty ? widget.roomName[0] : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.roomName.isNotEmpty ? widget.roomName : 'محادثة',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'متصل الآن',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
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
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'أرسل رسالة للبدء في المحادثة',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
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
            color: Colors.black.withOpacity(0.05),
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
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.grey200),
              ),
              child: TextField(
                controller: _messageController,
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
                gradient: _messageController.text.trim().isNotEmpty
                    ? const LinearGradient(
                        colors: [AppColors.primary, AppColors.primaryLight],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: _messageController.text.trim().isEmpty
                    ? AppColors.grey200
                    : null,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _messageController.text.trim().isNotEmpty ? _sendMessage : null,
                icon: Icon(
                  Icons.send_rounded,
                  size: 22,
                  color: _messageController.text.trim().isNotEmpty
                      ? Colors.white
                      : AppColors.grey400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
