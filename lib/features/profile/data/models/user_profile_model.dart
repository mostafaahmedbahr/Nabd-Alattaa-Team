import 'package:equatable/equatable.dart';

import '../../../../core/constants/firestore_constants.dart';

class UserProfileModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String position;
  final String role;
  final bool isBreakFast;
  final int points;
  final DateTime createdAt;

  const UserProfileModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.department = '',
    this.position = '',
    this.role = 'employee',
    required this.isBreakFast ,
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
      isBreakFast: map[FirestoreConstants.isBreakFast] ?? false,
      role: map[FirestoreConstants.userRole] ?? 'employee',
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
      FirestoreConstants.userRole: role,
      FirestoreConstants.isBreakFast: isBreakFast,
      FirestoreConstants.userPoints: points,
      FirestoreConstants.userCreatedAt: createdAt,
    };
  }

  bool get isAdmin =>
      role == UserRole.superAdmin ||
      role == UserRole.manager ||
      role == 'admin';

  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? position,
    String? role,
    bool? isBreakFast,
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
      role: role ?? this.role,
      isBreakFast: isBreakFast ?? this.isBreakFast,
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
        role,
    isBreakFast,
        points,
        createdAt,
      ];
}
