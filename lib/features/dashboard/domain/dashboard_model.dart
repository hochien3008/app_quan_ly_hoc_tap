class DashboardModel {
  final String userId;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final int totalStudyTime; // in minutes
  final int todayStudyTime;
  final List<UpcomingTask> upcomingTasks;
  final List<RecentActivity> recentActivities;
  final StudyStats studyStats;

  DashboardModel({
    required this.userId,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.totalStudyTime,
    required this.todayStudyTime,
    required this.upcomingTasks,
    required this.recentActivities,
    required this.studyStats,
  });

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(
      userId: map['userId'] ?? '',
      totalTasks: map['totalTasks'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
      pendingTasks: map['pendingTasks'] ?? 0,
      totalStudyTime: map['totalStudyTime'] ?? 0,
      todayStudyTime: map['todayStudyTime'] ?? 0,
      upcomingTasks:
          (map['upcomingTasks'] as List<dynamic>?)
              ?.map((e) => UpcomingTask.fromMap(e))
              .toList() ??
          [],
      recentActivities:
          (map['recentActivities'] as List<dynamic>?)
              ?.map((e) => RecentActivity.fromMap(e))
              .toList() ??
          [],
      studyStats: StudyStats.fromMap(map['studyStats'] ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'pendingTasks': pendingTasks,
      'totalStudyTime': totalStudyTime,
      'todayStudyTime': todayStudyTime,
      'upcomingTasks': upcomingTasks.map((e) => e.toMap()).toList(),
      'recentActivities': recentActivities.map((e) => e.toMap()).toList(),
      'studyStats': studyStats.toMap(),
    };
  }

  double get completionRate {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }

  String get formattedTotalStudyTime {
    final hours = totalStudyTime ~/ 60;
    final minutes = totalStudyTime % 60;
    return '${hours}h ${minutes}m';
  }

  String get formattedTodayStudyTime {
    final hours = todayStudyTime ~/ 60;
    final minutes = todayStudyTime % 60;
    return '${hours}h ${minutes}m';
  }
}

class UpcomingTask {
  final String id;
  final String title;
  final DateTime dueDate;
  final String priority;
  final String subject;

  UpcomingTask({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.priority,
    required this.subject,
  });

  factory UpcomingTask.fromMap(Map<String, dynamic> map) {
    return UpcomingTask(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      dueDate: DateTime.parse(map['dueDate']),
      priority: map['priority'] ?? 'medium',
      subject: map['subject'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'priority': priority,
      'subject': subject,
    };
  }

  bool get isOverdue => dueDate.isBefore(DateTime.now());
  bool get isDueToday {
    final now = DateTime.now();
    return dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
  }
}

class RecentActivity {
  final String id;
  final String type; // 'task_completed', 'study_session', 'document_uploaded'
  final String title;
  final DateTime timestamp;
  final String? description;

  RecentActivity({
    required this.id,
    required this.type,
    required this.title,
    required this.timestamp,
    this.description,
  });

  factory RecentActivity.fromMap(Map<String, dynamic> map) {
    return RecentActivity(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      title: map['title'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'timestamp': timestamp.toIso8601String(),
      'description': description,
    };
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp).inMinutes;

    if (difference < 1) return 'Just now';
    if (difference < 60) return '$difference minutes ago';
    if (difference < 1440) return '${(difference / 60).floor()} hours ago';
    return '${(difference / 1440).floor()} days ago';
  }
}

class StudyStats {
  final int totalSessions;
  final int thisWeekSessions;
  final double averageSessionLength; // in minutes
  final int longestStreak; // consecutive days
  final int currentStreak;

  StudyStats({
    required this.totalSessions,
    required this.thisWeekSessions,
    required this.averageSessionLength,
    required this.longestStreak,
    required this.currentStreak,
  });

  factory StudyStats.fromMap(Map<String, dynamic> map) {
    return StudyStats(
      totalSessions: map['totalSessions'] ?? 0,
      thisWeekSessions: map['thisWeekSessions'] ?? 0,
      averageSessionLength: (map['averageSessionLength'] ?? 0.0).toDouble(),
      longestStreak: map['longestStreak'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalSessions': totalSessions,
      'thisWeekSessions': thisWeekSessions,
      'averageSessionLength': averageSessionLength,
      'longestStreak': longestStreak,
      'currentStreak': currentStreak,
    };
  }

  String get formattedAverageSessionLength {
    final hours = averageSessionLength ~/ 60;
    final minutes = (averageSessionLength % 60).round();
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}
