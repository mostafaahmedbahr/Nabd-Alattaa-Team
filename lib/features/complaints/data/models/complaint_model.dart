import 'package:equatable/equatable.dart';

class ComplaintModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String type;
  final bool isAnonymous;
  final String status;
  final String creatorId;
  final String creatorName;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ComplaintModel({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    this.isAnonymous = false,
    this.status = 'pending',
    required this.creatorId,
    required this.creatorName,
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ComplaintModel.fromMap(Map<String, dynamic> map) {
    return ComplaintModel(
      id: map['complaint_id'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      type: map['type'] ?? 'other',
      isAnonymous: map['is_anonymous'] ?? false,
      status: map['status'] ?? 'pending',
      creatorId: map['creator_id'] ?? '',
      creatorName: map['creator_name'] ?? '',
      assignedTo: map['assigned_to'],
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
      updatedAt: map['updated_at']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'complaint_id': id,
      'title': title,
      'content': content,
      'type': type,
      'is_anonymous': isAnonymous,
      'status': status,
      'creator_id': creatorId,
      'creator_name': creatorName,
      'assigned_to': assignedTo,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  @override
  List<Object?> get props => [
        id, title, content, type, isAnonymous, status,
        creatorId, creatorName, assignedTo, createdAt, updatedAt,
      ];
}
