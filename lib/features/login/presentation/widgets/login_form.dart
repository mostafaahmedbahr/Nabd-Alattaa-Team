import 'package:nabd_alattaa_team/features/login/presentation/widgets/password_field.dart';
import 'package:nabd_alattaa_team/features/login/presentation/widgets/title_label.dart';
import '../../../../common_imports.dart';
import '../view_model/login_cubit.dart';
import 'email_field.dart';
import 'forgot_password_button.dart';
import 'login_button.dart';
import 'login_texts.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: cubit.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LoginTexts(),
            TitleLabel(label : 'البريد الإلكتروني'),
            SizedBox(height: 8.h),
            EmailField(),
            SizedBox(height: 20.h),
            TitleLabel(label : 'كلمة المرور'),
            SizedBox(height: 8.h),
            PasswordField(),
            SizedBox(height: 12.h),
            ForgotPasswordButton(),
            SizedBox(height: 24.h),
            LoginButton(),
          ],
        ),
      ),
    );
  }


}
