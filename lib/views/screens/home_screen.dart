import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_hoc_tap/services/auth_service.dart';
import 'package:quan_ly_hoc_tap/views/screens/authentication_screens/login_screen.dart';
import 'package:quan_ly_hoc_tap/views/screens/class_schedule_screen.dart';
import 'package:quan_ly_hoc_tap/views/screens/document_screen.dart';
import 'package:quan_ly_hoc_tap/views/screens/exercise_screen.dart';
import 'package:quan_ly_hoc_tap/views/screens/notification_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Người dùng';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trang chủ', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6D5DF6),
        iconTheme: const IconThemeData(
          color: Colors.white, // Màu của mũi tên quay lại
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
            tooltip: 'Đăng xuất',
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào, $displayName 👋',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chào mừng bạn đến với ứng dụng Quản lý học tập!',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                HomeCard(title: 'ClassSchedule', icon: Icons.calendar_today),
                HomeCard(title: 'Exercise', icon: Icons.assignment),
                HomeCard(title: 'Notification', icon: Icons.notifications),
                HomeCard(title: 'Document', icon: Icons.folder),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const HomeCard({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: InkWell(
        onTap: () {
          switch (title) {
            case 'ClassSchedule':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ClassScheduleScreen()),
              );
              break;
            case 'Exercise':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExerciseScreen()),
              );
              break;
            case 'Notification':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()),
              );
              break;
            case 'Document':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DocumentScreen()),
              );
              break;
          }
        },

        borderRadius: BorderRadius.circular(20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Color(0xFF6D5DF6)),
              const SizedBox(height: 10),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
