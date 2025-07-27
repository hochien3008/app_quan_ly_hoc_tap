class GroupModel {
  final String id;
  final String name;
  final String description;
  final String creatorId;
  final List<String> memberIds;
  final List<String> adminIds;
  final String privacy; // 'public', 'private', 'invite_only'
  final String category; // 'study', 'project', 'social', 'academic'
  final int maxMembers;
  final String? avatarUrl;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActivityAt;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.creatorId,
    required this.memberIds,
    required this.adminIds,
    required this.privacy,
    required this.category,
    required this.maxMembers,
    this.avatarUrl,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    this.lastActivityAt,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      creatorId: map['creatorId'] ?? '',
      memberIds: List<String>.from(map['memberIds'] ?? []),
      adminIds: List<String>.from(map['adminIds'] ?? []),
      privacy: map['privacy'] ?? 'public',
      category: map['category'] ?? 'study',
      maxMembers: map['maxMembers'] ?? 50,
      avatarUrl: map['avatarUrl'],
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
      lastActivityAt:
          map['lastActivityAt'] != null
              ? DateTime.parse(map['lastActivityAt'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'creatorId': creatorId,
      'memberIds': memberIds,
      'adminIds': adminIds,
      'privacy': privacy,
      'category': category,
      'maxMembers': maxMembers,
      'avatarUrl': avatarUrl,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'lastActivityAt': lastActivityAt?.toIso8601String(),
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? creatorId,
    List<String>? memberIds,
    List<String>? adminIds,
    String? privacy,
    String? category,
    int? maxMembers,
    String? avatarUrl,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivityAt,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      creatorId: creatorId ?? this.creatorId,
      memberIds: memberIds ?? this.memberIds,
      adminIds: adminIds ?? this.adminIds,
      privacy: privacy ?? this.privacy,
      category: category ?? this.category,
      maxMembers: maxMembers ?? this.maxMembers,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
    );
  }

  int get memberCount => memberIds.length;
  bool get isFull => memberCount >= maxMembers;
  bool get isPublic => privacy == 'public';
  bool get isPrivate => privacy == 'private';
  bool get isInviteOnly => privacy == 'invite_only';
  bool get canJoin => !isFull && (isPublic || isInviteOnly);

  bool isMember(String userId) => memberIds.contains(userId);
  bool isAdmin(String userId) => adminIds.contains(userId);
  bool isCreator(String userId) => creatorId == userId;
  bool canManage(String userId) => isCreator(userId) || isAdmin(userId);
}

class GroupMessage {
  final String id;
  final String groupId;
  final String senderId;
  final String content;
  final String messageType; // 'text', 'image', 'file', 'system'
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final DateTime timestamp;
  final bool isEdited;
  final DateTime? editedAt;
  final List<String> readBy;

  GroupMessage({
    required this.id,
    required this.groupId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    required this.timestamp,
    required this.isEdited,
    this.editedAt,
    required this.readBy,
  });

  factory GroupMessage.fromMap(Map<String, dynamic> map) {
    return GroupMessage(
      id: map['id'] ?? '',
      groupId: map['groupId'] ?? '',
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      messageType: map['messageType'] ?? 'text',
      fileUrl: map['fileUrl'],
      fileName: map['fileName'],
      fileSize: map['fileSize'],
      timestamp: DateTime.parse(map['timestamp']),
      isEdited: map['isEdited'] ?? false,
      editedAt:
          map['editedAt'] != null ? DateTime.parse(map['editedAt']) : null,
      readBy: List<String>.from(map['readBy'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'senderId': senderId,
      'content': content,
      'messageType': messageType,
      'fileUrl': fileUrl,
      'fileName': fileName,
      'fileSize': fileSize,
      'timestamp': timestamp.toIso8601String(),
      'isEdited': isEdited,
      'editedAt': editedAt?.toIso8601String(),
      'readBy': readBy,
    };
  }

  GroupMessage copyWith({
    String? id,
    String? groupId,
    String? senderId,
    String? content,
    String? messageType,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    DateTime? timestamp,
    bool? isEdited,
    DateTime? editedAt,
    List<String>? readBy,
  }) {
    return GroupMessage(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      timestamp: timestamp ?? this.timestamp,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
      readBy: readBy ?? this.readBy,
    );
  }

  bool get isText => messageType == 'text';
  bool get isImage => messageType == 'image';
  bool get isFile => messageType == 'file';
  bool get isSystem => messageType == 'system';

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp).inMinutes;

    if (difference < 1) return 'Just now';
    if (difference < 60) return '$difference minutes ago';
    if (difference < 1440) return '${(difference / 60).floor()} hours ago';
    return '${(difference / 1440).floor()} days ago';
  }

  String get formattedFileSize {
    if (fileSize == null) return '';
    if (fileSize! < 1024) {
      return '${fileSize} B';
    } else if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    } else if (fileSize! < 1024 * 1024 * 1024) {
      return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(fileSize! / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}

class GroupInvitation {
  final String id;
  final String groupId;
  final String inviterId;
  final String inviteeId;
  final String status; // 'pending', 'accepted', 'declined', 'expired'
  final String? message;
  final DateTime createdAt;
  final DateTime expiresAt;
  final DateTime? respondedAt;

  GroupInvitation({
    required this.id,
    required this.groupId,
    required this.inviterId,
    required this.inviteeId,
    required this.status,
    this.message,
    required this.createdAt,
    required this.expiresAt,
    this.respondedAt,
  });

  factory GroupInvitation.fromMap(Map<String, dynamic> map) {
    return GroupInvitation(
      id: map['id'] ?? '',
      groupId: map['groupId'] ?? '',
      inviterId: map['inviterId'] ?? '',
      inviteeId: map['inviteeId'] ?? '',
      status: map['status'] ?? 'pending',
      message: map['message'],
      createdAt: DateTime.parse(map['createdAt']),
      expiresAt: DateTime.parse(map['expiresAt']),
      respondedAt:
          map['respondedAt'] != null
              ? DateTime.parse(map['respondedAt'])
              : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'groupId': groupId,
      'inviterId': inviterId,
      'inviteeId': inviteeId,
      'status': status,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'respondedAt': respondedAt?.toIso8601String(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isDeclined => status == 'declined';
  bool get isExpired =>
      status == 'expired' || DateTime.now().isAfter(expiresAt);
  bool get isValid => isPending && !isExpired;
}
