import 'package:equatable/equatable.dart';

class IdeaModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String status;
  final String creatorId;
  final String creatorName;
  final int rating;
  final DateTime createdAt;
  final DateTime updatedAt;

  const IdeaModel({
    required this.id,
    required this.title,
    required this.content,
    this.status = 'pending',
    required this.creatorId,
    required this.creatorName,
    this.rating = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IdeaModel.fromMap(Map<String, dynamic> map) {
    return IdeaModel(
      id: map['idea_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      status: map['status'] ?? 'pending',
      creatorId: map['creator_id'] ?? '',
      creatorName: map['creator_name'] ?? '',
      rating: map['rating'] ?? 0,
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
      updatedAt: map['updated_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idea_id': id,
      'title': title,
      'content': content,
      'status': status,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'rating': rating,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id, title, content, status, creatorId,
        creatorName, rating, createdAt, updatedAt,
      ];
}
