import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../view_model/register_cubit.dart';
import '../view_model/register_states.dart';

class RegisterBottomButton extends StatelessWidget {
  final int currentStep;
  final VoidCallback onPressed;

  const RegisterBottomButton({
    super.key,
    required this.currentStep,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: BlocBuilder<RegisterCubit, RegisterStates>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: state is RegisterLoadingState ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textWhite,
                disabledBackgroundColor: AppColors.primaryLight,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: state is RegisterLoadingState
                  ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentStep == 0 ? 'التالي' : 'إنشاء الحساب',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    currentStep == 0
                        ? Icons.arrow_forward_ios
                        : Icons.check_circle_outline,
                    size: 20,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}