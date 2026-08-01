import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String name;
  final String email;
  final String phone;
  final String? password;

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
    this.password,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String?,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      password: json['password'],

      role: json['role'] ?? '',
      department: json['department'] ?? '',
      position: json['position'] ?? '',

      isActive: json['isActive'] ?? true,
      fcmToken: json['fcmToken'],

      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,

      points: json['points'] ?? 0,
      gender: json['gender'] ?? '',
      birthDate: json['birthDate'] != null
          ? (json['birthDate'] as Timestamp).toDate()
          : DateTime.now(),
      age: json['age'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,

      'role': role,
      'department': department,
      'position': position,

      'isActive': isActive,
      'fcmToken': fcmToken,

      'createdAt': createdAt ?? FieldValue.serverTimestamp(),

      'points': points,
      'gender': gender,
      'birthDate': Timestamp.fromDate(birthDate),
      'age': age,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? password,
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
      password: password ?? this.password,
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