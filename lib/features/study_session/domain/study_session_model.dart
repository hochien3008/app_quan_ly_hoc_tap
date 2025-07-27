class StudySessionModel {
  final String id;
  final String userId;
  final String title;
  final String subject;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // in minutes
  final String status; // 'active', 'paused', 'completed', 'cancelled'
  final List<StudyBlock> studyBlocks;
  final int totalBreaks;
  final int totalBreakTime; // in minutes
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  StudySessionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.subject,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.status,
    required this.studyBlocks,
    required this.totalBreaks,
    required this.totalBreakTime,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory StudySessionModel.fromMap(Map<String, dynamic> map) {
    return StudySessionModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      duration: map['duration'] ?? 0,
      status: map['status'] ?? 'active',
      studyBlocks:
          (map['studyBlocks'] as List<dynamic>?)
              ?.map((e) => StudyBlock.fromMap(e))
              .toList() ??
          [],
      totalBreaks: map['totalBreaks'] ?? 0,
      totalBreakTime: map['totalBreakTime'] ?? 0,
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'subject': subject,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'status': status,
      'studyBlocks': studyBlocks.map((e) => e.toMap()).toList(),
      'totalBreaks': totalBreaks,
      'totalBreakTime': totalBreakTime,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  StudySessionModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? subject,
    DateTime? startTime,
    DateTime? endTime,
    int? duration,
    String? status,
    List<StudyBlock>? studyBlocks,
    int? totalBreaks,
    int? totalBreakTime,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return StudySessionModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      subject: subject ?? this.subject,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      status: status ?? this.status,
      studyBlocks: studyBlocks ?? this.studyBlocks,
      totalBreaks: totalBreaks ?? this.totalBreaks,
      totalBreakTime: totalBreakTime ?? this.totalBreakTime,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get actualStudyTime {
    return studyBlocks.fold(0, (total, block) => total + block.duration);
  }

  int get effectiveStudyTime => actualStudyTime - totalBreakTime;

  double get productivityRate {
    if (duration == 0) return 0.0;
    return effectiveStudyTime / duration;
  }

  String get formattedDuration {
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  String get formattedActualStudyTime {
    final hours = actualStudyTime ~/ 60;
    final minutes = actualStudyTime % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  bool get isActive => status == 'active';
  bool get isPaused => status == 'paused';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
}

class StudyBlock {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final int duration; // in minutes
  final String type; // 'focus', 'break', 'long_break'
  final bool isCompleted;

  StudyBlock({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.duration,
    required this.type,
    required this.isCompleted,
  });

  factory StudyBlock.fromMap(Map<String, dynamic> map) {
    return StudyBlock(
      id: map['id'] ?? '',
      startTime: DateTime.parse(map['startTime']),
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      duration: map['duration'] ?? 0,
      type: map['type'] ?? 'focus',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'duration': duration,
      'type': type,
      'isCompleted': isCompleted,
    };
  }

  bool get isFocus => type == 'focus';
  bool get isBreak => type == 'break';
  bool get isLongBreak => type == 'long_break';
  bool get isActive => endTime == null && isCompleted == false;
}

class PomodoroSettings {
  final int focusDuration; // in minutes
  final int shortBreakDuration; // in minutes
  final int longBreakDuration; // in minutes
  final int sessionsBeforeLongBreak;
  final bool autoStartBreaks;
  final bool autoStartSessions;
  final bool autoStartPomodoros;

  PomodoroSettings({
    required this.focusDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.sessionsBeforeLongBreak,
    required this.autoStartBreaks,
    required this.autoStartSessions,
    required this.autoStartPomodoros,
  });

  factory PomodoroSettings.fromMap(Map<String, dynamic> map) {
    return PomodoroSettings(
      focusDuration: map['focusDuration'] ?? 25,
      shortBreakDuration: map['shortBreakDuration'] ?? 5,
      longBreakDuration: map['longBreakDuration'] ?? 15,
      sessionsBeforeLongBreak: map['sessionsBeforeLongBreak'] ?? 4,
      autoStartBreaks: map['autoStartBreaks'] ?? false,
      autoStartSessions: map['autoStartSessions'] ?? false,
      autoStartPomodoros: map['autoStartPomodoros'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'focusDuration': focusDuration,
      'shortBreakDuration': shortBreakDuration,
      'longBreakDuration': longBreakDuration,
      'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      'autoStartBreaks': autoStartBreaks,
      'autoStartSessions': autoStartSessions,
      'autoStartPomodoros': autoStartPomodoros,
    };
  }

  PomodoroSettings copyWith({
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? sessionsBeforeLongBreak,
    bool? autoStartBreaks,
    bool? autoStartSessions,
    bool? autoStartPomodoros,
  }) {
    return PomodoroSettings(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      sessionsBeforeLongBreak:
          sessionsBeforeLongBreak ?? this.sessionsBeforeLongBreak,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartSessions: autoStartSessions ?? this.autoStartSessions,
      autoStartPomodoros: autoStartPomodoros ?? this.autoStartPomodoros,
    );
  }
}
