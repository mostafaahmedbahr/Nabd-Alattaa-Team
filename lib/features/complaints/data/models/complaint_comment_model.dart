import 'package:equatable/equatable.dart';

class ComplaintCommentModel extends Equatable {
  final String id;
  final String complaintId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  const ComplaintCommentModel({
    required this.id,
    required this.complaintId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory ComplaintCommentModel.fromMap(Map<String, dynamic> map) {
    return ComplaintCommentModel(
      id: map['id'] ?? '',
      complaintId: map['complaint_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'complaint_id': complaintId,
      'user_id': userId,
      'user_name': userName,
      'content': content,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, complaintId, userId, userName, content, createdAt];
}
