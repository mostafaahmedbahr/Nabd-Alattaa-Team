import 'package:equatable/equatable.dart';

class RegisterModel extends Equatable {
  final String name;
  final String email;
  final String phone;
  final String password;
  final int age;
  final String department;
  final String gender;
  final DateTime birthDate;

  const RegisterModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.age,
    required this.department,
    required this.gender,
    required this.birthDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_name': name,
      'user_email': email,
      'user_phone': phone,
      'age': age,
      'user_department': department,
      'gender': gender,
      'birth_date': birthDate,
      'user_role': 'employee',
      'user_position': '',
      'is_active': true,
      'points': 0,
      'created_at': DateTime.now(),
    };
  }

  @override
  List<Object?> get props => [
        name, email, phone, password,
        age, department, gender, birthDate,
      ];
}
