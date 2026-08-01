import '../../../../common_imports.dart';
import '../view_model/login_cubit.dart';
import 'forgot_password_dialog.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => ForgotPasswordDialog(
              email: cubit.emailController.text,
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          AppStrings.forgotPassword,
        ),
      ),
    );
  }
}