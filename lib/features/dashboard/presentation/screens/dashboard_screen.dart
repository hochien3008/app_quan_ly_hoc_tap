import 'package:flutter/material.dart';
import '../../../schedule/domain/schedule_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy data for demo
    final List<ScheduleModel> todaySchedules = [
      ScheduleModel(
        id: '1',
        title: 'Math Class',
        subject: 'Math',
        description: 'Algebra and Geometry',
        startTime: DateTime.now().add(const Duration(hours: 1)),
        endTime: DateTime.now().add(const Duration(hours: 2)),
        location: 'Room 101',
        teacher: 'Mr. Smith',
        priority: 4,
        difficulty: 3,
        isRecurring: false,
        recurringDays: [],
        color: '#4A90E2',
        isCompleted: false,
        completedAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ScheduleModel(
        id: '2',
        title: 'English Literature',
        subject: 'English',
        description: 'Poetry analysis',
        startTime: DateTime.now().add(const Duration(hours: 3)),
        endTime: DateTime.now().add(const Duration(hours: 4)),
        location: 'Room 202',
        teacher: 'Ms. Johnson',
        priority: 3,
        difficulty: 2,
        isRecurring: false,
        recurringDays: [],
        color: '#F5A623',
        isCompleted: false,
        completedAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    final List<String> tasks = [
      'Review Math homework',
      'Read 10 pages of Literature',
      'Prepare for Chemistry quiz',
    ];

    double progress = 0.6; // 60% demo

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyMate'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Lịch hôm nay
            Text(
              'Today\'s Schedule',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: todaySchedules.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final schedule = todaySchedules[index];
                  return _buildScheduleCard(schedule);
                },
              ),
            ),
            const SizedBox(height: 24),
            // Nhiệm vụ cần làm
            Text('Tasks', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ...tasks.map(
              (task) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.check_box_outline_blank),
                  title: Text(task),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Tiến trình học tập
            Text('Progress', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: Theme.of(context).colorScheme.background,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(progress * 100).toStringAsFixed(0)}% completed',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleModel schedule) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      color: Color(int.parse(schedule.color.replaceFirst('#', '0xff'))),
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              schedule.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              schedule.subject,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  '${schedule.startTime.hour.toString().padLeft(2, '0')}:${schedule.startTime.minute.toString().padLeft(2, '0')} - '
                  '${schedule.endTime.hour.toString().padLeft(2, '0')}:${schedule.endTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
