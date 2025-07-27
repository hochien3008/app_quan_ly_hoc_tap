import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../domain/document_model.dart';

abstract class DocumentsRepository {
  Future<List<DocumentModel>> getDocuments(String userId);
  Stream<List<DocumentModel>> getDocumentsStream(String userId);
  Future<DocumentModel?> getDocumentById(String documentId);
  Future<String> uploadDocument(File file, DocumentModel document);
  Future<void> updateDocument(DocumentModel document);
  Future<void> deleteDocument(String documentId);
  Future<void> incrementDownloadCount(String documentId);
  Future<void> updateRating(String documentId, double rating);
  Future<List<DocumentModel>> searchDocuments(String userId, String query);
  Future<List<DocumentModel>> getDocumentsByCategory(
    String userId,
    String category,
  );
  Future<List<DocumentModel>> getPublicDocuments();
  Future<List<DocumentCategory>> getDocumentCategories();
}

class DocumentsRepositoryImpl implements DocumentsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<List<DocumentModel>> getDocuments(String userId) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('documents')
              .where('userId', isEqualTo: userId)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Stream<List<DocumentModel>> getDocumentsStream(String userId) {
    return _firestore
        .collection('documents')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) =>
                        DocumentModel.fromMap({...doc.data(), 'id': doc.id}),
                  )
                  .toList(),
        );
  }

  @override
  Future<DocumentModel?> getDocumentById(String documentId) async {
    try {
      final doc =
          await _firestore.collection('documents').doc(documentId).get();
      if (doc.exists) {
        return DocumentModel.fromMap({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String> uploadDocument(File file, DocumentModel document) async {
    try {
      // Upload file to Firebase Storage
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${document.fileName}';
      final storageRef = _storage.ref().child(
        'documents/${document.userId}/$fileName',
      );
      final uploadTask = storageRef.putFile(file);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Create document record in Firestore
      final documentWithUrl = document.copyWith(
        fileUrl: downloadUrl,
        fileSize: await file.length(),
      );

      final docRef = await _firestore
          .collection('documents')
          .add(documentWithUrl.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  @override
  Future<void> updateDocument(DocumentModel document) async {
    try {
      final updatedDocument = document.copyWith(updatedAt: DateTime.now());
      await _firestore
          .collection('documents')
          .doc(document.id)
          .update(updatedDocument.toMap());
    } catch (e) {
      throw Exception('Failed to update document: $e');
    }
  }

  @override
  Future<void> deleteDocument(String documentId) async {
    try {
      // Get document to get file URL
      final doc =
          await _firestore.collection('documents').doc(documentId).get();
      if (doc.exists) {
        final document = DocumentModel.fromMap({...doc.data()!, 'id': doc.id});

        // Delete file from Firebase Storage
        if (document.fileUrl.isNotEmpty) {
          try {
            final storageRef = _storage.refFromURL(document.fileUrl);
            await storageRef.delete();
          } catch (e) {
            // File might not exist, continue with deletion
          }
        }
      }

      // Delete document record
      await _firestore.collection('documents').doc(documentId).delete();
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  @override
  Future<void> incrementDownloadCount(String documentId) async {
    try {
      await _firestore.collection('documents').doc(documentId).update({
        'downloadCount': FieldValue.increment(1),
        'lastAccessedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to increment download count: $e');
    }
  }

  @override
  Future<void> updateRating(String documentId, double rating) async {
    try {
      final doc =
          await _firestore.collection('documents').doc(documentId).get();
      if (doc.exists) {
        final currentRating = doc.data()?['rating'] ?? 0.0;
        final currentCount = doc.data()?['ratingCount'] ?? 0;

        final newCount = currentCount + 1;
        final newRating = ((currentRating * currentCount) + rating) / newCount;

        await _firestore.collection('documents').doc(documentId).update({
          'rating': newRating,
          'ratingCount': newCount,
        });
      }
    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  @override
  Future<List<DocumentModel>> searchDocuments(
    String userId,
    String query,
  ) async {
    try {
      // Simple search implementation - can be enhanced with Algolia or similar
      final allDocuments = await getDocuments(userId);
      final lowercaseQuery = query.toLowerCase();

      return allDocuments.where((document) {
        return document.title.toLowerCase().contains(lowercaseQuery) ||
            document.description.toLowerCase().contains(lowercaseQuery) ||
            document.subject.toLowerCase().contains(lowercaseQuery) ||
            document.tags.any(
              (tag) => tag.toLowerCase().contains(lowercaseQuery),
            );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DocumentModel>> getDocumentsByCategory(
    String userId,
    String category,
  ) async {
    try {
      final querySnapshot =
          await _firestore
              .collection('documents')
              .where('userId', isEqualTo: userId)
              .where('category', isEqualTo: category)
              .orderBy('createdAt', descending: true)
              .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DocumentModel>> getPublicDocuments() async {
    try {
      final querySnapshot =
          await _firestore
              .collection('documents')
              .where('isPublic', isEqualTo: true)
              .orderBy('createdAt', descending: true)
              .limit(50) // Limit to prevent performance issues
              .get();

      return querySnapshot.docs
          .map((doc) => DocumentModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<DocumentCategory>> getDocumentCategories() async {
    try {
      final querySnapshot =
          await _firestore.collection('document_categories').get();
      return querySnapshot.docs
          .map((doc) => DocumentCategory.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      // Return default categories if none exist
      return [
        DocumentCategory(
          id: 'lecture_notes',
          name: 'Lecture Notes',
          description: 'Class notes and lecture materials',
          icon: '📝',
          documentCount: 0,
        ),
        DocumentCategory(
          id: 'assignment',
          name: 'Assignments',
          description: 'Homework and assignments',
          icon: '📋',
          documentCount: 0,
        ),
        DocumentCategory(
          id: 'exam',
          name: 'Exams',
          description: 'Exam papers and study guides',
          icon: '📚',
          documentCount: 0,
        ),
        DocumentCategory(
          id: 'research',
          name: 'Research',
          description: 'Research papers and articles',
          icon: '🔬',
          documentCount: 0,
        ),
        DocumentCategory(
          id: 'other',
          name: 'Other',
          description: 'Miscellaneous documents',
          icon: '📄',
          documentCount: 0,
        ),
      ];
    }
  }
}
