import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

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
      title: map[FirestoreConstants.complaintTitle] ?? '',
      content: map[FirestoreConstants.complaintContent] ?? '',
      type: map[FirestoreConstants.complaintType] ?? 'other',
      isAnonymous: map[FirestoreConstants.complaintIsAnonymous] ?? false,
      status: map[FirestoreConstants.complaintStatus] ?? 'pending',
      creatorId: map[FirestoreConstants.complaintCreatorId] ?? '',
      creatorName: map[FirestoreConstants.complaintCreatorName] ?? '',
      assignedTo: map[FirestoreConstants.complaintAssignedTo],
      createdAt: map[FirestoreConstants.complaintCreatedAt]?.toDate() ?? DateTime.now(),
      updatedAt: map[FirestoreConstants.complaintUpdatedAt]?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'complaint_id': id,
      FirestoreConstants.complaintTitle: title,
      FirestoreConstants.complaintContent: content,
      FirestoreConstants.complaintType: type,
      FirestoreConstants.complaintIsAnonymous: isAnonymous,
      FirestoreConstants.complaintStatus: status,
      FirestoreConstants.complaintCreatorId: creatorId,
      FirestoreConstants.complaintCreatorName: creatorName,
      FirestoreConstants.complaintAssignedTo: assignedTo,
      FirestoreConstants.complaintCreatedAt: createdAt,
      FirestoreConstants.complaintUpdatedAt: updatedAt,
    };
  }

  ComplaintModel copyWith({
    String? id,
    String? title,
    String? content,
    String? type,
    bool? isAnonymous,
    String? status,
    String? creatorId,
    String? creatorName,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ComplaintModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      status: status ?? this.status,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        isAnonymous,
        status,
        creatorId,
        creatorName,
        assignedTo,
        createdAt,
        updatedAt,
      ];
}
