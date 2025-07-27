import 'package:flutter/material.dart';
import '../../../../shared/widgets/language_selector.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cài đặt / Settings'),
        backgroundColor: const Color(0xFF6D5DF6),
        foregroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // Language Settings
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: const LanguageSelector(),
          ),

          const SizedBox(height: 16),

          // Theme Settings
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.palette),
                  SizedBox(width: 12),
                  Text('Giao diện / Theme', style: TextStyle(fontSize: 16)),
                ],
              ),
              children: [
                ListTile(
                  leading: const Radio<String>(
                    value: 'light',
                    groupValue: 'light',
                    onChanged: null,
                  ),
                  title: const Text('Sáng / Light'),
                  onTap: () {
                    // TODO: Implement theme change
                  },
                ),
                ListTile(
                  leading: const Radio<String>(
                    value: 'dark',
                    groupValue: 'light',
                    onChanged: null,
                  ),
                  title: const Text('Tối / Dark'),
                  onTap: () {
                    // TODO: Implement theme change
                  },
                ),
                ListTile(
                  leading: const Radio<String>(
                    value: 'system',
                    groupValue: 'light',
                    onChanged: null,
                  ),
                  title: const Text('Hệ thống / System'),
                  onTap: () {
                    // TODO: Implement theme change
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Notification Settings
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ExpansionTile(
              title: const Row(
                children: [
                  Icon(Icons.notifications),
                  SizedBox(width: 12),
                  Text(
                    'Thông báo / Notifications',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              children: [
                SwitchListTile(
                  title: const Text('Thông báo lịch học / Class notifications'),
                  subtitle: const Text('Nhắc nhở trước giờ học'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement notification toggle
                  },
                ),
                SwitchListTile(
                  title: const Text(
                    'Thông báo bài tập / Assignment notifications',
                  ),
                  subtitle: const Text('Nhắc nhở deadline'),
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement notification toggle
                  },
                ),
                SwitchListTile(
                  title: const Text('Thông báo nhóm / Group notifications'),
                  subtitle: const Text('Tin nhắn từ nhóm học tập'),
                  value: false,
                  onChanged: (value) {
                    // TODO: Implement notification toggle
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // About Section
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Giới thiệu / About'),
                  onTap: () {
                    // TODO: Navigate to about screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.help),
                  title: const Text('Trợ giúp / Help'),
                  onTap: () {
                    // TODO: Navigate to help screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.feedback),
                  title: const Text('Phản hồi / Feedback'),
                  onTap: () {
                    // TODO: Navigate to feedback screen
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.privacy_tip),
                  title: const Text('Chính sách bảo mật / Privacy Policy'),
                  onTap: () {
                    // TODO: Navigate to privacy policy
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Điều khoản sử dụng / Terms of Service'),
                  onTap: () {
                    // TODO: Navigate to terms of service
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
