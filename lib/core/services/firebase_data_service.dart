import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class FirebaseDataService {
  static final FirebaseDataService _instance = FirebaseDataService._internal();
  factory FirebaseDataService() => _instance;
  FirebaseDataService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // ==================== USER DATA ====================

  /// Save user profile data to Firebase
  Future<void> saveUserProfile({
    required String displayName,
    required String email,
    String? photoUrl,
    String? bio,
    String? phoneNumber,
    String? location,
    String? institution,
    String? major,
    int? yearOfStudy,
    List<String> interests = const [],
    List<String> skills = const [],
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final userData = {
        'id': userId,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'bio': bio,
        'phoneNumber': phoneNumber,
        'location': location,
        'institution': institution,
        'major': major,
        'yearOfStudy': yearOfStudy,
        'interests': interests,
        'skills': skills,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastActiveAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('users')
          .doc(userId)
          .set(userData, SetOptions(merge: true));

      if (kDebugMode) {
        print('✅ User profile saved to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving user profile: $e');
      }
      rethrow;
    }
  }

  /// Get user profile from Firebase
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = currentUserId;
      if (userId == null) return null;

      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting user profile: $e');
      }
      return null;
    }
  }

  /// Update user last active time
  Future<void> updateLastActive() async {
    try {
      final userId = currentUserId;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update({
        'lastActiveAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating last active: $e');
      }
    }
  }

  // ==================== SCHEDULE DATA ====================

  /// Save schedule to Firebase
  Future<void> saveSchedule({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required String location,
    required String subject,
    required String teacher,
    String? room,
    bool isRecurring = false,
    List<int>? recurringDays,
    DateTime? recurringEndDate,
    String color = '#2196F3',
    bool isCompleted = false,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final scheduleData = {
        'userId': userId,
        'title': title,
        'description': description,
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'location': location,
        'subject': subject,
        'teacher': teacher,
        'room': room,
        'isRecurring': isRecurring,
        'recurringDays': recurringDays,
        'recurringEndDate':
            recurringEndDate != null
                ? Timestamp.fromDate(recurringEndDate)
                : null,
        'color': color,
        'isCompleted': isCompleted,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('schedules').add(scheduleData);

      if (kDebugMode) {
        print('✅ Schedule saved to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving schedule: $e');
      }
      rethrow;
    }
  }

  /// Get user schedules from Firebase
  Future<List<Map<String, dynamic>>> getUserSchedules() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final querySnapshot =
          await _firestore
              .collection('schedules')
              .where('userId', isEqualTo: userId)
              .orderBy('startTime')
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting schedules: $e');
      }
      return [];
    }
  }

  /// Update schedule completion status
  Future<void> updateScheduleCompletion(
    String scheduleId,
    bool isCompleted,
  ) async {
    try {
      await _firestore.collection('schedules').doc(scheduleId).update({
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('✅ Schedule completion updated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating schedule completion: $e');
      }
      rethrow;
    }
  }

  // ==================== STUDY STATS DATA ====================

  /// Save daily study statistics
  Future<void> saveStudyStats({
    required int totalStudyTime, // in minutes
    required Map<String, int> subjects, // subject -> minutes
    required int completedTasks,
    required int totalTasks,
    int pomodoroSessions = 0,
    double focusScore = 0.0,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final today = DateTime.now();
      final dateKey =
          '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

      final statsData = {
        'userId': userId,
        'date': dateKey,
        'totalStudyTime': totalStudyTime,
        'subjects': subjects,
        'completedTasks': completedTasks,
        'totalTasks': totalTasks,
        'pomodoroSessions': pomodoroSessions,
        'focusScore': focusScore,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection('study_stats')
          .doc(userId)
          .collection('daily')
          .doc(dateKey)
          .set(statsData, SetOptions(merge: true));

      // Update user's total study time
      await _firestore.collection('users').doc(userId).update({
        'totalStudyTime': FieldValue.increment(totalStudyTime),
        'completedTasks': FieldValue.increment(completedTasks),
        'totalTasks': FieldValue.increment(totalTasks),
      });

      if (kDebugMode) {
        print('✅ Study stats saved to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving study stats: $e');
      }
      rethrow;
    }
  }

  /// Get study statistics for a date range
  Future<List<Map<String, dynamic>>> getStudyStats({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];

      Query query = _firestore
          .collection('study_stats')
          .doc(userId)
          .collection('daily');

      if (startDate != null) {
        final startKey =
            '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
        query = query.where(
          FieldPath.documentId,
          isGreaterThanOrEqualTo: startKey,
        );
      }

      if (endDate != null) {
        final endKey =
            '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
        query = query.where(FieldPath.documentId, isLessThanOrEqualTo: endKey);
      }

      final querySnapshot = await query.get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting study stats: $e');
      }
      return [];
    }
  }

  // ==================== STUDY GOALS DATA ====================

  /// Save study goal
  Future<void> saveStudyGoal({
    required String title,
    required String description,
    required String subject,
    required DateTime targetDate,
    required int dailyStudyTime, // in minutes
    required int weeklyTasks,
    double progress = 0.0,
    bool isCompleted = false,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final goalData = {
        'userId': userId,
        'title': title,
        'description': description,
        'subject': subject,
        'targetDate': Timestamp.fromDate(targetDate),
        'dailyStudyTime': dailyStudyTime,
        'weeklyTasks': weeklyTasks,
        'progress': progress,
        'isCompleted': isCompleted,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('study_goals').add(goalData);

      if (kDebugMode) {
        print('✅ Study goal saved to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving study goal: $e');
      }
      rethrow;
    }
  }

  /// Get user study goals
  Future<List<Map<String, dynamic>>> getUserGoals() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final querySnapshot =
          await _firestore
              .collection('study_goals')
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting study goals: $e');
      }
      return [];
    }
  }

  /// Update goal progress
  Future<void> updateGoalProgress(
    String goalId,
    double progress,
    bool isCompleted,
  ) async {
    try {
      await _firestore.collection('study_goals').doc(goalId).update({
        'progress': progress,
        'isCompleted': isCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (kDebugMode) {
        print('✅ Goal progress updated');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error updating goal progress: $e');
      }
      rethrow;
    }
  }

  // ==================== QUIZ RESULTS DATA ====================

  /// Save quiz result
  Future<void> saveQuizResult({
    required String title,
    required String subject,
    required int totalQuestions,
    required int correctAnswers,
    required int timeSpent, // in seconds
    required double score, // percentage
    required List<Map<String, dynamic>> questions,
  }) async {
    try {
      final userId = currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final quizData = {
        'userId': userId,
        'title': title,
        'subject': subject,
        'totalQuestions': totalQuestions,
        'correctAnswers': correctAnswers,
        'timeSpent': timeSpent,
        'score': score,
        'questions': questions,
        'completedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('quizzes').add(quizData);

      if (kDebugMode) {
        print('✅ Quiz result saved to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error saving quiz result: $e');
      }
      rethrow;
    }
  }

  /// Get user quiz results
  Future<List<Map<String, dynamic>>> getUserQuizResults() async {
    try {
      final userId = currentUserId;
      if (userId == null) return [];

      final querySnapshot =
          await _firestore
              .collection('quizzes')
              .where('userId', isEqualTo: userId)
              .orderBy('completedAt', descending: true)
              .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting quiz results: $e');
      }
      return [];
    }
  }

  // ==================== SYNC UTILITIES ====================

  /// Sync local data to Firebase
  Future<void> syncLocalDataToFirebase() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Sync Pomodoro settings (for backup purposes)
      final pomodoroSettings = {
        'workTime': prefs.getInt('pomodoro_work_time') ?? 25,
        'breakTime': prefs.getInt('pomodoro_break_time') ?? 5,
        'longBreakTime': prefs.getInt('pomodoro_long_break_time') ?? 15,
        'sessionsBeforeLongBreak':
            prefs.getInt('pomodoro_sessions_before_long_break') ?? 4,
        'dailyGoal': prefs.getInt('pomodoro_daily_goal') ?? 8,
        'selectedMusic':
            prefs.getString('pomodoro_selected_music') ?? 'Lo-fi Beats',
      };

      final userId = currentUserId;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'pomodoroSettings': pomodoroSettings,
          'lastSyncAt': FieldValue.serverTimestamp(),
        });
      }

      if (kDebugMode) {
        print('✅ Local data synced to Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing local data: $e');
      }
    }
  }

  /// Get data from Firebase and update local cache
  Future<void> syncFirebaseDataToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final userId = currentUserId;
      if (userId != null) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data()!;

          // Sync Pomodoro settings back to local
          if (userData['pomodoroSettings'] != null) {
            final pomodoroSettings =
                userData['pomodoroSettings'] as Map<String, dynamic>;
            await prefs.setInt(
              'pomodoro_work_time',
              pomodoroSettings['workTime'] ?? 25,
            );
            await prefs.setInt(
              'pomodoro_break_time',
              pomodoroSettings['breakTime'] ?? 5,
            );
            await prefs.setInt(
              'pomodoro_long_break_time',
              pomodoroSettings['longBreakTime'] ?? 15,
            );
            await prefs.setInt(
              'pomodoro_sessions_before_long_break',
              pomodoroSettings['sessionsBeforeLongBreak'] ?? 4,
            );
            await prefs.setInt(
              'pomodoro_daily_goal',
              pomodoroSettings['dailyGoal'] ?? 8,
            );
            await prefs.setString(
              'pomodoro_selected_music',
              pomodoroSettings['selectedMusic'] ?? 'Lo-fi Beats',
            );
          }
        }
      }

      if (kDebugMode) {
        print('✅ Firebase data synced to local');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error syncing Firebase data: $e');
      }
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Check if Firebase is connected
  Future<bool> isConnected() async {
    try {
      await _firestore.runTransaction((transaction) async {
        return null;
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Clear all user data (for testing/debugging)
  Future<void> clearUserData() async {
    try {
      final userId = currentUserId;
      if (userId == null) return;

      // Delete user's schedules
      final schedulesSnapshot =
          await _firestore
              .collection('schedules')
              .where('userId', isEqualTo: userId)
              .get();

      for (var doc in schedulesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user's study stats
      final statsSnapshot =
          await _firestore
              .collection('study_stats')
              .doc(userId)
              .collection('daily')
              .get();

      for (var doc in statsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user's goals
      final goalsSnapshot =
          await _firestore
              .collection('study_goals')
              .where('userId', isEqualTo: userId)
              .get();

      for (var doc in goalsSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user's quiz results
      final quizzesSnapshot =
          await _firestore
              .collection('quizzes')
              .where('userId', isEqualTo: userId)
              .get();

      for (var doc in quizzesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Delete user profile
      await _firestore.collection('users').doc(userId).delete();

      if (kDebugMode) {
        print('✅ User data cleared from Firebase');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error clearing user data: $e');
      }
    }
  }
}
