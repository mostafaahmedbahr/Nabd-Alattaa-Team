import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nabd_alattaa_team/features/profile/presentation/views/profile_screen.dart';

import 'home_screen.dart';

class MainScreen extends StatelessWidget {
  final Widget? child;

  const MainScreen({super.key, this.child});

  static const List<String> _titles = [
    'الرئيسية',
    'المهام',
    'الإعلانات',
    'الشات',
    'حسابي',
  ];

  static const List<IconData> _icons = [
    Icons.home_outlined,
    Icons.task_alt_outlined,
    Icons.campaign_outlined,
    Icons.chat_outlined,
    Icons.person_outline,
  ];

  static const List<IconData> _selectedIcons = [
    Icons.home,
    Icons.task_alt,
    Icons.campaign,
    Icons.chat,
    Icons.person,
  ];

  static int _calculateIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/tasks')) return 1;
    if (location.startsWith('/notifications') ||
        location.startsWith('/announcements')) return 2;
    if (location.startsWith('/chat')) return 3;
    if (location.startsWith('/profile') || location.startsWith('/edit-profile')) {
      return 4;
    }
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/tasks');
        break;
      case 2:
        context.go('/notifications');
        break;
      case 3:
        context.go('/chat');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateIndex(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[currentIndex]),
          centerTitle: true,
        ),
        body: child ?? const HomeScreen(),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(context, index),
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: List.generate(
            _titles.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(
                currentIndex == index ? _selectedIcons[index] : _icons[index],
              ),
              label: _titles[index],
            ),
          ),
        ),
      ),
    );
  }
}
