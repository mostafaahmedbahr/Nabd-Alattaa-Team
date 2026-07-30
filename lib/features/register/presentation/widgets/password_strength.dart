import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final strength = _calculateStrength(password);
    final (color, text) = _getStrengthInfo(strength);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index < strength ? color : AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'قوة كلمة المرور: $text',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: color,
          ),
        ),
      ],
    );
  }

  int _calculateStrength(String password) {
    int strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;
    return strength;
  }

  (Color, String) _getStrengthInfo(int strength) {
    if (strength <= 1) {
      return (AppColors.error, 'ضعيفة');
    } else if (strength <= 2) {
      return (AppColors.warning, 'متوسطة');
    } else if (strength <= 3) {
      return (AppColors.info, 'جيد');
    } else {
      return (AppColors.success, 'قوية');
    }
  }
}