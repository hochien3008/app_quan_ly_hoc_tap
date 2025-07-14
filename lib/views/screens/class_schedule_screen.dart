import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_hoc_tap/views/screens/detail/widget/builddayheader_widget.dart';
import 'package:quan_ly_hoc_tap/views/screens/detail/widget/weekday_table_cell_widget.dart';

class ScheduleEntry {
  final String subject;
  final String startTime;
  final String endTime;
  final String location;

  ScheduleEntry({
    required this.subject,
    required this.startTime,
    required this.endTime,
    required this.location,
  });

  factory ScheduleEntry.fromMap(Map<String, dynamic> data) {
    return ScheduleEntry(
      subject: data['subject'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      location: data['location'] ?? '',
    );
  }
}

class ClassScheduleScreen extends StatefulWidget {
  const ClassScheduleScreen({super.key});

  @override
  State<ClassScheduleScreen> createState() => _ClassSchudeleScreen();
}

class _ClassSchudeleScreen extends State<ClassScheduleScreen> {
  final List<DateTime> _weekDays = [];
  final Map<String, List<ScheduleEntry>> _entriesByDate = {};

  @override
  void initState() {
    super.initState();
    _generateWeekDays();
    _loadScheduleForWeek();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    for (int i = 0; i < 7; i++) {
      _weekDays.add(monday.add(Duration(days: i)));
    }
  }

  Future<void> _loadScheduleForWeek() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
        await FirebaseFirestore.instance.collection('schedule').doc(uid).get();

    if (doc.exists) {
      final data = doc.data()!;
      for (final day in _weekDays) {
        final dateKey =
            "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
        if (data.containsKey(dateKey)) {
          final rawList = List<Map<String, dynamic>>.from(data[dateKey]);
          _entriesByDate[dateKey] =
              rawList.map((e) => ScheduleEntry.fromMap(e)).toList();
        }
      }
      setState(() {});
    }
  }

  String _getSession(String startTime) {
    final hour = int.tryParse(startTime.split(":")[0]) ?? 0;
    if (hour < 12) return "sáng";
    if (hour < 17) return "chiều";
    return "tối";
  }

  Widget _buildSubjectCell(DateTime day, String session) {
    final dateKey =
        "${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}";
    final entries =
        _entriesByDate[dateKey]
            ?.where((entry) => _getSession(entry.startTime) == session)
            .toList() ??
        [];

    return Container(
      margin: const EdgeInsets.all(2),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            entries
                .map(
                  (entry) => Text(
                    "${entry.subject} (${entry.startTime}-${entry.endTime})",
                    style: const TextStyle(fontSize: 12),
                  ),
                )
                .toList(),
      ),
    );
  }

  // 📅 Tên thứ + ngày
  Widget _buildDayHeader(DateTime day) {
    const weekdayNames = [
      'Thứ 2',
      'Thứ 3',
      'Thứ 4',
      'Thứ 5',
      'Thứ 6',
      'Thứ 7',
      'CN',
    ];
    final label = "${weekdayNames[day.weekday - 1]}\n${day.day}/${day.month}";
    return Container(
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  // 🧱 Dòng tiêu đề
  Widget _buildRowHeader(String label, {bool bold = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thời khóa biểu tuần"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children:
                    _weekDays
                        .map(
                          (day) =>
                              Expanded(child: BuilddayheaderWidget(day: day)),
                        )
                        .toList(),
              ),
            ),
            const WeekdayTableCellWidget(
              sessionLabel: "Buổi sáng",
              color: Color(0xFFD6EAF8),
            ),
            Expanded(
              child: Row(
                children:
                    _weekDays
                        .map(
                          (day) =>
                              Expanded(child: _buildSubjectCell(day, "sáng")),
                        )
                        .toList(),
              ),
            ),
            const WeekdayTableCellWidget(
              sessionLabel: "Buổi chiều",
              color: Color(0xFFD5F5E3),
            ),
            Expanded(
              child: Row(
                children:
                    _weekDays
                        .map(
                          (day) =>
                              Expanded(child: _buildSubjectCell(day, "chiều")),
                        )
                        .toList(),
              ),
            ),
            const WeekdayTableCellWidget(
              sessionLabel: "Buổi tối",
              color: Color(0xFFE8DAEF),
            ),
            Expanded(
              child: Row(
                children:
                    _weekDays
                        .map(
                          (day) =>
                              Expanded(child: _buildSubjectCell(day, "tối")),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
