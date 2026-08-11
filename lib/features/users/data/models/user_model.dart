import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
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

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.position,
    required this.isActive,
    this.fcmToken,
    this.createdAt,
    required this.points,
    required this.gender,
    required this.birthDate,
    required this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, [String? id]) {
    return UserModel(
      id: id ?? json['user_id'] as String?,
      name: json['user_name'] ?? '',
      email: json['user_email'] ?? '',
      phone: json['user_phone'] ?? '',
      role: json['user_role'] ?? '',
      department: json['user_department'] ?? '',
      position: json['user_position'] ?? '',
      isActive: json['is_active'] ?? true,
      fcmToken: json['fcm_token'],
      createdAt: json['created_at'] != null
          ? (json['created_at'] as Timestamp).toDate()
          : null,
      points: json['points'] ?? 0,
      gender: json['gender'] ?? '',
      birthDate: json['birth_date'] != null
          ? (json['birth_date'] as Timestamp).toDate()
          : DateTime.now(),
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
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
      'created_at': createdAt ?? FieldValue.serverTimestamp(),
      'points': points,
      'gender': gender,
      'birth_date': Timestamp.fromDate(birthDate),
      'age': age,
    };
  }

  UserModel copyWith({
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
    return UserModel(
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
}
