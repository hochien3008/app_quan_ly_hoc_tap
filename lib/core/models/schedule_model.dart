import 'package:cloud_firestore/cloud_firestore.dart';

class ScheduleModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String? subject;
  final String? teacher;
  final String? room;
  final bool isRecurring;
  final List<int>? recurringDays; // 1 = Monday, 7 = Sunday
  final DateTime? recurringEndDate;
  final String color;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.subject,
    this.teacher,
    this.room,
    this.isRecurring = false,
    this.recurringDays,
    this.recurringEndDate,
    this.color = '#2196F3',
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      startTime:
          map['startTime'] != null
              ? (map['startTime'] as Timestamp).toDate()
              : DateTime.now(),
      endTime:
          map['endTime'] != null
              ? (map['endTime'] as Timestamp).toDate()
              : DateTime.now(),
      location: map['location'],
      subject: map['subject'],
      teacher: map['teacher'],
      room: map['room'],
      isRecurring: map['isRecurring'] ?? false,
      recurringDays:
          map['recurringDays'] != null
              ? List<int>.from(map['recurringDays'])
              : null,
      recurringEndDate:
          map['recurringEndDate'] != null
              ? (map['recurringEndDate'] as Timestamp).toDate()
              : null,
      color: map['color'] ?? '#2196F3',
      isCompleted: map['isCompleted'] ?? false,
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'subject': subject,
      'teacher': teacher,
      'room': room,
      'isRecurring': isRecurring,
      'recurringDays': recurringDays,
      'recurringEndDate': recurringEndDate,
      'color': color,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? subject,
    String? teacher,
    String? room,
    bool? isRecurring,
    List<int>? recurringDays,
    DateTime? recurringEndDate,
    String? color,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      subject: subject ?? this.subject,
      teacher: teacher ?? this.teacher,
      room: room ?? this.room,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDays: recurringDays ?? this.recurringDays,
      recurringEndDate: recurringEndDate ?? this.recurringEndDate,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Duration get duration {
    return endTime.difference(startTime);
  }

  bool get isToday {
    final now = DateTime.now();
    return startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day;
  }

  bool get isUpcoming {
    return startTime.isAfter(DateTime.now());
  }

  bool get isPast {
    return endTime.isBefore(DateTime.now());
  }

  String get formattedTime {
    final start =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }
}
