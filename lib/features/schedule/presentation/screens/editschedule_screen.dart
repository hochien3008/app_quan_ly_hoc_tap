import 'package:flutter/material.dart';
import 'package:quan_ly_hoc_tap/features/schedule/domain/schedule_model.dart';
import 'package:quan_ly_hoc_tap/features/schedule/data/schedule_repository.dart';

class EditscheduleScreen extends StatefulWidget {
  @override
  _EditscheduleScreenState createState() => _EditscheduleScreenState();
}

class _EditscheduleScreenState extends State<EditscheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _locationController = TextEditingController();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime _selectedDate = DateTime.now();

  Future<void> _submit() async {
    if (_formKey.currentState!.validate() &&
        _startTime != null &&
        _endTime != null) {
      // Tạo start time và end time từ selected date và time
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _startTime!.hour,
        _startTime!.minute,
      );

      final endDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _endTime!.hour,
        _endTime!.minute,
      );

      final schedule = ScheduleModel(
        id: '', // Sẽ được tạo bởi Firestore
        title: _subjectController.text.trim(),
        subject: _subjectController.text.trim(),
        description: '',
        startTime: startDateTime,
        endTime: endDateTime,
        location: _locationController.text.trim(),
        teacher: '', // Có thể bổ sung input nếu muốn
        priority: 3, // Có thể cho người dùng chọn
        difficulty: 3, // Có thể cho người dùng chọn
        isRecurring: false,
        recurringDays: [],
        color: '#4FC3F7',
        isCompleted: false,
        completedAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final scheduleRepository = ScheduleRepositoryImpl();
      await scheduleRepository.createSchedule(schedule);
      Navigator.pop(context);
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) {
      setState(() {
        isStart ? _startTime = result : _endTime = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thêm buổi học"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: 'Môn học'),
                validator:
                    (value) => value!.isEmpty ? 'Không được bỏ trống' : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Phòng học'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _pickTime(true),
                      child: Text(
                        _startTime != null
                            ? "Bắt đầu: ${_startTime!.format(context)}"
                            : "Chọn giờ bắt đầu",
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => _pickTime(false),
                      child: Text(
                        _endTime != null
                            ? "Kết thúc: ${_endTime!.format(context)}"
                            : "Chọn giờ kết thúc",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _submit, child: const Text("Lưu")),
            ],
          ),
        ),
      ),
    );
  }
}
