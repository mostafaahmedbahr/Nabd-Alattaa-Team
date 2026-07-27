import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../view_model/auth_bloc.dart';
import '../view_model/auth_event.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String email;

  const ForgotPasswordDialog({super.key, required this.email});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(AppStrings.resetPassword),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور'),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _emailController,
            labelText: AppStrings.email,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(AppStrings.cancel),
        ),
        CustomButton(
          text: AppStrings.send,
          onPressed: () {
            if (_emailController.text.isNotEmpty) {
              context.read<AuthBloc>().add(
                    ResetPasswordEvent(email: _emailController.text.trim()),
                  );
              Navigator.pop(context);
            }
          },
          width: 100,
        ),
      ],
    );
  }
}
