import '../../../../common_imports.dart';
import '../view_model/login_cubit.dart';
import '../view_model/login_states.dart';

class ForgotPasswordDialog extends StatefulWidget {
  final String email;

  const ForgotPasswordDialog({super.key, required this.email});

  @override
  State<ForgotPasswordDialog> createState() => _ForgotPasswordDialogState();
}

class _ForgotPasswordDialogState extends State<ForgotPasswordDialog> {
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();

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
    return BlocListener<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم إرسال رابط إعادة تعيين كلمة المرور'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is ResetPasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: AlertDialog(
        title: const Text(AppStrings.resetPassword),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('أدخل بريدك الإلكتروني لإعادة تعيين كلمة المرور'),
              SizedBox(height: 16.h),
              CustomTextField(
                controller: _emailController,
                labelText: AppStrings.email,
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: AppValidators.email,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          BlocBuilder<LoginCubit, LoginStates>(
            builder: (context, state) {
              final isLoading = state is ResetPasswordLoading;
              return CustomButton(
                text: AppStrings.send,
                isLoading: isLoading,
                onPressed: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          context.read<LoginCubit>().resetPassword(
                                email: _emailController.text.trim(),
                              );
                        }
                      },
                width: 100.w,
              );
            },
          ),
        ],
      ),
    );
  }
}
