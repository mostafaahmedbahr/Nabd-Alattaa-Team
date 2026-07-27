import 'package:equatable/equatable.dart';

class ReportCommentModel extends Equatable {
  final String id;
  final String reportId;
  final String userId;
  final String userName;
  final String content;
  final DateTime createdAt;

  const ReportCommentModel({
    required this.id,
    required this.reportId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.createdAt,
  });

  factory ReportCommentModel.fromMap(Map<String, dynamic> map) {
    return ReportCommentModel(
      id: map['id'] ?? '',
      reportId: map['report_id'] ?? '',
      userId: map['user_id'] ?? '',
      userName: map['user_name'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'report_id': reportId,
      'user_id': userId,
      'user_name': userName,
      'content': content,
      'created_at': createdAt,
    };
  }

  @override
  List<Object?> get props => [id, reportId, userId, userName, content, createdAt];
}
