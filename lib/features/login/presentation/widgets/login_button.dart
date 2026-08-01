import '../../../../common_imports.dart';
import '../view_model/login_cubit.dart';
import '../view_model/login_states.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginStates>(
      builder: (context, state) {
        final cubit = context.read<LoginCubit>();

        return SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: state is LoginLoadingState
                ? null
                : cubit.loginPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textWhite,
              disabledBackgroundColor: AppColors.primaryLight,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: state is LoginLoadingState
                ? SizedBox(
              height: 22.h,
              width: 22.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
            )
                : Text(
              'دخول',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }
}