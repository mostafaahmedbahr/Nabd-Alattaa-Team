import 'package:nabd_alattaa_team/common_imports.dart';

class ChatRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String roomName;

  const ChatRoomAppBar({super.key, required this.roomName});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                roomName.isNotEmpty ? roomName[0] : '?',
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
                  roomName.isNotEmpty ? roomName : 'محادثة',
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
                    color: Colors.white.withValues(alpha: 0.7),
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
}