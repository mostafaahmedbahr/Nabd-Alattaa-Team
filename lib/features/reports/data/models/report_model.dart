import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

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
      title: map[FirestoreConstants.reportTitle] ?? '',
      content: map[FirestoreConstants.reportContent] ?? '',
      type: map[FirestoreConstants.reportType] ?? 'other',
      status: map[FirestoreConstants.reportStatus] ?? 'open',
      creatorId: map[FirestoreConstants.reportCreatorId] ?? '',
      creatorName: map[FirestoreConstants.reportCreatorName] ?? '',
      assignedTo: map[FirestoreConstants.reportAssignedTo],
      createdAt: map[FirestoreConstants.reportCreatedAt]?.toDate() ?? DateTime.now(),
      updatedAt: map[FirestoreConstants.reportUpdatedAt]?.toDate() ?? DateTime.now(),
      closedAt: map[FirestoreConstants.reportClosedAt]?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'report_id': id,
      FirestoreConstants.reportTitle: title,
      FirestoreConstants.reportContent: content,
      FirestoreConstants.reportType: type,
      FirestoreConstants.reportStatus: status,
      FirestoreConstants.reportCreatorId: creatorId,
      FirestoreConstants.reportCreatorName: creatorName,
      FirestoreConstants.reportAssignedTo: assignedTo,
      FirestoreConstants.reportCreatedAt: createdAt,
      FirestoreConstants.reportUpdatedAt: updatedAt,
      FirestoreConstants.reportClosedAt: closedAt,
    };
  }

  ReportModel copyWith({
    String? id,
    String? title,
    String? content,
    String? type,
    String? status,
    String? creatorId,
    String? creatorName,
    String? assignedTo,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? closedAt,
  }) {
    return ReportModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      type: type ?? this.type,
      status: status ?? this.status,
      creatorId: creatorId ?? this.creatorId,
      creatorName: creatorName ?? this.creatorName,
      assignedTo: assignedTo ?? this.assignedTo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      closedAt: closedAt ?? this.closedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        type,
        status,
        creatorId,
        creatorName,
        assignedTo,
        createdAt,
        updatedAt,
        closedAt,
      ];
}
