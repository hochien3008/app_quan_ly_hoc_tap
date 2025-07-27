import 'package:cloud_firestore/cloud_firestore.dart';

enum DocumentType { pdf, image, text, video, audio, other }

class DocumentModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String fileName;
  final String fileUrl;
  final DocumentType type;
  final int fileSize; // in bytes
  final String? subject;
  final String? category;
  final List<String> tags;
  final DateTime uploadedAt;
  final DateTime updatedAt;
  final DateTime? lastAccessedAt;
  final bool isFavorite;
  final String? thumbnailUrl;
  final String? extractedText; // For OCR processed documents

  DocumentModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.fileName,
    required this.fileUrl,
    required this.type,
    required this.fileSize,
    this.subject,
    this.category,
    this.tags = const [],
    required this.uploadedAt,
    required this.updatedAt,
    this.lastAccessedAt,
    this.isFavorite = false,
    this.thumbnailUrl,
    this.extractedText,
  });

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      fileName: map['fileName'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      type: DocumentType.values.firstWhere(
        (e) => e.toString() == 'DocumentType.${map['type'] ?? 'other'}',
        orElse: () => DocumentType.other,
      ),
      fileSize: map['fileSize'] ?? 0,
      subject: map['subject'],
      category: map['category'],
      tags: List<String>.from(map['tags'] ?? []),
      uploadedAt:
          map['uploadedAt'] != null
              ? (map['uploadedAt'] as Timestamp).toDate()
              : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.now(),
      lastAccessedAt:
          map['lastAccessedAt'] != null
              ? (map['lastAccessedAt'] as Timestamp).toDate()
              : null,
      isFavorite: map['isFavorite'] ?? false,
      thumbnailUrl: map['thumbnailUrl'],
      extractedText: map['extractedText'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'fileName': fileName,
      'fileUrl': fileUrl,
      'type': type.toString().split('.').last,
      'fileSize': fileSize,
      'subject': subject,
      'category': category,
      'tags': tags,
      'uploadedAt': uploadedAt,
      'updatedAt': updatedAt,
      'lastAccessedAt': lastAccessedAt,
      'isFavorite': isFavorite,
      'thumbnailUrl': thumbnailUrl,
      'extractedText': extractedText,
    };
  }

  DocumentModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? fileName,
    String? fileUrl,
    DocumentType? type,
    int? fileSize,
    String? subject,
    String? category,
    List<String>? tags,
    DateTime? uploadedAt,
    DateTime? updatedAt,
    DateTime? lastAccessedAt,
    bool? isFavorite,
    String? thumbnailUrl,
    String? extractedText,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      type: type ?? this.type,
      fileSize: fileSize ?? this.fileSize,
      subject: subject ?? this.subject,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
      isFavorite: isFavorite ?? this.isFavorite,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      extractedText: extractedText ?? this.extractedText,
    );
  }

  String get formattedFileSize {
    if (fileSize < 1024) return '${fileSize}B';
    if (fileSize < 1024 * 1024)
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    if (fileSize < 1024 * 1024 * 1024)
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get isImage {
    return type == DocumentType.image;
  }

  bool get isPdf {
    return type == DocumentType.pdf;
  }

  bool get isVideo {
    return type == DocumentType.video;
  }

  bool get isAudio {
    return type == DocumentType.audio;
  }

  bool get isText {
    return type == DocumentType.text;
  }

  bool get hasExtractedText {
    return extractedText != null && extractedText!.isNotEmpty;
  }

  String get formattedUploadDate {
    final now = DateTime.now();
    final difference = now.difference(uploadedAt).inDays;

    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Hôm qua';
    if (difference < 7) return '$difference ngày trước';
    if (difference < 30) return '${(difference / 7).floor()} tuần trước';
    if (difference < 365) return '${(difference / 30).floor()} tháng trước';
    return '${(difference / 365).floor()} năm trước';
  }
}
