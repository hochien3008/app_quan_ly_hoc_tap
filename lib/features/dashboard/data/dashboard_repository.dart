import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/dashboard_model.dart';

abstract class DashboardRepository {
  Future<DashboardModel?> getDashboardData(String userId);
  Stream<DashboardModel?> getDashboardStream(String userId);
  Future<void> updateStudyTime(String userId, int minutes);
  Future<void> addRecentActivity(String userId, RecentActivity activity);
}

class DashboardRepositoryImpl implements DashboardRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<DashboardModel?> getDashboardData(String userId) async {
    try {
      final doc = await _firestore.collection('dashboards').doc(userId).get();
      if (doc.exists) {
        return DashboardModel.fromMap({...doc.data()!, 'userId': doc.id});
      }
      return null;
    } catch (e) {
      // Handle error
      return null;
    }
  }

  @override
  Stream<DashboardModel?> getDashboardStream(String userId) {
    return _firestore.collection('dashboards').doc(userId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return DashboardModel.fromMap({...doc.data()!, 'userId': doc.id});
      }
      return null;
    });
  }

  @override
  Future<void> updateStudyTime(String userId, int minutes) async {
    try {
      final docRef = _firestore.collection('dashboards').doc(userId);

      await _firestore.runTransaction((transaction) async {
        final doc = await transaction.get(docRef);

        if (doc.exists) {
          final currentTotal = doc.data()?['totalStudyTime'] ?? 0;
          final currentToday = doc.data()?['todayStudyTime'] ?? 0;

          transaction.update(docRef, {
            'totalStudyTime': currentTotal + minutes,
            'todayStudyTime': currentToday + minutes,
          });
        } else {
          // Create new dashboard document
          transaction.set(docRef, {
            'userId': userId,
            'totalStudyTime': minutes,
            'todayStudyTime': minutes,
            'totalTasks': 0,
            'completedTasks': 0,
            'pendingTasks': 0,
            'upcomingTasks': [],
            'recentActivities': [],
            'studyStats': {
              'totalSessions': 1,
              'thisWeekSessions': 1,
              'averageSessionLength': minutes.toDouble(),
              'longestStreak': 1,
              'currentStreak': 1,
            },
          });
        }
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Future<void> addRecentActivity(String userId, RecentActivity activity) async {
    try {
      final docRef = _firestore.collection('dashboards').doc(userId);

      await docRef.update({
        'recentActivities': FieldValue.arrayUnion([activity.toMap()]),
      });
    } catch (e) {
      // Handle error
    }
  }
}
