import 'package:cloud_firestore/cloud_firestore.dart';

enum GroupType { study, project, exam, general }

enum GroupPrivacy { public, private, inviteOnly }

class GroupModel {
  final String id;
  final String name;
  final String? description;
  final String createdBy;
  final List<String> members;
  final List<String> admins;
  final GroupType type;
  final GroupPrivacy privacy;
  final String? subject;
  final String? coverImageUrl;
  final int memberCount;
  final int maxMembers;
  final List<String> tags;
  final Map<String, dynamic> settings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? lastActivityAt;
  final bool isActive;

  GroupModel({
    required this.id,
    required this.name,
    this.description,
    required this.createdBy,
    this.members = const [],
    this.admins = const [],
    this.type = GroupType.study,
    this.privacy = GroupPrivacy.public,
    this.subject,
    this.coverImageUrl,
    this.memberCount = 0,
    this.maxMembers = 50,
    this.tags = const [],
    this.settings = const {},
    required this.createdAt,
    required this.updatedAt,
    this.lastActivityAt,
    this.isActive = true,
  });

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'],
      createdBy: map['createdBy'] ?? '',
      members: List<String>.from(map['members'] ?? []),
      admins: List<String>.from(map['admins'] ?? []),
      type: GroupType.values.firstWhere(
        (e) => e.toString() == 'GroupType.${map['type'] ?? 'study'}',
        orElse: () => GroupType.study,
      ),
      privacy: GroupPrivacy.values.firstWhere(
        (e) => e.toString() == 'GroupPrivacy.${map['privacy'] ?? 'public'}',
        orElse: () => GroupPrivacy.public,
      ),
      subject: map['subject'],
      coverImageUrl: map['coverImageUrl'],
      memberCount: map['memberCount'] ?? 0,
      maxMembers: map['maxMembers'] ?? 50,
      tags: List<String>.from(map['tags'] ?? []),
      settings: Map<String, dynamic>.from(map['settings'] ?? {}),
      createdAt:
          map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
      updatedAt:
          map['updatedAt'] != null
              ? (map['updatedAt'] as Timestamp).toDate()
              : DateTime.now(),
      lastActivityAt:
          map['lastActivityAt'] != null
              ? (map['lastActivityAt'] as Timestamp).toDate()
              : null,
      isActive: map['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'createdBy': createdBy,
      'members': members,
      'admins': admins,
      'type': type.toString().split('.').last,
      'privacy': privacy.toString().split('.').last,
      'subject': subject,
      'coverImageUrl': coverImageUrl,
      'memberCount': memberCount,
      'maxMembers': maxMembers,
      'tags': tags,
      'settings': settings,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'lastActivityAt': lastActivityAt,
      'isActive': isActive,
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    List<String>? members,
    List<String>? admins,
    GroupType? type,
    GroupPrivacy? privacy,
    String? subject,
    String? coverImageUrl,
    int? memberCount,
    int? maxMembers,
    List<String>? tags,
    Map<String, dynamic>? settings,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActivityAt,
    bool? isActive,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      members: members ?? this.members,
      admins: admins ?? this.admins,
      type: type ?? this.type,
      privacy: privacy ?? this.privacy,
      subject: subject ?? this.subject,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      memberCount: memberCount ?? this.memberCount,
      maxMembers: maxMembers ?? this.maxMembers,
      tags: tags ?? this.tags,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      isActive: isActive ?? this.isActive,
    );
  }

  bool isMember(String userId) {
    return members.contains(userId);
  }

  bool isAdmin(String userId) {
    return admins.contains(userId);
  }

  bool isCreator(String userId) {
    return createdBy == userId;
  }

  bool get isFull {
    return memberCount >= maxMembers;
  }

  bool get canJoin {
    return !isFull && isActive;
  }

  String get formattedMemberCount {
    return '$memberCount/$maxMembers thành viên';
  }

  String get formattedCreatedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt).inDays;

    if (difference == 0) return 'Hôm nay';
    if (difference == 1) return 'Hôm qua';
    if (difference < 7) return '$difference ngày trước';
    if (difference < 30) return '${(difference / 7).floor()} tuần trước';
    if (difference < 365) return '${(difference / 30).floor()} tháng trước';
    return '${(difference / 365).floor()} năm trước';
  }

  String get formattedLastActivity {
    if (lastActivityAt == null) return 'No activity yet';

    final now = DateTime.now();
    final difference = now.difference(lastActivityAt!).inMinutes;

    if (difference < 1) return 'Vừa xong';
    if (difference < 60) return '$difference phút trước';
    if (difference < 1440) return '${(difference / 60).floor()} giờ trước';
    return '${(difference / 1440).floor()} ngày trước';
  }

  bool get isPublic {
    return privacy == GroupPrivacy.public;
  }

  bool get isPrivate {
    return privacy == GroupPrivacy.private;
  }

  bool get isInviteOnly {
    return privacy == GroupPrivacy.inviteOnly;
  }
}
