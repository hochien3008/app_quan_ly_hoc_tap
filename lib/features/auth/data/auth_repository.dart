import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/auth_model.dart';

abstract class AuthRepository {
  Future<String?> register({
    required String username,
    required String email,
    required String password,
  });

  Future<String?> signInWithUsername({
    required String username,
    required String password,
  });

  Future<void> signOut();

  Future<AuthModel?> getCurrentUser();

  Stream<User?> get authStateChanges;
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(username);

      // Try to save to Firestore, but don't fail registration if it fails
      try {
        // Save username -> email mapping
        await _firestore
            .collection('usernames')
            .doc(username)
            .set({'email': email})
            .timeout(
              const Duration(seconds: 2),
              onTimeout: () {
                throw Exception('Firestore timeout');
              },
            );

        // Create user profile
        final authModel = AuthModel(
          id: userCredential.user!.uid,
          username: username,
          email: email,
          displayName: username,
          createdAt: DateTime.now(),
          lastLoginAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(authModel.id)
            .set(authModel.toMap())
            .timeout(
              const Duration(seconds: 2),
              onTimeout: () {
                throw Exception('Firestore timeout');
              },
            );
      } catch (firestoreError) {
        // Log the error but don't fail registration
        print('Failed to save user data to Firestore: $firestoreError');
        // Registration still succeeds, just without Firestore data
        // This handles timeout, network, and other Firestore errors gracefully
      }

      return null;
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            return 'Password is too weak. Please choose a stronger password';
          case 'email-already-in-use':
            return 'An account with this email already exists';
          case 'invalid-email':
            return 'Invalid email format';
          case 'operation-not-allowed':
            return 'Email/password accounts are not enabled';
          case 'network-request-failed':
            return 'Network error. Please check your connection';
          default:
            return e.message ?? 'Registration failed';
        }
      }

      if (e.toString().contains('unavailable') ||
          e.toString().contains('network') ||
          e.toString().contains('timeout') ||
          e.toString().contains('Could not reach Cloud Firestore backend')) {
        return 'Network error. Please check your connection and try again.';
      }

      return 'Registration failed. Please try again.';
    }
  }

  @override
  Future<String?> signInWithUsername({
    required String username,
    required String password,
  }) async {
    try {
      // Check if Firestore is available
      try {
        final snapshot = await _firestore
            .collection('usernames')
            .doc(username)
            .get()
            .timeout(
              const Duration(seconds: 2),
              onTimeout: () {
                throw Exception('Firestore timeout');
              },
            );

        if (!snapshot.exists) {
          return 'Username does not exist';
        }

        final email = snapshot.data()?['email'];

        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Update last login time (optional, don't fail if this fails)
        try {
          if (_auth.currentUser != null) {
            // Use set with merge to create document if it doesn't exist
            await _firestore
                .collection('users')
                .doc(_auth.currentUser!.uid)
                .set({
                  'lastLoginAt': DateTime.now().toIso8601String(),
                  'username': username,
                  'email': email,
                  'displayName': username,
                }, SetOptions(merge: true))
                .timeout(
                  const Duration(seconds: 2),
                  onTimeout: () {
                    throw Exception('Update timeout');
                  },
                );
          }
        } catch (updateError) {
          // Log but don't fail the login
          print('Failed to update last login time: $updateError');
        }

        return null;
      } catch (firestoreError) {
        // If Firestore is unavailable, try direct email login
        if (firestoreError.toString().contains('unavailable') ||
            firestoreError.toString().contains('network') ||
            firestoreError.toString().contains('timeout') ||
            firestoreError.toString().contains(
              'Could not reach Cloud Firestore backend',
            )) {
          // Try to login with username as email (fallback)
          try {
            await _auth.signInWithEmailAndPassword(
              email: username,
              password: password,
            );
            return null;
          } catch (directLoginError) {
            return 'Network error. Please check your connection and try again.';
          }
        }
        rethrow;
      }
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            return 'No user found with this username/email';
          case 'wrong-password':
            return 'Incorrect password';
          case 'invalid-email':
            return 'Invalid email format';
          case 'user-disabled':
            return 'This account has been disabled';
          case 'too-many-requests':
            return 'Too many failed attempts. Please try again later';
          case 'network-request-failed':
            return 'Network error. Please check your connection';
          default:
            return e.message ?? 'Authentication failed';
        }
      }

      if (e.toString().contains('unavailable') ||
          e.toString().contains('network') ||
          e.toString().contains('timeout') ||
          e.toString().contains('Could not reach Cloud Firestore backend')) {
        return 'Network error. Please check your connection and try again.';
      }

      return 'Login failed. Please try again.';
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  Future<AuthModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return AuthModel.fromMap({...doc.data()!, 'id': doc.id});
      }
    } catch (e) {
      // Handle error
    }
    return null;
  }

  @override
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
