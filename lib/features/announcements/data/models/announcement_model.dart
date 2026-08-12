import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class AnnouncementModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String type;
  final String creatorId;
  final String creatorName;
  final bool isPinned;
  final DateTime createdAt;

  const AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.creatorId = '',
    this.creatorName = 'مستخدم',
    this.isPinned = false,
    required this.createdAt,
  });

  factory AnnouncementModel.fromMap(
    Map<String, dynamic>? map,
    String id,
  ) {
    return AnnouncementModel(
      id: id,
      title: map?[FirestoreConstants.announcementTitle] ?? '',
      content: map?[FirestoreConstants.announcementContent] ?? '',
      type: map?[FirestoreConstants.announcementType] ?? 'news',
      creatorId: map?[FirestoreConstants.announcementCreatorId] ?? '',
      creatorName: map?[FirestoreConstants.announcementCreatorName] ?? 'مستخدم',
      isPinned: map?[FirestoreConstants.announcementIsPinned] ?? false,
      createdAt: _parseDate(map?[FirestoreConstants.announcementCreatedAt]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.announcementTitle: title,
      FirestoreConstants.announcementContent: content,
      FirestoreConstants.announcementType: type,
      FirestoreConstants.announcementCreatorId: creatorId,
      FirestoreConstants.announcementCreatorName: creatorName,
      FirestoreConstants.announcementIsPinned: isPinned,
      FirestoreConstants.announcementCreatedAt: createdAt,
    };
  }

  AnnouncementModel copyWith({
    String? id,
    String? title,
    String? content,
    String? type,
    String? creatorId,
    String? creatorName,
    bool? isPinned,
    DateTime? createdAt,
  }) {
    return AnnouncementModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      isPinned: isPinned ?? this.isPinned,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        creatorId,
        creatorName,
        isPinned,
        createdAt,
      ];
}