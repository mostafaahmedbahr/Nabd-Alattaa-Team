import 'package:flutter/services.dart';
import 'package:nabd_alattaa_team/features/home/presentation/views/home_screen.dart';
import 'package:nabd_alattaa_team/features/profile/presentation/views/profile_screen.dart';
import 'package:nabd_alattaa_team/features/tasks/presentation/views/tasks_screen.dart';
import 'package:nabd_alattaa_team/features/chat/presentation/views/chat_list_screen.dart';
import '../../../../common_imports.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialState());

  static int pageIndex = 0;

  List screens = [
    HomeScreen(),
    TasksScreen(),
    ProfileScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  void changeBottomNav(int index) {
    pageIndex = index;
    emit(MainNavigationChanged());
  }

  DateTime? _lastPressed;

  void onPopInvoked(bool didPop, BuildContext context) {
    if (didPop) return;
    if (pageIndex == 0) {
      DateTime now = DateTime.now();
      if (_lastPressed == null ||
          now.difference(_lastPressed!) > const Duration(seconds: 2)) {
        _lastPressed = now;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("خروج"),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        SystemNavigator.pop();
      }
    } else {
      changeBottomNav(0);
    }
  }

  List<String> titles = [
    'الرئيسية',
    'المهام',
    'الإعلانات',
    'الشات',
    'حسابي',
  ];

  List<IconData> icons = [
    Icons.home_outlined,
    Icons.task_alt_outlined,
    Icons.campaign_outlined,
    Icons.chat_outlined,
    Icons.person_outline,
  ];

  List<IconData> selectedIcons = [
    Icons.home,
    Icons.task_alt,
    Icons.campaign,
    Icons.chat,
    Icons.person,
  ];
}
