import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/widgets/users_list_screen_body.dart';
import '../../../../common_imports.dart';
import '../../data/models/chat_room_model.dart';
import '../view_model/chat_cubit.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  List<ChatRoomModel> _chatRooms = [];
  StreamSubscription? _chatRoomsSubscription;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  void _loadChatRooms() {
    _chatRoomsSubscription?.cancel();
    final chatCubit = context.read<ChatCubit>();
    _chatRoomsSubscription = chatCubit.chatRepository
        .getChatRooms(currentUserId: _currentUserId)
        .listen(
      (result) {
        result.fold(
          (failure) {},
          (chatRooms) {
            if (mounted) {
              setState(() {
                _chatRooms = chatRooms;
              });
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _chatRoomsSubscription?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('بدء محادثة'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
      ),
      body: UsersListScreenBody(chatRooms:_chatRooms,),
    );
  }

  String get currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
}


