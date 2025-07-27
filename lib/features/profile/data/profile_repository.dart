import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/profile_model.dart';

abstract class ProfileRepository {
  Future<ProfileModel?> getProfile(String userId);
  Stream<ProfileModel?> getProfileStream(String userId);
  Future<void> createProfile(ProfileModel profile);
  Future<void> updateProfile(ProfileModel profile);
  Future<void> deleteProfile(String userId);
  Future<void> updateLastActive(String userId);
  Future<void> updateStudyStats(String userId, ProfileStats stats);
  Future<void> updateStudyGoals(String userId, StudyGoals goals);
  Future<void> updateNotificationSettings(
    String userId,
    NotificationSettings settings,
  );
  Future<void> updatePrivacySettings(String userId, PrivacySettings settings);
  Future<List<ProfileModel>> searchProfiles(String query);
  Future<List<ProfileModel>> getPublicProfiles();
  Future<void> blockUser(String userId, String blockedUserId);
  Future<void> unblockUser(String userId, String blockedUserId);
}

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<ProfileModel?> getProfile(String userId) async {
    try {
      final doc = await _firestore.collection('profiles').doc(userId).get();
      if (doc.exists) {
        return ProfileModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Stream<ProfileModel?> getProfileStream(String userId) {
    return _firestore.collection('profiles').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return ProfileModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    });
  }

  @override
  Future<void> createProfile(ProfileModel profile) async {
    try {
      await _firestore
          .collection('profiles')
          .doc(profile.userId)
          .set(profile.toMap());
    } catch (e) {
      throw Exception('Failed to create profile: $e');
    }
  }

  @override
  Future<void> updateProfile(ProfileModel profile) async {
    try {
      final updatedProfile = profile.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection('profiles')
          .doc(profile.userId)
          .update(updatedProfile.toMap());
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> deleteProfile(String userId) async {
    try {
      await _firestore.collection('profiles').doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete profile: $e');
    }
  }

  @override
  Future<void> updateLastActive(String userId) async {
    try {
      await _firestore.collection('profiles').doc(userId).update({
        'lastActiveAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update last active: $e');
    }
  }

  @override
  Future<void> updateStudyStats(String userId, ProfileStats stats) async {
    try {
      await _firestore.collection('profiles').doc(userId).update({
        'stats': stats.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update study stats: $e');
    }
  }

  @override
  Future<void> updateStudyGoals(String userId, StudyGoals goals) async {
    try {
      await _firestore.collection('profiles').doc(userId).update({
        'studyGoals': goals.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update study goals: $e');
    }
  }

  @override
  Future<void> updateNotificationSettings(
    String userId,
    NotificationSettings settings,
  ) async {
    try {
      await _firestore.collection('profiles').doc(userId).update({
        'notificationSettings': settings.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update notification settings: $e');
    }
  }

  @override
  Future<void> updatePrivacySettings(
    String userId,
    PrivacySettings settings,
  ) async {
    try {
      await _firestore.collection('profiles').doc(userId).update({
        'privacySettings': settings.toMap(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update privacy settings: $e');
    }
  }

  @override
  Future<List<ProfileModel>> searchProfiles(String query) async {
    try {
      // Simple search implementation - can be enhanced with Algolia or similar
      final querySnapshot =
          await _firestore
              .collection('profiles')
              .where('privacySettings.profilePublic', isEqualTo: true)
              .get();

      final allProfiles =
          querySnapshot.docs
              .map((doc) => ProfileModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();

      final lowercaseQuery = query.toLowerCase();
      return allProfiles.where((profile) {
        return profile.displayName.toLowerCase().contains(lowercaseQuery) ||
            (profile.bio != null &&
                profile.bio!.toLowerCase().contains(lowercaseQuery)) ||
            (profile.institution != null &&
                profile.institution!.toLowerCase().contains(lowercaseQuery)) ||
            (profile.major != null &&
                profile.major!.toLowerCase().contains(lowercaseQuery)) ||
            profile.interests.any(
              (interest) => interest.toLowerCase().contains(lowercaseQuery),
            ) ||
            profile.skills.any(
              (skill) => skill.toLowerCase().contains(lowercaseQuery),
            );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<ProfileModel>> getPublicProfiles() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('profiles')
              .where('privacySettings.profilePublic', isEqualTo: true)
              .orderBy('lastActiveAt', descending: true)
              .limit(50)
              .get();

      return querySnapshot.docs
          .map((doc) => ProfileModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      await _firestore.collection('profiles').doc(userId).update({
        'privacySettings.blockedUsers': FieldValue.arrayUnion([blockedUserId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  @override
  Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      await _firestore.collection('profiles').doc(userId).update({
        'privacySettings.blockedUsers': FieldValue.arrayRemove([blockedUserId]),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }
}
