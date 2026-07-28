import 'package:equatable/equatable.dart';

class LoginModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String department;
  final String position;
  final bool isActive;
  final String? fcmToken;
  final DateTime createdAt;
  final int points;

  const LoginModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    required this.role,
    this.department = '',
    this.position = '',
    this.isActive = true,
    this.fcmToken,
    required this.createdAt,
    this.points = 0,
  });

  factory LoginModel.fromMap(Map<String, dynamic> map) {
    return LoginModel(
      id: map['user_id'] ?? '',
      name: map['user_name'] ?? '',
      email: map['user_email'] ?? '',
      phone: map['user_phone'] ?? '',
      role: map['user_role'] ?? 'employee',
      department: map['user_department'] ?? '',
      position: map['user_position'] ?? '',
      isActive: map['is_active'] ?? true,
      fcmToken: map['fcm_token'],
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
      points: map['points'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': id,
      'user_name': name,
      'user_email': email,
      'user_phone': phone,
      'user_role': role,
      'user_department': department,
      'user_position': position,
      'is_active': isActive,
      'fcm_token': fcmToken,
      'created_at': createdAt,
      'points': points,
    };
  }

  LoginModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? role,
    String? department,
    String? position,
    bool? isActive,
    String? fcmToken,
    DateTime? createdAt,
    int? points,
  }) {
    return LoginModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      department: department ?? this.department,
      position: position ?? this.position,
      isActive: isActive ?? this.isActive,
      fcmToken: fcmToken ?? this.fcmToken,
      createdAt: createdAt ?? this.createdAt,
      points: points ?? this.points,
    );
  }

  bool get isManager => role == 'manager';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isEmployee => role == 'employee';

  @override
  List<Object?> get props => [
    id, name, email, phone, role, department,
    position, isActive, fcmToken, createdAt, points,
  ];
}
