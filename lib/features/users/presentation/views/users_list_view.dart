import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/users/presentation/widgets/users_list_screen_body.dart';

import '../../../../common_imports.dart';
import '../../../chat/presentation/view_model/chat_cubit.dart';

class UsersListScreen extends StatefulWidget {
  const UsersListScreen({super.key});

  @override
  State<UsersListScreen> createState() => _UsersListScreenState();
}
///
class _UsersListScreenState extends State<UsersListScreen> {
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadChatRooms(currentUserId: _currentUserId);
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
      body: AdaptiveContainer(
        child: const UsersListScreenBody(),
      ),
    );
  }
}