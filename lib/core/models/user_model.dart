import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final Map<String, dynamic> preferences;
  final List<String> studyGroups;
  final int totalStudyTime; // in minutes
  final int completedTasks;
  final int totalTasks;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
    required this.lastLoginAt,
    this.preferences = const {},
    this.studyGroups = const [],
    this.totalStudyTime = 0,
    this.completedTasks = 0,
    this.totalTasks = 0,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      lastLoginAt:
          map['lastLoginAt'] != null
              ? (map['lastLoginAt'] as Timestamp).toDate()
              : DateTime.now(),
      preferences: Map<String, dynamic>.from(map['preferences'] ?? {}),
      studyGroups: List<String>.from(map['studyGroups'] ?? []),
      totalStudyTime: map['totalStudyTime'] ?? 0,
      completedTasks: map['completedTasks'] ?? 0,
      totalTasks: map['totalTasks'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'preferences': preferences,
      'studyGroups': studyGroups,
      'totalStudyTime': totalStudyTime,
      'completedTasks': completedTasks,
      'totalTasks': totalTasks,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? photoUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? preferences,
    List<String>? studyGroups,
    int? totalStudyTime,
    int? completedTasks,
    int? totalTasks,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      preferences: preferences ?? this.preferences,
      studyGroups: studyGroups ?? this.studyGroups,
      totalStudyTime: totalStudyTime ?? this.totalStudyTime,
      completedTasks: completedTasks ?? this.completedTasks,
      totalTasks: totalTasks ?? this.totalTasks,
    );
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
}
