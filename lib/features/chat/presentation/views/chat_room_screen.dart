import 'package:nabd_alattaa_team/common_imports.dart';
import 'package:nabd_alattaa_team/features/chat/data/models/message_model.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/view_model/chat_cubit.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/view_model/chat_state.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/chat_messages_content.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/chat_message_input.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/chat_room_app_bar.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/message_options_sheet.dart';

class ChatRoomScreen extends StatefulWidget {
  final String roomId;
  final String roomName;
  final String senderName;
  final String senderId;
  final String? otherUserId;

  const ChatRoomScreen({
    super.key,
    required this.roomId,
    required this.roomName,
    required this.senderName,
    required this.senderId,
    this.otherUserId,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final ScrollController _scrollController = ScrollController();
  String? _resolvedRoomId;
  bool _isLoadingRoom = false;

  String get _activeRoomId => _resolvedRoomId ?? widget.roomId;

  @override
  void initState() {
    super.initState();
    if (widget.roomId.isNotEmpty) {
      _resolvedRoomId = widget.roomId;
      _initMessages();
    } else if (widget.otherUserId != null) {
      _createOrGetRoom();
    }
  }

  Future<void> _createOrGetRoom() async {
    setState(() => _isLoadingRoom = true);
    final chatCubit = context.read<ChatCubit>();
    final chatRoom = await chatCubit.getOrCreatePrivateChat(
      currentUserId: widget.senderId,
      currentUserName: widget.senderName,
      otherUserId: widget.otherUserId!,
      otherUserName: widget.roomName,
    );
    if (!mounted) return;
    if (chatRoom != null) {
      setState(() {
        _resolvedRoomId = chatRoom.id;
        _isLoadingRoom = false;
      });
      _initMessages();
    } else {
      setState(() => _isLoadingRoom = false);
    }
  }

  void _initMessages() {
    context.read<ChatCubit>().loadMessages(roomId: _activeRoomId);
    context.read<ChatCubit>().markMessagesAsRead(
          roomId: _activeRoomId,
          currentUserId: widget.senderId,
        );
  }

  @override
  void dispose() {
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

  void _sendMessage(String text) {
    final message = MessageModel(
      id: '',
      content: text,
      senderId: widget.senderId,
      senderName: widget.senderName,
      timestamp: DateTime.now(),
    );

    context.read<ChatCubit>().sendMessage(
          roomId: _activeRoomId,
          message: message,
        );

    _scrollToBottom();
  }

  void _showMessageOptions(MessageModel message) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MessageOptionsSheet(
        message: message,
        roomId: _activeRoomId,
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
        appBar: ChatRoomAppBar(roomName: widget.roomName),
        body: _isLoadingRoom
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: BlocConsumer<ChatCubit, ChatState>(
                      listener: (context, state) {
                        if (state is MessagesLoaded) {
                          _scrollToBottom();
                          context.read<ChatCubit>().markMessagesAsRead(
                                roomId: _activeRoomId,
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
                        return ChatMessagesContent(
                          state: state,
                          roomId: _activeRoomId,
                          senderId: widget.senderId,
                          roomName: widget.roomName,
                          scrollController: _scrollController,
                          onMessageLongPress: _showMessageOptions,
                        );
                      },
                    ),
                  ),
                  ChatMessageInput(onSend: _sendMessage),
                ],
              ),
      ),
    );
  }
}