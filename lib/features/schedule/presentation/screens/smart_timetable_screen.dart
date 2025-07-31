import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_appbar.dart';
import '../../../../routes/route_names.dart';

class SmartTimetableScreen extends StatefulWidget {
  const SmartTimetableScreen({super.key});

  @override
  State<SmartTimetableScreen> createState() => _SmartTimetableScreenState();
}

class _SmartTimetableScreenState extends State<SmartTimetableScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  String _selectedView = 'Week';
  DateTime _selectedDate = DateTime.now();

  final List<String> _viewOptions = ['Day', 'Week', 'Month'];
  final List<String> _weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  final List<Map<String, dynamic>> _schedules = [
    {
      'id': '1',
      'title': 'Mathematics',
      'subject': 'Math',
      'startTime': '08:00',
      'endTime': '09:30',
      'room': 'Room 101',
      'teacher': 'Dr. Smith',
      'color': Colors.blue,
      'isCompleted': false,
    },
    {
      'id': '2',
      'title': 'Physics Lab',
      'subject': 'Physics',
      'startTime': '10:00',
      'endTime': '11:30',
      'room': 'Lab 205',
      'teacher': 'Prof. Johnson',
      'color': Colors.green,
      'isCompleted': true,
    },
    {
      'id': '3',
      'title': 'English Literature',
      'subject': 'English',
      'startTime': '13:00',
      'endTime': '14:30',
      'room': 'Room 302',
      'teacher': 'Ms. Davis',
      'color': Colors.orange,
      'isCompleted': false,
    },
    {
      'id': '4',
      'title': 'Chemistry',
      'subject': 'Chemistry',
      'startTime': '15:00',
      'endTime': '16:30',
      'room': 'Lab 103',
      'teacher': 'Dr. Wilson',
      'color': Colors.purple,
      'isCompleted': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          CustomAppBar(
            title: 'Smart Timetable',
            actions: [
              IconButton(
                onPressed: () => _showAddScheduleDialog(),
                icon: const Icon(Icons.add),
                tooltip: 'Add Schedule',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildViewSelector(),
                    const SizedBox(height: 20),
                    _buildDateSelector(),
                    const SizedBox(height: 20),
                    _buildScheduleList(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddScheduleDialog(),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Schedule'),
        elevation: 8,
      ),
    );
  }

  Widget _buildViewSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            _viewOptions.map((view) {
              final isSelected = _selectedView == view;
              return GestureDetector(
                onTap: () => setState(() => _selectedView = view),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    view,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _changeDate(-1),
            icon: const Icon(Icons.chevron_left),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 2,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  _getFormattedDate(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getFormattedDay(),
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _changeDate(1),
            icon: const Icon(Icons.chevron_right),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleList() {
    final todaySchedules =
        _schedules.where((schedule) {
          // Filter schedules for today (simplified logic)
          return true; // Show all schedules for demo
        }).toList();

    if (todaySchedules.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Schedule',
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ...todaySchedules.map((schedule) => _buildScheduleCard(schedule)),
      ],
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule) {
    final isCompleted = schedule['isCompleted'] as bool;
    final color = schedule['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showScheduleDetails(schedule),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              schedule['title'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Completed',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${schedule['startTime']} - ${schedule['endTime']}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            schedule['room'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            schedule['teacher'],
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _toggleScheduleCompletion(schedule['id']),
                  icon: Icon(
                    isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isCompleted ? Colors.green : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No schedules for today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first schedule to get started',
            style: TextStyle(color: Colors.grey.shade500),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddScheduleDialog(),
            icon: const Icon(Icons.add),
            label: const Text('Add Schedule'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _getFormattedDate() {
    return '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }

  String _getFormattedDay() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[_selectedDate.weekday - 1];
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  void _toggleScheduleCompletion(String scheduleId) {
    setState(() {
      final schedule = _schedules.firstWhere((s) => s['id'] == scheduleId);
      schedule['isCompleted'] = !schedule['isCompleted'];
    });
  }

  void _showScheduleDetails(Map<String, dynamic> schedule) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(schedule['title']),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subject: ${schedule['subject']}'),
                Text('Time: ${schedule['startTime']} - ${schedule['endTime']}'),
                Text('Room: ${schedule['room']}'),
                Text('Teacher: ${schedule['teacher']}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to edit screen
                },
                child: const Text('Edit'),
              ),
            ],
          ),
    );
  }

  void _showAddScheduleDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Schedule'),
            content: const Text('Schedule creation feature coming soon!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }
}
