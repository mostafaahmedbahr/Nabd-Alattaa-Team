import '../../../../common_imports.dart';
import '../../../notifications/presentation/view_model/notification_cubit.dart';
import '../../../notifications/presentation/view_model/notification_state.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: const Text("الرئيسية"),
      actions: [
        BlocBuilder<NotificationCubit, NotificationState>(
          builder: (context, state) {
            final count =
            state is NotificationLoaded ? state.unreadCount : 0;
            return Badge(
              label: Text(
                count.toString(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              isLabelVisible: count > 0,
              alignment: AlignmentDirectional.topEnd,
              offset: const Offset(10, 10),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  context.push(Routes.notifications);
                },
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}