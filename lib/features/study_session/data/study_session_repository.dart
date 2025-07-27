import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/study_session_model.dart';

abstract class StudySessionRepository {
  Future<List<StudySessionModel>> getStudySessions(String userId);
  Stream<List<StudySessionModel>> getStudySessionsStream(String userId);
  Future<StudySessionModel?> getStudySessionById(String sessionId);
  Future<String> createStudySession(StudySessionModel session);
  Future<void> updateStudySession(StudySessionModel session);
  Future<void> deleteStudySession(String sessionId);
  Future<void> pauseStudySession(String sessionId);
  Future<void> resumeStudySession(String sessionId);
  Future<void> completeStudySession(String sessionId);
  Future<void> cancelStudySession(String sessionId);
  Future<List<StudySessionModel>> getStudySessionsByDate(
    String userId,
    DateTime date,
  );
  Future<PomodoroSettings?> getPomodoroSettings(String userId);
  Future<void> updatePomodoroSettings(String userId, PomodoroSettings settings);
}

class StudySessionRepositoryImpl implements StudySessionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<StudySessionModel>> getStudySessions(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('study_sessions')
              .where('userId', isEqualTo: userId)
              .orderBy('startTime', descending: true)
              .get();

      return querySnapshot.docs
          .map(
            (doc) => StudySessionModel.fromMap({...doc.data(), 'id': doc.id}),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<List<StudySessionModel>> getStudySessionsStream(String userId) {
    return _firestore
        .collection('study_sessions')
        .where('userId', isEqualTo: userId)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => StudySessionModel.fromMap({
                      ...doc.data(),
                      'id': doc.id,
                    }),
                  )
                  .toList(),
        );
  }

  @override
  Future<StudySessionModel?> getStudySessionById(String sessionId) async {
    try {
      final doc =
          await _firestore.collection('study_sessions').doc(sessionId).get();
      if (doc.exists) {
        return StudySessionModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> createStudySession(StudySessionModel session) async {
    try {
      final docRef = await _firestore
          .collection('study_sessions')
          .add(session.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create study session: $e');
    }
  }

  @override
  Future<void> updateStudySession(StudySessionModel session) async {
    try {
      final updatedSession = session.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection('study_sessions')
          .doc(session.id)
          .update(updatedSession.toMap());
    } catch (e) {
      throw Exception('Failed to update study session: $e');
    }
  }

  @override
  Future<void> deleteStudySession(String sessionId) async {
    try {
      await _firestore.collection('study_sessions').doc(sessionId).delete();
    } catch (e) {
      throw Exception('Failed to delete study session: $e');
    }
  }

  @override
  Future<void> pauseStudySession(String sessionId) async {
    try {
      await _firestore.collection('study_sessions').doc(sessionId).update({
        'status': 'paused',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to pause study session: $e');
    }
  }

  @override
  Future<void> resumeStudySession(String sessionId) async {
    try {
      await _firestore.collection('study_sessions').doc(sessionId).update({
        'status': 'active',
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to resume study session: $e');
    }
  }

  @override
  Future<void> completeStudySession(String sessionId) async {
    try {
      await _firestore.collection('study_sessions').doc(sessionId).update({
        'status': 'completed',
        'endTime': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to complete study session: $e');
    }
  }

  @override
  Future<void> cancelStudySession(String sessionId) async {
    try {
      await _firestore.collection('study_sessions').doc(sessionId).update({
        'status': 'cancelled',
        'endTime': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to cancel study session: $e');
    }
  }

  @override
  Future<List<StudySessionModel>> getStudySessionsByDate(
    String userId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot =
          await _firestore
              .collection('study_sessions')
              .where('userId', isEqualTo: userId)
              .where(
                'startTime',
                isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
              )
              .where('startTime', isLessThan: endOfDay.toIso8601String())
              .orderBy('startTime')
              .get();

      return querySnapshot.docs
          .map(
            (doc) => StudySessionModel.fromMap({...doc.data(), 'id': doc.id}),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<PomodoroSettings?> getPomodoroSettings(String userId) async {
    try {
      final doc =
          await _firestore.collection('pomodoro_settings').doc(userId).get();
      if (doc.exists) {
        return PomodoroSettings.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updatePomodoroSettings(
    String userId,
    PomodoroSettings settings,
  ) async {
    try {
      await _firestore
          .collection('pomodoro_settings')
          .doc(userId)
          .set(settings.toMap());
    } catch (e) {
      throw Exception('Failed to update pomodoro settings: $e');
    }
  }
}
