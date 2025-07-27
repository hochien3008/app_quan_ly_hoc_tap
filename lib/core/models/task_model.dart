import 'package:cloud_firestore/cloud_firestore.dart';

enum TaskPriority { low, medium, high, urgent }

enum TaskStatus { pending, inProgress, completed, cancelled }

class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final String? subject;
  final String? category;
  final List<String> tags;
  final int estimatedMinutes;
  final int actualMinutes;
  final String? attachmentUrl;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.dueDate,
    this.priority = TaskPriority.medium,
    this.status = TaskStatus.pending,
    this.subject,
    this.category,
    this.tags = const [],
    this.estimatedMinutes = 0,
    this.actualMinutes = 0,
    this.attachmentUrl,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      dueDate:
          map['dueDate'] != null
              ? (map['dueDate'] as Timestamp).toDate()
              : DateTime.now(),
      priority: TaskPriority.values.firstWhere(
        (e) => e.toString() == 'TaskPriority.${map['priority'] ?? 'medium'}',
        orElse: () => TaskPriority.medium,
      ),
      status: TaskStatus.values.firstWhere(
        (e) => e.toString() == 'TaskStatus.${map['status'] ?? 'pending'}',
        orElse: () => TaskStatus.pending,
      ),
      subject: map['subject'],
      category: map['category'],
      tags: List<String>.from(map['tags'] ?? []),
      estimatedMinutes: map['estimatedMinutes'] ?? 0,
      actualMinutes: map['actualMinutes'] ?? 0,
      attachmentUrl: map['attachmentUrl'],
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
      'dueDate': dueDate,
      'priority': priority.toString().split('.').last,
      'status': status.toString().split('.').last,
      'subject': subject,
      'category': category,
      'tags': tags,
      'estimatedMinutes': estimatedMinutes,
      'actualMinutes': actualMinutes,
      'attachmentUrl': attachmentUrl,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'completedAt': completedAt,
    };
  }

  TaskModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    String? subject,
    String? category,
    List<String>? tags,
    int? estimatedMinutes,
    int? actualMinutes,
    String? attachmentUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? completedAt,
  }) {
    return TaskModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isOverdue {
    return dueDate.isBefore(DateTime.now()) && status != TaskStatus.completed;
  }

  bool get isDueToday {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }

  bool get isDueTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return dueDate.year == tomorrow.year &&
        dueDate.month == tomorrow.month &&
        dueDate.day == tomorrow.day;
  }

  String get formattedDueDate {
    if (isDueToday) return 'Hôm nay';
    if (isDueTomorrow) return 'Ngày mai';
    if (isOverdue) return 'Quá hạn';

    final now = DateTime.now();
    final difference = dueDate.difference(now).inDays;

    if (difference < 0) return '${difference.abs()} ngày trước';
    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Ngày mai';
    return 'Còn $difference ngày';
  }

  String get formattedEstimatedTime {
    if (estimatedMinutes < 60) return '${estimatedMinutes}m';
    final hours = estimatedMinutes ~/ 60;
    final minutes = estimatedMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }

  String get formattedActualTime {
    if (actualMinutes < 60) return '${actualMinutes}m';
    final hours = actualMinutes ~/ 60;
    final minutes = actualMinutes % 60;
    return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
  }
}
