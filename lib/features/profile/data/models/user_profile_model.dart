import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class UserProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String position;
  final int points;
  final DateTime createdAt;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.department = '',
    this.position = '',
    this.points = 0,
    required this.createdAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      id: map[FirestoreConstants.userId] ?? '',
      name: map[FirestoreConstants.userName] ?? '',
      email: map[FirestoreConstants.userEmail] ?? '',
      phone: map[FirestoreConstants.userPhone] ?? '',
      department: map[FirestoreConstants.userDepartment] ?? '',
      position: map[FirestoreConstants.userPosition] ?? '',
      points: map[FirestoreConstants.userPoints] ?? 0,
      createdAt: map[FirestoreConstants.userCreatedAt]?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      FirestoreConstants.userId: id,
      FirestoreConstants.userName: name,
      FirestoreConstants.userEmail: email,
      FirestoreConstants.userPhone: phone,
      FirestoreConstants.userDepartment: department,
      FirestoreConstants.userPosition: position,
      FirestoreConstants.userPoints: points,
      FirestoreConstants.userCreatedAt: createdAt,
    };
  }

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? position,
    int? points,
    DateTime? createdAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      position: position ?? this.position,
      points: points ?? this.points,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        department,
        position,
        points,
        createdAt,
      ];
}
