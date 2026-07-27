import 'package:flutter/material.dart';

import 'home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'الرئيسية',
    'المهام',
    'الإعلانات',
    'الشات',
    'حسابي',
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.task_alt_outlined,
    Icons.campaign_outlined,
    Icons.chat_outlined,
    Icons.person_outline,
  ];

  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.task_alt,
    Icons.campaign,
    Icons.chat,
    Icons.person,
  ];

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        return const Center(
          child: Text('المهام', style: TextStyle(fontSize: 24)),
        );
      case 2:
        return const Center(
          child: Text('الإعلانات', style: TextStyle(fontSize: 24)),
        );
      case 3:
        return const Center(
          child: Text('الشات', style: TextStyle(fontSize: 24)),
        );
      case 4:
        return const Center(
          child: Text('حسابي', style: TextStyle(fontSize: 24)),
        );
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_titles[_currentIndex]),
          centerTitle: true,
        ),
        body: _buildTabContent(_currentIndex),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: List.generate(
            _titles.length,
            (index) => BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == index
                    ? _selectedIcons[index]
                    : _icons[index],
              ),
              label: _titles[index],
            ),
          ),
        ),
      ),
    );
  }
}
