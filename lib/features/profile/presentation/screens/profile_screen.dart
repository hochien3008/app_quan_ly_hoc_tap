import 'package:flutter/material.dart';
import 'package:quan_ly_hoc_tap/features/study_session/presentation/screens/quiz_screen.dart';
import 'package:quan_ly_hoc_tap/features/groups/presentation/screens/group_list_screen.dart';
import 'package:quan_ly_hoc_tap/features/profile/presentation/screens/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ảnh đại diện, tên, cấp học
              CircleAvatar(
                radius: 48,
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.primary.withOpacity(0.15),
                child: const Icon(
                  Icons.person,
                  size: 56,
                  color: Color(0xFF4A90E2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Nguyen Van A',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              const SizedBox(height: 4),
              Text(
                'Grade 12',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 24),
              // Thành tích: badge/huy hiệu
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBadge(Icons.emoji_events, Colors.amber, 'Top 1 Math'),
                  const SizedBox(width: 16),
                  _buildBadge(Icons.star, Colors.blue, 'Vocabulary Master'),
                  const SizedBox(width: 16),
                  _buildBadge(Icons.bolt, Colors.green, 'Pomodoro Pro'),
                ],
              ),
              const SizedBox(height: 32),
              // Biểu đồ: thời gian học, mức độ hoàn thành
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Study Progress',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Total Study Time: 120h',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Completion: 75%',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: 0.75,
                        minHeight: 12,
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Shortcut chức năng phụ
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 2,
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.quiz),
                      title: const Text('Quiz/Test'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QuizScreen(),
                            ),
                          ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.group),
                      title: const Text('Study Groups'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const GroupListScreen(),
                            ),
                          ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SettingsScreen(),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Nút chỉnh sửa mục tiêu học tập
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Edit study goals
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Study Goals'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(IconData icon, Color color, String label) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
