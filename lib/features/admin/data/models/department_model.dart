import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class DepartmentModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String managerId;
  final String managerName;

  const DepartmentModel({
    required this.id,
    required this.name,
    this.description = '',
    this.managerId = '',
    this.managerName = '',
  });

  factory DepartmentModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return DepartmentModel(
      id: docId ?? map['id'] ?? '',
      name: map[FirestoreConstants.departmentName] ?? '',
      description: map[FirestoreConstants.departmentDescription] ?? '',
      managerId: map[FirestoreConstants.departmentManagerId] ?? '',
      managerName: map[FirestoreConstants.departmentManagerName] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.departmentName: name,
      FirestoreConstants.departmentDescription: description,
      FirestoreConstants.departmentManagerId: managerId,
      FirestoreConstants.departmentManagerName: managerName,
    };
  }

  DepartmentModel copyWith({
    String? id,
    String? name,
    String? description,
    String? managerId,
    String? managerName,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      managerId: managerId ?? this.managerId,
      managerName: managerName ?? this.managerName,
    );
  }

  @override
  List<Object?> get props => [id, name, description, managerId, managerName];
}
