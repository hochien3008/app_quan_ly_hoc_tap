import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/group_model.dart';

abstract class GroupsRepository {
  Future<List<GroupModel>> getGroups(String userId);
  Stream<List<GroupModel>> getGroupsStream(String userId);
  Future<GroupModel?> getGroupById(String groupId);
  Future<String> createGroup(GroupModel group);
  Future<void> updateGroup(GroupModel group);
  Future<void> deleteGroup(String groupId);
  Future<void> joinGroup(String groupId, String userId);
  Future<void> leaveGroup(String groupId, String userId);
  Future<void> addMember(String groupId, String userId);
  Future<void> removeMember(String groupId, String userId);
  Future<void> addAdmin(String groupId, String userId);
  Future<void> removeAdmin(String groupId, String userId);
  Future<List<GroupModel>> searchGroups(String query);
  Future<List<GroupModel>> getPublicGroups();
  Future<List<GroupInvitation>> getGroupInvitations(String userId);
  Future<String> sendGroupInvitation(GroupInvitation invitation);
  Future<void> respondToInvitation(String invitationId, String response);
}

class GroupsRepositoryImpl implements GroupsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<GroupModel>> getGroups(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('groups')
              .where('memberIds', arrayContains: userId)
              .orderBy('lastActivityAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => GroupModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<List<GroupModel>> getGroupsStream(String userId) {
    return _firestore
        .collection('groups')
        .where('memberIds', arrayContains: userId)
        .orderBy('lastActivityAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => GroupModel.fromMap({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  @override
  Future<GroupModel?> getGroupById(String groupId) async {
    try {
      final doc = await _firestore.collection('groups').doc(groupId).get();
      if (doc.exists) {
        return GroupModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> createGroup(GroupModel group) async {
    try {
      final docRef = await _firestore.collection('groups').add(group.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create group: $e');
    }
  }

  @override
  Future<void> updateGroup(GroupModel group) async {
    try {
      final updatedGroup = group.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection('groups')
          .doc(group.id)
          .update(updatedGroup.toMap());
    } catch (e) {
      throw Exception('Failed to update group: $e');
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      await _firestore.collection('groups').doc(groupId).delete();
    } catch (e) {
      throw Exception('Failed to delete group: $e');
    }
  }

  @override
  Future<void> joinGroup(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayUnion([userId]),
        'lastActivityAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to join group: $e');
    }
  }

  @override
  Future<void> leaveGroup(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayRemove([userId]),
        'adminIds': FieldValue.arrayRemove([userId]),
        'lastActivityAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to leave group: $e');
    }
  }

  @override
  Future<void> addMember(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayUnion([userId]),
        'lastActivityAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add member: $e');
    }
  }

  @override
  Future<void> removeMember(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'memberIds': FieldValue.arrayRemove([userId]),
        'adminIds': FieldValue.arrayRemove([userId]),
        'lastActivityAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to remove member: $e');
    }
  }

  @override
  Future<void> addAdmin(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'adminIds': FieldValue.arrayUnion([userId]),
        'lastActivityAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to add admin: $e');
    }
  }

  @override
  Future<void> removeAdmin(String groupId, String userId) async {
    try {
      await _firestore.collection('groups').doc(groupId).update({
        'adminIds': FieldValue.arrayRemove([userId]),
        'lastActivityAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to remove admin: $e');
    }
  }

  @override
  Future<List<GroupModel>> searchGroups(String query) async {
    try {
      // Simple search implementation - can be enhanced with Algolia or similar
      final querySnapshot =
          await _firestore
              .collection('groups')
              .where('privacy', isEqualTo: 'public')
              .get();

      final allGroups =
          querySnapshot.docs
              .map((doc) => GroupModel.fromMap({...doc.data(), 'id': doc.id}))
              .toList();

      final lowercaseQuery = query.toLowerCase();
      return allGroups.where((group) {
        return group.name.toLowerCase().contains(lowercaseQuery) ||
            group.description.toLowerCase().contains(lowercaseQuery) ||
            group.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<GroupModel>> getPublicGroups() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('groups')
              .where('privacy', isEqualTo: 'public')
              .orderBy('createdAt', descending: true)
              .limit(50)
              .get();

      return querySnapshot.docs
          .map((doc) => GroupModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<GroupInvitation>> getGroupInvitations(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('group_invitations')
              .where('inviteeId', isEqualTo: userId)
              .where('status', isEqualTo: 'pending')
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => GroupInvitation.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<String> sendGroupInvitation(GroupInvitation invitation) async {
    try {
      final docRef = await _firestore
          .collection('group_invitations')
          .add(invitation.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to send invitation: $e');
    }
  }

  @override
  Future<void> respondToInvitation(String invitationId, String response) async {
    try {
      final status = response == 'accept' ? 'accepted' : 'declined';
      await _firestore.collection('group_invitations').doc(invitationId).update(
        {'status': status, 'respondedAt': DateTime.now().toIso8601String()},
      );

      if (response == 'accept') {
        // Get invitation details and add user to group
        final doc =
            await _firestore
                .collection('group_invitations')
                .doc(invitationId)
                .get();
        if (doc.exists) {
          final invitation = GroupInvitation.fromMap({
            ...doc.data()!,
            'id': doc.id,
          });
          await joinGroup(invitation.groupId, invitation.inviteeId);
        }
      }
    } catch (e) {
      throw Exception('Failed to respond to invitation: $e');
    }
  }
}
