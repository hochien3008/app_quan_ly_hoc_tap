import 'package:cloud_firestore/cloud_firestore.dart';

enum TestType { quiz, exam, assignment, practice }

enum TestStatus { draft, published, completed, archived }

class TestModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final TestType type;
  final TestStatus status;
  final String? subject;
  final DateTime? scheduledDate;
  final DateTime? dueDate;
  final int duration; // in minutes
  final int totalQuestions;
  final int correctAnswers;
  final double score; // percentage
  final List<String> tags;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  TestModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.type = TestType.quiz,
    this.status = TestStatus.draft,
    this.subject,
    this.scheduledDate,
    this.dueDate,
    this.duration = 0,
    this.totalQuestions = 0,
    this.correctAnswers = 0,
    this.score = 0.0,
    this.tags = const [],
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory TestModel.fromMap(Map<String, dynamic> map) {
    return TestModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      type: TestType.values.firstWhere(
        (e) => e.toString() == 'TestType.${map['type'] ?? 'quiz'}',
        orElse: () => TestType.quiz,
      ),
      status: TestStatus.values.firstWhere(
        (e) => e.toString() == 'TestStatus.${map['status'] ?? 'draft'}',
        orElse: () => TestStatus.draft,
      ),
      subject: map['subject'],
      scheduledDate:
          map['scheduledDate'] != null
              ? (map['scheduledDate'] as Timestamp).toDate()
              : null,
      dueDate:
          map['dueDate'] != null
              ? (map['dueDate'] as Timestamp).toDate()
              : null,
      duration: map['duration'] ?? 0,
      totalQuestions: map['totalQuestions'] ?? 0,
      correctAnswers: map['correctAnswers'] ?? 0,
      score: (map['score'] ?? 0.0).toDouble(),
      tags: List<String>.from(map['tags'] ?? []),
      notes: map['notes'],
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.now(),
      completedAt:
          map['completedAt'] != null
              ? (map['completedAt'] as Timestamp).toDate()
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'subject': subject,
      'scheduledDate': scheduledDate,
      'dueDate': dueDate,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'score': score,
      'tags': tags,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'completedAt': completedAt,
    };
  }

  TestModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    TestType? type,
    TestStatus? status,
    String? subject,
    DateTime? scheduledDate,
    DateTime? dueDate,
    int? duration,
    int? totalQuestions,
    int? correctAnswers,
    double? score,
    List<String>? tags,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return TestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      status: status ?? this.status,
      subject: subject ?? this.subject,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      dueDate: dueDate ?? this.dueDate,
      duration: duration ?? this.duration,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      score: score ?? this.score,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isCompleted {
    return status == TestStatus.completed;
  }

  bool get isUpcoming {
    return scheduledDate != null && scheduledDate!.isAfter(DateTime.now());
  }

  bool get isOverdue {
    return dueDate != null && dueDate!.isBefore(DateTime.now()) && !isCompleted;
  }

  String get formattedScore {
    return '${score.toStringAsFixed(1)}%';
  }

  String get formattedDuration {
    if (duration < 60) return '${duration}m';
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  String get formattedScheduledDate {
    if (scheduledDate == null) return 'Chưa lên lịch';

    final now = DateTime.now();
    final difference = scheduledDate!.difference(now).inDays;

    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';
    if (difference < 0) return 'Đã qua';
    return 'Còn $difference ngày';
  }

  String get grade {
    if (score >= 90) return 'A';
    if (score >= 80) return 'B';
    if (score >= 70) return 'C';
    if (score >= 60) return 'D';
    return 'F';
  }
}
