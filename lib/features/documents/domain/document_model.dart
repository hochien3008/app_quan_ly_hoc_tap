class DocumentModel {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String fileName;
  final String fileUrl;
  final String fileType; // 'pdf', 'doc', 'docx', 'txt', 'image', etc.
  final int fileSize; // in bytes
  final String subject;
  final List<String> tags;
  final String
  category; // 'lecture_notes', 'assignment', 'exam', 'research', 'other'
  final bool isPublic;
  final int downloadCount;
  final double? rating;
  final int ratingCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastAccessedAt;

  DocumentModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.fileSize,
    required this.subject,
    required this.tags,
    required this.category,
    required this.isPublic,
    required this.downloadCount,
    this.rating,
    required this.ratingCount,
    required this.createdAt,
    required this.updatedAt,
    this.lastAccessedAt,
  });

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      fileName: map['fileName'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileType: map['fileType'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      subject: map['subject'] ?? '',
      tags: List<String>.from(map['tags'] ?? []),
      category: map['category'] ?? 'other',
      isPublic: map['isPublic'] ?? false,
      downloadCount: map['downloadCount'] ?? 0,
      rating: map['rating']?.toDouble(),
      ratingCount: map['ratingCount'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      lastAccessedAt:
          map['lastAccessedAt'] != null
              ? DateTime.parse(map['lastAccessedAt'])
              : null,
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
      'fileType': fileType,
      'fileSize': fileSize,
      'subject': subject,
      'tags': tags,
      'category': category,
      'isPublic': isPublic,
      'downloadCount': downloadCount,
      'rating': rating,
      'ratingCount': ratingCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastAccessedAt': lastAccessedAt?.toIso8601String(),
    };
  }

  DocumentModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    String? fileName,
    String? fileUrl,
    String? fileType,
    int? fileSize,
    String? subject,
    List<String>? tags,
    String? category,
    bool? isPublic,
    int? downloadCount,
    double? rating,
    int? ratingCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastAccessedAt,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      fileName: fileName ?? this.fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      subject: subject ?? this.subject,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      isPublic: isPublic ?? this.isPublic,
      downloadCount: downloadCount ?? this.downloadCount,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastAccessedAt: lastAccessedAt ?? this.lastAccessedAt,
    );
  }

  String get formattedFileSize {
    if (fileSize < 1024) {
      return '${fileSize} B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  String get fileExtension {
    final parts = fileName.split('.');
    return parts.length > 1 ? parts.last.toLowerCase() : '';
  }

  bool get isImage {
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(fileExtension);
  }

  bool get isPdf => fileExtension == 'pdf';
  bool get isWord => ['doc', 'docx'].contains(fileExtension);
  bool get isText => ['txt', 'md'].contains(fileExtension);

  String get formattedRating {
    if (rating == null || ratingCount == 0) return 'No ratings';
    return '${rating!.toStringAsFixed(1)} (${ratingCount} reviews)';
  }

  bool get hasRating => rating != null && ratingCount > 0;
}

class DocumentCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int documentCount;

  DocumentCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.documentCount,
  });

  factory DocumentCategory.fromMap(Map<String, dynamic> map) {
    return DocumentCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      documentCount: map['documentCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'documentCount': documentCount,
    };
  }
}

class DocumentSearchResult {
  final DocumentModel document;
  final double relevanceScore;
  final List<String> matchedFields;

  DocumentSearchResult({
    required this.document,
    required this.relevanceScore,
    required this.matchedFields,
  });

  factory DocumentSearchResult.fromMap(Map<String, dynamic> map) {
    return DocumentSearchResult(
      document: DocumentModel.fromMap(map['document']),
      relevanceScore: (map['relevanceScore'] ?? 0.0).toDouble(),
      matchedFields: List<String>.from(map['matchedFields'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'document': document.toMap(),
      'relevanceScore': relevanceScore,
      'matchedFields': matchedFields,
    };
  }
}
