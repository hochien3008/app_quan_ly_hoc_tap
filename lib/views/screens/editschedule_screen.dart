import 'package:flutter/material.dart';
import 'package:quan_ly_hoc_tap/controllers/models/scheduleentry.dart';
import 'package:quan_ly_hoc_tap/services/schedule_service.dart';

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
      final entry = ScheduleEntry(
        subject: _subjectController.text.trim(),
        startTime: _startTime!.format(context),
        endTime: _endTime!.format(context),
        location: _locationController.text.trim(),
      );

      final dateKey =
          "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}";

      await ScheduleService().addScheduleEntry(dateKey, entry);
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
      appBar: AppBar(title: const Text("Thêm buổi học")),
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
