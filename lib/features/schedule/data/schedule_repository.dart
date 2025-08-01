import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/schedule_model.dart';

abstract class ScheduleRepository {
  Future<List<ScheduleModel>> getSchedules();
  Future<ScheduleModel?> getScheduleById(String id);
  Future<String?> createSchedule(ScheduleModel schedule);
  Future<String?> updateSchedule(ScheduleModel schedule);
  Future<String?> deleteSchedule(String id);
  Future<List<ScheduleModel>> getSchedulesByDate(DateTime date);
  Future<List<ScheduleModel>> getSmartSuggestions();
  Future<List<ScheduleModel>> getConflictingSchedules(
    ScheduleModel newSchedule,
  );
  Future<List<ScheduleModel>> getTodaySchedules();
  Future<List<ScheduleModel>> getUpcomingSchedules();
  Future<String?> markScheduleCompleted(String id);
}

class ScheduleRepositoryImpl implements ScheduleRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get _userId {
    final currentUser = _auth.currentUser;
    if (currentUser != null && currentUser.uid.isNotEmpty) {
      return currentUser.uid;
    }
    // Fallback to a default user ID for demo purposes
    return 'demo_user_123';
  }

  @override
  Future<List<ScheduleModel>> getSchedules() async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('schedules')
              .orderBy('startTime')
              .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting schedules: $e');
      return [];
    }
  }

  @override
  Future<ScheduleModel?> getScheduleById(String id) async {
    try {
      final doc =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('schedules')
              .doc(id)
              .get();

      if (doc.exists) {
        return ScheduleModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error getting schedule by id: $e');
      return null;
    }
  }

  @override
  Future<String?> createSchedule(ScheduleModel schedule) async {
    try {
      // Check for conflicts
      final conflicts = await getConflictingSchedules(schedule);
      if (conflicts.isNotEmpty) {
        return 'Schedule conflicts with existing events: ${conflicts.map((c) => c.title).join(', ')}';
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('schedules')
          .add(schedule.toMap());

      return null;
    } catch (e) {
      print('Error creating schedule: $e');
      return 'Failed to create schedule';
    }
  }

  @override
  Future<String?> updateSchedule(ScheduleModel schedule) async {
    try {
      // Check for conflicts (excluding current schedule)
      final conflicts = await getConflictingSchedules(schedule);
      final otherConflicts =
          conflicts.where((c) => c.id != schedule.id).toList();
      if (otherConflicts.isNotEmpty) {
        return 'Schedule conflicts with existing events: ${otherConflicts.map((c) => c.title).join(', ')}';
      }

      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('schedules')
          .doc(schedule.id)
          .update(schedule.toMap());

      return null;
    } catch (e) {
      print('Error updating schedule: $e');
      return 'Failed to update schedule';
    }
  }

  @override
  Future<String?> deleteSchedule(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('schedules')
          .doc(id)
          .delete();

      return null;
    } catch (e) {
      print('Error deleting schedule: $e');
      return 'Failed to delete schedule';
    }
  }

  @override
  Future<List<ScheduleModel>> getSchedulesByDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('schedules')
              .where(
                'startTime',
                isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
              )
              .where('startTime', isLessThan: endOfDay.toIso8601String())
              .orderBy('startTime')
              .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting schedules by date: $e');
      return [];
    }
  }

  @override
  Future<List<ScheduleModel>> getSmartSuggestions() async {
    try {
      final allSchedules = await getSchedules();
      final now = DateTime.now();

      // Filter upcoming schedules
      final upcoming =
          allSchedules
              .where((schedule) => schedule.startTime.isAfter(now))
              .toList();

      // Sort by smart priority score
      upcoming.sort(
        (a, b) => b.smartPriorityScore.compareTo(a.smartPriorityScore),
      );

      return upcoming.take(5).toList(); // Return top 5 suggestions
    } catch (e) {
      print('Error getting smart suggestions: $e');
      return [];
    }
  }

  @override
  Future<List<ScheduleModel>> getConflictingSchedules(
    ScheduleModel newSchedule,
  ) async {
    try {
      final allSchedules = await getSchedules();
      final conflicts = <ScheduleModel>[];

      for (final existing in allSchedules) {
        if (existing.id == newSchedule.id) continue; // Skip self

        // Check if schedules overlap
        if (_schedulesOverlap(existing, newSchedule)) {
          conflicts.add(existing);
        }
      }

      return conflicts;
    } catch (e) {
      print('Error checking conflicts: $e');
      return [];
    }
  }

  bool _schedulesOverlap(ScheduleModel schedule1, ScheduleModel schedule2) {
    // Check if two schedules overlap in time
    return schedule1.startTime.isBefore(schedule2.endTime) &&
        schedule2.startTime.isBefore(schedule1.endTime);
  }

  @override
  Future<List<ScheduleModel>> getTodaySchedules() async {
    return getSchedulesByDate(DateTime.now());
  }

  @override
  Future<List<ScheduleModel>> getUpcomingSchedules() async {
    try {
      final now = DateTime.now();
      final snapshot =
          await _firestore
              .collection('users')
              .doc(_userId)
              .collection('schedules')
              .where('startTime', isGreaterThan: now.toIso8601String())
              .orderBy('startTime')
              .limit(10)
              .get();

      return snapshot.docs
          .map((doc) => ScheduleModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error getting upcoming schedules: $e');
      return [];
    }
  }

  @override
  Future<String?> markScheduleCompleted(String id) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('schedules')
          .doc(id)
          .update({
            'isCompleted': true,
            'completedAt': DateTime.now().toIso8601String(),
            'updatedAt': DateTime.now().toIso8601String(),
          });

      return null;
    } catch (e) {
      print('Error marking schedule completed: $e');
      return 'Failed to mark schedule as completed';
    }
  }
}
