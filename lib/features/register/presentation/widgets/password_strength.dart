import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class PasswordStrength extends StatelessWidget {
  final String password;

  const PasswordStrength({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (password.isNotEmpty) ...[
          // شريط القوة
          Row(
            children: List.generate(5, (index) {
              final strength = _calculateStrength(password);
              final color = _getOverallColor(strength);

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
          const SizedBox(height: 8),

          Text(
            'قوة كلمة المرور: ${_getOverallText(_calculateStrength(password))}',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: _getOverallColor(_calculateStrength(password)),
            ),
          ),

          const SizedBox(height: 12),
        ],

        _buildCriteriaItem(
          '6 أحرف على الأقل',
          password.length >= 6,
        ),
        _buildCriteriaItem(
          '8 أحرف على الأقل',
          password.length >= 8,
        ),
        _buildCriteriaItem(
          'يحتوي على حرف كبير (A-Z)',
          RegExp(r'[A-Z]').hasMatch(password),
        ),
        _buildCriteriaItem(
          'يحتوي على رقم (0-9)',
          RegExp(r'[0-9]').hasMatch(password),
        ),
        _buildCriteriaItem(
          'يحتوي على رمز خاص (!@#\$%^&*)',
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
        ),
      ],
    );
  }

  Widget _buildCriteriaItem(String text, bool isMet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(
            isMet ? Icons.check_circle : Icons.cancel,
            color: isMet ? AppColors.success : AppColors.grey400,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12,
              color: isMet ? AppColors.success : AppColors.grey600,
              fontWeight: isMet ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
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

  Color _getOverallColor(int strength) {
    if (strength <= 1) {
      return AppColors.error;
    } else if (strength <= 2) {
      return AppColors.warning;
    } else if (strength <= 3) {
      return AppColors.info;
    } else {
      return AppColors.success;
    }
  }

  String _getOverallText(int strength) {
    if (strength <= 1) {
      return 'ضعيفة';
    } else if (strength <= 2) {
      return 'متوسطة';
    } else if (strength <= 3) {
      return 'جيد';
    } else {
      return 'قوية';
    }
  }
}