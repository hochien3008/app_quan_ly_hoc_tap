import 'package:flutter/material.dart';
import '../../domain/schedule_model.dart';
import '../../data/schedule_repository.dart';

class AddScheduleModal extends StatefulWidget {
  final ScheduleModel? schedule;

  const AddScheduleModal({super.key, this.schedule});

  @override
  State<AddScheduleModal> createState() => _AddScheduleModalState();
}

class _AddScheduleModalState extends State<AddScheduleModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _subjectController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _teacherController = TextEditingController();

  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now().add(const Duration(hours: 1));
  int _priority = 3;
  int _difficulty = 3;
  bool _isRecurring = false;
  List<String> _recurringDays = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _loadScheduleData();
    }
  }

  void _loadScheduleData() {
    final schedule = widget.schedule!;
    _titleController.text = schedule.title;
    _subjectController.text = schedule.subject;
    _descriptionController.text = schedule.description;
    _locationController.text = schedule.location;
    _teacherController.text = schedule.teacher;
    _startTime = schedule.startTime;
    _endTime = schedule.endTime;
    _priority = schedule.priority;
    _difficulty = schedule.difficulty;
    _isRecurring = schedule.isRecurring;
    _recurringDays = List.from(schedule.recurringDays);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.schedule == null ? 'Add Schedule' : 'Edit Schedule',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Title
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Subject
                    TextFormField(
                      controller: _subjectController,
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a subject';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Time selection
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePicker(
                            'Start Time',
                            _startTime,
                            (time) => setState(() => _startTime = time),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTimePicker(
                            'End Time',
                            _endTime,
                            (time) => setState(() => _endTime = time),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Location and Teacher
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _locationController,
                            decoration: const InputDecoration(
                              labelText: 'Location',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _teacherController,
                            decoration: const InputDecoration(
                              labelText: 'Teacher',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Priority and Difficulty
                    Row(
                      children: [
                        Expanded(
                          child: _buildSlider(
                            'Priority',
                            _priority,
                            1,
                            5,
                            (value) => setState(() => _priority = value),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildSlider(
                            'Difficulty',
                            _difficulty,
                            1,
                            5,
                            (value) => setState(() => _difficulty = value),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Recurring option
                    CheckboxListTile(
                      title: const Text('Recurring Schedule'),
                      value: _isRecurring,
                      onChanged:
                          (value) => setState(() => _isRecurring = value!),
                    ),

                    if (_isRecurring) ...[
                      const SizedBox(height: 8),
                      _buildRecurringDaysSelector(),
                    ],

                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Description (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Save button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveSchedule,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:
                  _isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                        widget.schedule == null
                            ? 'Add Schedule'
                            : 'Update Schedule',
                        style: const TextStyle(fontSize: 16),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    DateTime time,
    Function(DateTime) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(time),
        );
        if (picked != null) {
          final newTime = DateTime(
            time.year,
            time.month,
            time.day,
            picked.hour,
            picked.minute,
          );
          onChanged(newTime);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    int value,
    int min,
    int max,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: $value',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          divisions: max - min,
          onChanged: (newValue) => onChanged(newValue.round()),
        ),
      ],
    );
  }

  Widget _buildRecurringDaysSelector() {
    final days = [
      {'name': 'Mon', 'value': 'monday'},
      {'name': 'Tue', 'value': 'tuesday'},
      {'name': 'Wed', 'value': 'wednesday'},
      {'name': 'Thu', 'value': 'thursday'},
      {'name': 'Fri', 'value': 'friday'},
      {'name': 'Sat', 'value': 'saturday'},
      {'name': 'Sun', 'value': 'sunday'},
    ];

    return Wrap(
      spacing: 8,
      children:
          days.map((day) {
            final isSelected = _recurringDays.contains(day['value']);
            return FilterChip(
              label: Text(day['name']!),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _recurringDays.add(day['value']!);
                  } else {
                    _recurringDays.remove(day['value']!);
                  }
                });
              },
            );
          }).toList(),
    );
  }

  Future<void> _saveSchedule() async {
    if (!_formKey.currentState!.validate()) return;

    if (_endTime.isBefore(_startTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final repository = ScheduleRepositoryImpl();
      final schedule = ScheduleModel(
        id: widget.schedule?.id ?? '',
        title: _titleController.text,
        subject: _subjectController.text,
        description: _descriptionController.text,
        startTime: _startTime,
        endTime: _endTime,
        location: _locationController.text,
        teacher: _teacherController.text,
        priority: _priority,
        difficulty: _difficulty,
        isRecurring: _isRecurring,
        recurringDays: _recurringDays,
        createdAt: widget.schedule?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      String? error;
      if (widget.schedule == null) {
        error = await repository.createSchedule(schedule);
      } else {
        error = await repository.updateSchedule(schedule);
      }

      if (error != null) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $error')));
        }
      } else {
        if (mounted) {
          Navigator.pop(context, schedule);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _teacherController.dispose();
    super.dispose();
  }
}
