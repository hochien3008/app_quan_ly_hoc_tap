class ProfileModel {
  final String id;
  final String userId;
  final String displayName;
  final String? bio;
  final String? avatarUrl;
  final String email;
  final String? phoneNumber;
  final String? location;
  final String? institution;
  final String? major;
  final int? yearOfStudy;
  final List<String> interests;
  final List<String> skills;
  final ProfileStats stats;
  final StudyGoals studyGoals;
  final NotificationSettings notificationSettings;
  final PrivacySettings privacySettings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActiveAt;

  ProfileModel({
    required this.id,
    required this.userId,
    required this.displayName,
    this.bio,
    this.avatarUrl,
    required this.email,
    this.phoneNumber,
    this.location,
    this.institution,
    this.major,
    this.yearOfStudy,
    required this.interests,
    required this.skills,
    required this.stats,
    required this.studyGoals,
    required this.notificationSettings,
    required this.privacySettings,
    required this.createdAt,
    required this.updatedAt,
    this.lastActiveAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      displayName: map['displayName'] ?? '',
      bio: map['bio'],
      avatarUrl: map['avatarUrl'],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'],
      location: map['location'],
      institution: map['institution'],
      major: map['major'],
      yearOfStudy: map['yearOfStudy'],
      interests: List<String>.from(map['interests'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      stats: ProfileStats.fromMap(map['stats'] ?? {}),
      studyGoals: StudyGoals.fromMap(map['studyGoals'] ?? {}),
      notificationSettings: NotificationSettings.fromMap(
        map['notificationSettings'] ?? {},
      ),
      privacySettings: PrivacySettings.fromMap(map['privacySettings'] ?? {}),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      lastActiveAt:
          map['lastActiveAt'] != null
              ? DateTime.parse(map['lastActiveAt'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'displayName': displayName,
      'bio': bio,
      'avatarUrl': avatarUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': location,
      'institution': institution,
      'major': major,
      'yearOfStudy': yearOfStudy,
      'interests': interests,
      'skills': skills,
      'stats': stats.toMap(),
      'studyGoals': studyGoals.toMap(),
      'notificationSettings': notificationSettings.toMap(),
      'privacySettings': privacySettings.toMap(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActiveAt': lastActiveAt?.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? userId,
    String? displayName,
    String? bio,
    String? avatarUrl,
    String? email,
    String? phoneNumber,
    String? location,
    String? institution,
    String? major,
    int? yearOfStudy,
    List<String>? interests,
    List<String>? skills,
    ProfileStats? stats,
    StudyGoals? studyGoals,
    NotificationSettings? notificationSettings,
    PrivacySettings? privacySettings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActiveAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      bio: bio ?? this.bio,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      location: location ?? this.location,
      institution: institution ?? this.institution,
      major: major ?? this.major,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      interests: interests ?? this.interests,
      skills: skills ?? this.skills,
      stats: stats ?? this.stats,
      studyGoals: studyGoals ?? this.studyGoals,
      notificationSettings: notificationSettings ?? this.notificationSettings,
      privacySettings: privacySettings ?? this.privacySettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  String get formattedYearOfStudy {
    if (yearOfStudy == null) return '';
    switch (yearOfStudy!) {
      case 1:
        return '1st Year';
      case 2:
        return '2nd Year';
      case 3:
        return '3rd Year';
      case 4:
        return '4th Year';
      default:
        return '${yearOfStudy}th Year';
    }
  }

  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;
  bool get hasBio => bio != null && bio!.isNotEmpty;
  bool get hasInstitution => institution != null && institution!.isNotEmpty;
}

class ProfileStats {
  final int totalStudyTime; // in minutes
  final int totalSessions;
  final int totalTasks;
  final int completedTasks;
  final int totalDocuments;
  final int totalGroups;
  final int currentStreak;
  final int longestStreak;
  final double averageSessionLength; // in minutes
  final DateTime? lastStudyDate;

  ProfileStats({
    required this.totalStudyTime,
    required this.totalSessions,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalDocuments,
    required this.totalGroups,
    required this.currentStreak,
    required this.longestStreak,
    required this.averageSessionLength,
    this.lastStudyDate,
  });

  factory ProfileStats.fromMap(Map<String, dynamic> map) {
    return ProfileStats(
      totalStudyTime: map['totalStudyTime'] ?? 0,
      totalSessions: map['totalSessions'] ?? 0,
      totalTasks: map['totalTasks'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
      totalDocuments: map['totalDocuments'] ?? 0,
      totalGroups: map['totalGroups'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
      averageSessionLength: (map['averageSessionLength'] ?? 0.0).toDouble(),
      lastStudyDate:
          map['lastStudyDate'] != null
              ? DateTime.parse(map['lastStudyDate'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalStudyTime': totalStudyTime,
      'totalSessions': totalSessions,
      'totalTasks': totalTasks,
      'completedTasks': completedTasks,
      'totalDocuments': totalDocuments,
      'totalGroups': totalGroups,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'averageSessionLength': averageSessionLength,
      'lastStudyDate': lastStudyDate?.toIso8601String(),
    };
  }

  double get taskCompletionRate {
    if (totalTasks == 0) return 0.0;
    return completedTasks / totalTasks;
  }

  String get formattedTotalStudyTime {
    final hours = totalStudyTime ~/ 60;
    final minutes = totalStudyTime % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  String get formattedAverageSessionLength {
    final hours = averageSessionLength ~/ 60;
    final minutes = (averageSessionLength % 60).round();
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}

class StudyGoals {
  final int dailyStudyGoal; // in minutes
  final int weeklyStudyGoal; // in minutes
  final int monthlyStudyGoal; // in minutes
  final int dailyTaskGoal;
  final int weeklyTaskGoal;
  final List<String> academicGoals;
  final DateTime? targetDate;

  StudyGoals({
    required this.dailyStudyGoal,
    required this.weeklyStudyGoal,
    required this.monthlyStudyGoal,
    required this.dailyTaskGoal,
    required this.weeklyTaskGoal,
    required this.academicGoals,
    this.targetDate,
  });

  factory StudyGoals.fromMap(Map<String, dynamic> map) {
    return StudyGoals(
      dailyStudyGoal: map['dailyStudyGoal'] ?? 120,
      weeklyStudyGoal: map['weeklyStudyGoal'] ?? 840,
      monthlyStudyGoal: map['monthlyStudyGoal'] ?? 3600,
      dailyTaskGoal: map['dailyTaskGoal'] ?? 5,
      weeklyTaskGoal: map['weeklyTaskGoal'] ?? 25,
      academicGoals: List<String>.from(map['academicGoals'] ?? []),
      targetDate:
          map['targetDate'] != null ? DateTime.parse(map['targetDate']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dailyStudyGoal': dailyStudyGoal,
      'weeklyStudyGoal': weeklyStudyGoal,
      'monthlyStudyGoal': monthlyStudyGoal,
      'dailyTaskGoal': dailyTaskGoal,
      'weeklyTaskGoal': weeklyTaskGoal,
      'academicGoals': academicGoals,
      'targetDate': targetDate?.toIso8601String(),
    };
  }

  String get formattedDailyStudyGoal {
    final hours = dailyStudyGoal ~/ 60;
    final minutes = dailyStudyGoal % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  String get formattedWeeklyStudyGoal {
    final hours = weeklyStudyGoal ~/ 60;
    final minutes = weeklyStudyGoal % 60;
    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}

class NotificationSettings {
  final bool studyReminders;
  final bool taskReminders;
  final bool scheduleNotifications;
  final bool groupNotifications;
  final bool achievementNotifications;
  final bool emailNotifications;
  final bool pushNotifications;
  final String reminderTime; // 'morning', 'afternoon', 'evening'

  NotificationSettings({
    required this.studyReminders,
    required this.taskReminders,
    required this.scheduleNotifications,
    required this.groupNotifications,
    required this.achievementNotifications,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.reminderTime,
  });

  factory NotificationSettings.fromMap(Map<String, dynamic> map) {
    return NotificationSettings(
      studyReminders: map['studyReminders'] ?? true,
      taskReminders: map['taskReminders'] ?? true,
      scheduleNotifications: map['scheduleNotifications'] ?? true,
      groupNotifications: map['groupNotifications'] ?? true,
      achievementNotifications: map['achievementNotifications'] ?? true,
      emailNotifications: map['emailNotifications'] ?? false,
      pushNotifications: map['pushNotifications'] ?? true,
      reminderTime: map['reminderTime'] ?? 'morning',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studyReminders': studyReminders,
      'taskReminders': taskReminders,
      'scheduleNotifications': scheduleNotifications,
      'groupNotifications': groupNotifications,
      'achievementNotifications': achievementNotifications,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'reminderTime': reminderTime,
    };
  }
}

class PrivacySettings {
  final bool profilePublic;
  final bool showStudyStats;
  final bool showActivityStatus;
  final bool allowGroupInvites;
  final bool showOnlineStatus;
  final List<String> blockedUsers;

  PrivacySettings({
    required this.profilePublic,
    required this.showStudyStats,
    required this.showActivityStatus,
    required this.allowGroupInvites,
    required this.showOnlineStatus,
    required this.blockedUsers,
  });

  factory PrivacySettings.fromMap(Map<String, dynamic> map) {
    return PrivacySettings(
      profilePublic: map['profilePublic'] ?? true,
      showStudyStats: map['showStudyStats'] ?? true,
      showActivityStatus: map['showActivityStatus'] ?? true,
      allowGroupInvites: map['allowGroupInvites'] ?? true,
      showOnlineStatus: map['showOnlineStatus'] ?? true,
      blockedUsers: List<String>.from(map['blockedUsers'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profilePublic': profilePublic,
      'showStudyStats': showStudyStats,
      'showActivityStatus': showActivityStatus,
      'allowGroupInvites': allowGroupInvites,
      'showOnlineStatus': showOnlineStatus,
      'blockedUsers': blockedUsers,
    };
  }
}
