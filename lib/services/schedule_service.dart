import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quan_ly_hoc_tap/controllers/models/scheduleentry.dart';

class ScheduleService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  /// Lưu entry vào đúng ngày của người dùng
  Future<void> addScheduleEntry(String date, ScheduleEntry entry) async {
    if (userId == null) return;

    final docRef = _firestore.collection('schedule').doc(userId);
    await docRef.set({
      date: FieldValue.arrayUnion([entry.toMap()]),
    }, SetOptions(merge: true)); // Gộp vào mảng ngày đó
  }

  /// Lấy danh sách entry theo ngày
  Future<List<ScheduleEntry>> getScheduleForDate(String date) async {
    if (userId == null) return [];

    final doc = await _firestore.collection('schedule').doc(userId).get();

    if (doc.exists && doc.data() != null && doc.data()![date] != null) {
      final List<dynamic> raw = doc.data()![date];
      return raw
          .map((e) => ScheduleEntry.fromMap(Map<String, dynamic>.from(e)))
          .toList();
    }

    return [];
  }
}
