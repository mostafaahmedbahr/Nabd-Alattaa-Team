import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RegisterStepIndicator extends StatelessWidget {
  final int currentStep;

  const RegisterStepIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(0, 'البيانات الشخصية'),
        _buildStepLine(0),
        _buildStepCircle(1, 'بيانات الحساب'),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = currentStep >= step;
    final isCurrent = currentStep == step;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.3),
            border: Border.all(
              color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Center(
            child: isActive && !isCurrent
                ? const Icon(Icons.check, size: 16, color: AppColors.primary)
                : Text(
              '${step + 1}',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isCurrent
                    ? AppColors.primary
                    : AppColors.primaryDark.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            color: Colors.white.withValues(alpha: isActive ? 1 : 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int afterStep) {
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: currentStep > afterStep
            ? Colors.white
            : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}