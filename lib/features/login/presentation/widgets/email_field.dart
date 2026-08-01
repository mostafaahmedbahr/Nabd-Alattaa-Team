import '../../../../common_imports.dart';
import '../view_model/login_cubit.dart';

class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();

    return CustomTextField(
      controller: cubit.emailController,
      hintText: 'example@nabd.com',
      prefixIcon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      enableRealTimeValidation: true,
      validator: AppValidators.email,
    );
  }
}