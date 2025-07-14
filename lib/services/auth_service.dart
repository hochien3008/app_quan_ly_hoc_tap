import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class AuthService {
  // Đăng ký
  Future<String?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(username);

      // Lưu username -> email
      await _firestore.collection('usernames').doc(username).set({
        'email': email,
      });

      return null;
    } catch (e) {
      if (e is FirebaseAuthException) {
        return e.message ?? 'Lỗi không xác định';
      }
      return 'Lỗi: ${e.toString()}';
    }
  }

  // Đăng nhập bằng username
  Future<String?> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      final snapshot =
          await _firestore.collection('usernames').doc(username).get();

      if (!snapshot.exists) {
        return 'Tên đăng nhập không tồn tại';
      }

      final email = snapshot.data()?['email'];

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return null;
    } catch (e) {
      if (e is FirebaseAuthException) {
        return e.message ?? 'Lỗi không xác định';
      }
      return 'Lỗi: ${e.toString()}';
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
