import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/schedule_repository.dart';
import '../../domain/schedule_model.dart';
import '../widgets/schedule_card.dart';
import '../widgets/smart_suggestion_card.dart';
import '../widgets/add_schedule_modal.dart';

class SmartTimetableScreen extends StatefulWidget {
  const SmartTimetableScreen({super.key});

  @override
  State<SmartTimetableScreen> createState() => _SmartTimetableScreenState();
}

class _SmartTimetableScreenState extends State<SmartTimetableScreen> {
  DateTime _selectedDate = DateTime.now();
  List<ScheduleModel> _schedules = [];
  List<ScheduleModel> _smartSuggestions = [];
  bool _isLoading = true;
  int _tabIndex = 0; // 0: Day, 1: Week

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final repository = ScheduleRepositoryImpl();
    final schedules = await repository.getSchedulesByDate(_selectedDate);
    final suggestions = await repository.getSmartSuggestions();
    if (!mounted) return;
    setState(() {
      _schedules = schedules;
      _smartSuggestions = suggestions;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Timetable'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddScheduleModal(),
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Tab switch Day/Week
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildTabButton('Day', 0),
                        const SizedBox(width: 12),
                        _buildTabButton('Week', 1),
                      ],
                    ),
                  ),
                  // Date selector
                  _buildDateSelector(),
                  // Smart suggestions
                  if (_smartSuggestions.isNotEmpty) _buildSmartSuggestions(),
                  // Today's schedule
                  Expanded(
                    child:
                        _tabIndex == 0
                            ? _buildTodaySchedule()
                            : _buildWeekView(),
                  ),
                ],
              ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = _tabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _tabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.12),
                        blurRadius: 8,
                      ),
                    ]
                    : [],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color:
                    isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
              _loadData();
            },
          ),
          Text(
            _getFormattedDate(_selectedDate),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
              _loadData();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmartSuggestions() {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Smart Suggestions',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _smartSuggestions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SmartSuggestionCard(
                    schedule: _smartSuggestions[index],
                    onTap: () => _showScheduleDetails(_smartSuggestions[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySchedule() {
    if (_schedules.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.schedule, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No schedules for today',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to add a new schedule',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildSubjectCard(_schedules[index]),
        );
      },
    );
  }

  Widget _buildSubjectCard(ScheduleModel schedule) {
    final subjectIcon = _getSubjectIcon(schedule.subject);
    final cardColor = Color(
      int.parse(schedule.color.replaceFirst('#', '0xff')),
    );
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      color: cardColor,
      child: Container(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(subjectIcon, color: cardColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule.startTime.hour.toString().padLeft(2, '0')}:${schedule.startTime.minute.toString().padLeft(2, '0')} - '
                        '${schedule.endTime.hour.toString().padLeft(2, '0')}:${schedule.endTime.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildChip(
                        'Priority: ${_getPriorityText(schedule.priority)}',
                        Colors.white70,
                      ),
                      const SizedBox(width: 8),
                      _buildChip(
                        'Difficulty: ${_getDifficultyText(schedule.difficulty)}',
                        Colors.white70,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
        return Icons.calculate;
      case 'english':
        return Icons.menu_book;
      case 'chemistry':
        return Icons.science;
      case 'physics':
        return Icons.bolt;
      case 'history':
        return Icons.history_edu;
      case 'geography':
        return Icons.public;
      case 'biology':
        return Icons.biotech;
      case 'computer':
        return Icons.computer;
      default:
        return Icons.book;
    }
  }

  Widget _buildWeekView() {
    // Placeholder: hiển thị thông báo sẽ cập nhật sau
    return const Center(
      child: Text(
        'Week view coming soon!',
        style: TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  String _getFormattedDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showAddScheduleModal() async {
    final result = await showModalBottomSheet<ScheduleModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddScheduleModal(),
    );

    if (result != null) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule added successfully!')),
      );
    }
  }

  void _showEditScheduleModal(ScheduleModel schedule) async {
    final result = await showModalBottomSheet<ScheduleModel>(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddScheduleModal(schedule: schedule),
    );

    if (result != null) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule updated successfully!')),
      );
    }
  }

  void _showScheduleDetails(ScheduleModel schedule) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(schedule.title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subject: ${schedule.subject}'),
                Text('Teacher: ${schedule.teacher}'),
                Text('Location: ${schedule.location}'),
                Text(
                  'Time: ${_formatTime(schedule.startTime)} - ${_formatTime(schedule.endTime)}',
                ),
                Text('Priority: ${_getPriorityText(schedule.priority)}'),
                Text('Difficulty: ${_getDifficultyText(schedule.difficulty)}'),
                if (schedule.description.isNotEmpty)
                  Text('Description: ${schedule.description}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  Future<void> _markScheduleCompleted(String id) async {
    final repository = ScheduleRepositoryImpl();
    final error = await repository.markScheduleCompleted(id);

    if (error == null) {
      await _loadData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schedule marked as completed!')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $error')));
    }
  }

  Future<void> _deleteSchedule(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Schedule'),
            content: const Text(
              'Are you sure you want to delete this schedule?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final repository = ScheduleRepositoryImpl();
      final error = await repository.deleteSchedule(id);

      if (error == null) {
        await _loadData();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Schedule deleted successfully!')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      }
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return 'Very Low';
      case 2:
        return 'Low';
      case 3:
        return 'Medium';
      case 4:
        return 'High';
      case 5:
        return 'Very High';
      default:
        return 'Medium';
    }
  }

  String _getDifficultyText(int difficulty) {
    switch (difficulty) {
      case 1:
        return 'Very Easy';
      case 2:
        return 'Easy';
      case 3:
        return 'Medium';
      case 4:
        return 'Hard';
      case 5:
        return 'Very Hard';
      default:
        return 'Medium';
    }
  }
}
