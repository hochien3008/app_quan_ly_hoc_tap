class ScheduleModel {
  final String id;
  final String title;
  final String subject;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String teacher;
  final int priority; // 1-5: 1=thấp, 5=cao
  final int difficulty; // 1-5: 1=dễ, 5=khó
  final bool isRecurring;
  final List<String> recurringDays; // ['monday', 'tuesday', ...]
  final String color;
  final bool isCompleted;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  ScheduleModel({
    required this.id,
    required this.title,
    required this.subject,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.teacher,
    this.priority = 3,
    this.difficulty = 3,
    this.isRecurring = false,
    this.recurringDays = const [],
    this.color = '#4FC3F7',
    this.isCompleted = false,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ScheduleModel.fromMap(Map<String, dynamic> map) {
    return ScheduleModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      description: map['description'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: DateTime.parse(map['endTime']),
      location: map['location'] ?? '',
      teacher: map['teacher'] ?? '',
      priority: map['priority'] ?? 3,
      difficulty: map['difficulty'] ?? 3,
      isRecurring: map['isRecurring'] ?? false,
      recurringDays: List<String>.from(map['recurringDays'] ?? []),
      color: map['color'] ?? '#4FC3F7',
      isCompleted: map['isCompleted'] ?? false,
      completedAt:
          map['completedAt'] != null
              ? DateTime.parse(map['completedAt'])
              : null,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subject': subject,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'teacher': teacher,
      'priority': priority,
      'difficulty': difficulty,
      'isRecurring': isRecurring,
      'recurringDays': recurringDays,
      'color': color,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  ScheduleModel copyWith({
    String? id,
    String? title,
    String? subject,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? teacher,
    int? priority,
    int? difficulty,
    bool? isRecurring,
    List<String>? recurringDays,
    String? color,
    bool? isCompleted,
    DateTime? completedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      teacher: teacher ?? this.teacher,
      priority: priority ?? this.priority,
      difficulty: difficulty ?? this.difficulty,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringDays: recurringDays ?? this.recurringDays,
      color: color ?? this.color,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Smart scheduling methods
  bool get isHighPriority => priority >= 4;
  bool get isHighDifficulty => difficulty >= 4;
  bool get isExamNear => _isExamNear();
  Duration get duration => endTime.difference(startTime);

  bool _isExamNear() {
    // Check if this is an exam within 7 days
    final now = DateTime.now();
    final daysUntilStart = startTime.difference(now).inDays;
    return daysUntilStart <= 7 && daysUntilStart >= 0;
  }

  // Get smart priority score (combines priority, difficulty, and exam proximity)
  double get smartPriorityScore {
    double score = priority.toDouble();

    // Add difficulty weight
    score += difficulty * 0.5;

    // Add exam proximity weight
    if (isExamNear) {
      final daysUntilStart = startTime.difference(DateTime.now()).inDays;
      score += (7 - daysUntilStart) * 0.3; // Higher score for closer exams
    }

    return score;
  }
}

class ScheduleDay {
  final DateTime date;
  final List<ScheduleModel> schedules;

  ScheduleDay({required this.date, required this.schedules});

  List<ScheduleModel> get sortedSchedules {
    final sorted = List<ScheduleModel>.from(schedules);
    sorted.sort((a, b) => a.startTime.compareTo(b.startTime));
    return sorted;
  }

  bool get hasSchedules => schedules.isNotEmpty;

  String get dayName {
    switch (date.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }

  String get shortDayName {
    return dayName.substring(0, 3);
  }
}
