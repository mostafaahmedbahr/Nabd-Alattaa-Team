import '../../../../common_imports.dart';
import '../view_model/login_cubit.dart';
import '../view_model/login_states.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginStates>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();

        return CustomTextField(
          controller: cubit.passwordController,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: cubit.obscurePassword,
          suffixIcon: cubit.obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: cubit.togglePasswordVisibility,
          enableRealTimeValidation: true,
          validator: AppValidators.password,
        );
      },
    );
  }
}