import '../../../../common_imports.dart';
import '../view_model/login_cubit.dart';
import '../view_model/login_states.dart';
import 'forgot_password_dialog.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تسجيل الدخول',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'أدخل بياناتك للدخول إلى الحساب',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 28.h),
            _buildLabel('البريد الإلكتروني'),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: _emailController,
              hintText: 'example@nabd.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              enableRealTimeValidation: true,
              validator: AppValidators.email,
            ),
            SizedBox(height: 20.h),
            _buildLabel('كلمة المرور'),
            SizedBox(height: 8.h),
            CustomTextField(
              controller: _passwordController,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              obscureText: _obscurePassword,
              suffixIcon: _obscurePassword
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              onSuffixTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              enableRealTimeValidation: true,
              validator: AppValidators.password,
            ),
            SizedBox(height: 12.h),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ForgotPasswordDialog(
                      email: _emailController.text,
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
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.primary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            BlocBuilder<LoginCubit, LoginState>(
              builder: (context, state) {
                return SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: state is LoginLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<LoginCubit>().login(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text,
                                  );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                      disabledBackgroundColor: AppColors.primaryLight,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: state is LoginLoading
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
