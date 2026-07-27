import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class GoodDeedModel extends Equatable {
  final String id;
  final String content;
  final String creatorId;
  final int likesCount;
  final int prayersCount;
  final DateTime createdAt;

  const GoodDeedModel({
    required this.id,
    required this.content,
    required this.creatorId,
    this.likesCount = 0,
    this.prayersCount = 0,
    required this.createdAt,
  });

  factory GoodDeedModel.fromMap(Map<String, dynamic> map) {
    return GoodDeedModel(
      id: map['id'] ?? '',
      content: map[FirestoreConstants.goodDeedContent] ?? '',
      creatorId: map[FirestoreConstants.goodDeedCreatorId] ?? '',
      likesCount: map[FirestoreConstants.goodDeedLikesCount] ?? 0,
      prayersCount: map[FirestoreConstants.goodDeedPrayersCount] ?? 0,
      createdAt: map[FirestoreConstants.goodDeedCreatedAt]?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      FirestoreConstants.goodDeedContent: content,
      FirestoreConstants.goodDeedCreatorId: creatorId,
      FirestoreConstants.goodDeedLikesCount: likesCount,
      FirestoreConstants.goodDeedPrayersCount: prayersCount,
      FirestoreConstants.goodDeedCreatedAt: createdAt,
    };
  }

  GoodDeedModel copyWith({
    String? id,
    String? content,
    String? creatorId,
    int? likesCount,
    int? prayersCount,
    DateTime? createdAt,
  }) {
    return GoodDeedModel(
      id: id ?? this.id,
      content: content ?? this.content,
      creatorId: creatorId ?? this.creatorId,
      likesCount: likesCount ?? this.likesCount,
      prayersCount: prayersCount ?? this.prayersCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, content, creatorId, likesCount, prayersCount, createdAt];
}
