import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'register_step_indicator.dart';

class RegisterHeader extends StatelessWidget {
  final int currentStep;
  final VoidCallback onBackPressed;

  const RegisterHeader({
    super.key,
    required this.currentStep,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.primary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBackPressed,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.textWhite,
                  size: 20,
                ),
              ),
              const Spacer(),
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.jpg',
                  width: 44,
                  height: 44,
                  fit: BoxFit.cover,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'إنشاء حساب جديد',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'أكمل بياناتك للانضمام إلينا',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 16),
          RegisterStepIndicator(currentStep: currentStep),
        ],
      ),
    );
  }
}