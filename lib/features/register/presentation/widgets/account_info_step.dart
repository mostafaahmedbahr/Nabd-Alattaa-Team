import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'section_title.dart';
import 'field_label.dart';
import 'password_strength.dart';

class AccountInfoStep extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscurePassword;
  final VoidCallback onPasswordVisibilityToggle;
  final bool obscureConfirmPassword;
  final VoidCallback onConfirmPasswordVisibilityToggle;

  const AccountInfoStep({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.onPasswordVisibilityToggle,
    required this.obscureConfirmPassword,
    required this.onConfirmPasswordVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('بيانات الحساب'),
        const SizedBox(height: 16),
        _buildEmailField(),
        const SizedBox(height: 18),
        _buildPasswordField(),
        const SizedBox(height: 18),
        _buildConfirmPasswordField(),
        const SizedBox(height: 24),
        _buildInfoCard(),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('البريد الإلكتروني'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: emailController,
          hintText: 'example@nabd.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.emailRequired;
            }
            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
            if (!emailRegex.hasMatch(value.trim())) return 'البريد الإلكتروني غير صالح';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('كلمة المرور'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: passwordController,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: obscurePassword,
          textInputAction: TextInputAction.next,
          suffixIcon: obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: onPasswordVisibilityToggle,
          validator: (value) {
            if (value == null || value.isEmpty) return AppStrings.passwordRequired;
            if (value.length < 6) return AppStrings.passwordTooShort;
            if (!RegExp(r'[A-Z]').hasMatch(value)) return 'كلمة المرور يجب أن تحتوي على حرف كبير';
            if (!RegExp(r'[0-9]').hasMatch(value)) return 'كلمة المرور يجب أن تحتوي على رقم';
            return null;
          },
        ),
        const SizedBox(height: 8),
        PasswordStrength(password: passwordController.text),
      ],
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('تأكيد كلمة المرور'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: confirmPasswordController,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          suffixIcon: obscureConfirmPassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: onConfirmPasswordVisibilityToggle,
          validator: (value) {
            if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
            if (value != passwordController.text) return 'كلمتا المرور غير متطابقتين';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'سيتم إرسال طلب التسجيل للمدير للموافقة على حسابك',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 12,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}