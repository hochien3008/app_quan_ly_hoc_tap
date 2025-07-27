import 'package:flutter/material.dart';
import 'package:quan_ly_hoc_tap/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:quan_ly_hoc_tap/features/schedule/presentation/screens/smart_timetable_screen.dart';
import 'package:quan_ly_hoc_tap/features/study_session/presentation/screens/pomodoro_screen.dart';
import 'package:quan_ly_hoc_tap/features/documents/presentation/screens/document_screen.dart';
import 'package:quan_ly_hoc_tap/features/study_session/presentation/screens/quiz_screen.dart';
import 'package:quan_ly_hoc_tap/features/groups/presentation/screens/group_list_screen.dart';
import 'package:quan_ly_hoc_tap/features/profile/presentation/screens/profile_screen.dart';
import 'package:quan_ly_hoc_tap/features/notifications/presentation/screens/notification_screen.dart';
import 'package:quan_ly_hoc_tap/features/settings/presentation/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    SmartTimetableScreen(),
    PomodoroScreen(),
    DocumentScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _bottomNavItems = [
    {'icon': Icons.home, 'label': 'Home', 'screen': DashboardScreen()},
    {
      'icon': Icons.calendar_today,
      'label': 'Schedule',
      'screen': SmartTimetableScreen(),
    },
    {'icon': Icons.timer, 'label': 'Pomodoro', 'screen': PomodoroScreen()},
    {'icon': Icons.folder, 'label': 'Documents', 'screen': DocumentScreen()},
    {'icon': Icons.person, 'label': 'Profile', 'screen': ProfileScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bottomNavItems[_selectedIndex]['screen'],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items:
              _bottomNavItems.map((item) {
                return BottomNavigationBarItem(
                  icon: Icon(item['icon']),
                  label: item['label'],
                );
              }).toList(),
        ),
      ),
    );
  }
}
