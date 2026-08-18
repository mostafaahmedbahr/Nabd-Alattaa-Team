import '../../../../common_imports.dart';
import '../view_model/register_cubit.dart';
import '../view_model/register_states.dart';
import '../widgets/account_info_step.dart';
import '../widgets/personal_info_step.dart';
import '../widgets/register_bottom_button.dart';
import '../widgets/register_header.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: _handleRegisterState,
        builder: (context, state) {
          final cubit = context.read<RegisterCubit>();
          return SizedBox(
            height: size.height,
            child: Column(
              children: [
                RegisterHeader(
                  currentStep: cubit.currentStep,
                  onBackPressed: () => context.go('/login'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: context.read<RegisterCubit>().formKey,
                      child: AdaptiveFormContainer(
                        child: cubit.currentStep == 0
                            ? _buildPersonalInfoStep(context)
                            : _buildAccountInfoStep(context),
                      ),
                    ),
                  ),
                ),
                RegisterBottomButton(
                  currentStep: cubit.currentStep,
                  onPressed: () => _handleButtonPress(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalInfoStep(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();

    return PersonalInfoStep(
      nameController: cubit.nameController,
      phoneController: cubit.phoneController,
      ageController: cubit.ageController,
      selectedGender: cubit.selectedGender,
      onGenderChanged: cubit.updateGender,
      selectedDepartment: cubit.selectedDepartment,
      onDepartmentChanged: cubit.updateDepartment,
      birthDate: cubit.birthDate,
      onBirthDateChanged: cubit.updateBirthDate,
    );
  }

  Widget _buildAccountInfoStep(BuildContext context) {
    final cubit = context.watch<RegisterCubit>();

    return AccountInfoStep(
      emailController: cubit.emailController,
      passwordController: cubit.passwordController,
      confirmPasswordController: cubit.confirmPasswordController,
      obscurePassword: cubit.obscurePassword,
      onPasswordVisibilityToggle: cubit.togglePasswordVisibility,
      obscureConfirmPassword: cubit.obscureConfirmPassword,
      onConfirmPasswordVisibilityToggle: cubit.toggleConfirmPasswordVisibility,
    );
  }

  void _handleButtonPress(BuildContext context) {
    final cubit = context.read<RegisterCubit>();

    if (cubit.currentStep == 0) {
      // Validate step 1
      if (cubit.validateStep1()) {
        cubit.goToNextStep();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('يرجى ملء جميع الحقول المطلوبة'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    } else {
      // Submit registration
      cubit.submitRegister();
    }
  }

  void _handleRegisterState(BuildContext context, RegisterStates state) {
    if (state is RegisterSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إنشاء الحساب بنجاح، في انتظار موافقة المدير'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
      context.go('/login');
    } else if (state is RegisterErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }
}