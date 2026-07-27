import 'package:equatable/equatable.dart';

class ReportModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String type;
  final String status;
  final String creatorId;
  final String creatorName;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? closedAt;

  const ReportModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.status = 'open',
    required this.creatorId,
    required this.creatorName,
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    this.closedAt,
  });

  factory ReportModel.fromMap(Map<String, dynamic> map) {
    return ReportModel(
      id: map['report_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      type: map['type'] ?? 'other',
      status: map['status'] ?? 'open',
      creatorId: map['creator_id'] ?? '',
      creatorName: map['creator_name'] ?? '',
      assignedTo: map['assigned_to'],
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
      updatedAt: map['updated_at']?.toDate() ?? DateTime.now(),
      closedAt: map['closed_at']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'report_id': id,
      'title': title,
      'content': content,
      'type': type,
      'status': status,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'assigned_to': assignedTo,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'closed_at': closedAt,
    };
  }

  @override
  List<Object?> get props => [
        id, title, content, type, status, creatorId,
        creatorName, assignedTo, createdAt, updatedAt, closedAt,
      ];
}
