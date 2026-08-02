import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RegisterModel extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? password; // Added for registration only
  final String role;
  final String department;
  final String position;
  final bool isActive;
  final String? fcmToken;
  final DateTime? createdAt;
  final int points;
  final String gender;
  final DateTime birthDate;
  final int age;

  const RegisterModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.password, // Optional - used only during registration
    this.role = 'employee',
    this.department = '',
    this.position = '',
    this.isActive = true,
    this.fcmToken,
    this.createdAt,
    this.points = 0,
    required this.gender,
    required this.birthDate,
    required this.age,
  });

  factory RegisterModel.fromMap(Map<String, dynamic> map) {
    return RegisterModel(
      id: map['user_id'] ?? '',
      name: map['user_name'] ?? '',
      email: map['user_email'] ?? '',
      phone: map['user_phone'] ?? '',
      role: map['user_role'] ?? 'employee',
      department: map['user_department'] ?? '',
      position: map['user_position'] ?? '',
      isActive: map['is_active'] ?? false,
      fcmToken: map['fcm_token'],
      createdAt: map['created_at']?.toDate() ?? DateTime.now(),
      points: map['points'] ?? 0,
      gender: map['gender'] ?? '',
      birthDate: map['birth_date']?.toDate() ?? DateTime.now(),
      age: map['age'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'user_id': id,
      'user_name': name,
      'user_email': email,
      'user_phone': phone,
      'user_role': role,
      'user_department': department,
      'user_position': position,
      'is_active': isActive,
      'fcm_token': fcmToken,
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'points': points,
      'gender': gender,
      'birth_date': birthDate,
      'age': age,
    };
  }

  // Remove password from copyWith - it shouldn't be copied
  RegisterModel copyWith({
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
    String? gender,
    DateTime? birthDate,
    int? age,
  }) {
    return RegisterModel(
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
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
    );
  }

  bool get isManager => role == 'manager';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isEmployee => role == 'employee';

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    role,
    department,
    position,
    isActive,
    fcmToken,
    createdAt,
    points,
    gender,
    birthDate,
    age,
  ];
}