 import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../common_imports.dart';
 import '../../data/models/register_model.dart';
import '../view_model/register_cubit.dart';
import '../view_model/register_states.dart';
import '../widgets/account_info_step.dart';
import '../widgets/personal_info_step.dart';
import '../widgets/register_bottom_button.dart';
import '../widgets/register_header.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _ageController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String _selectedGender = 'male';
  String _selectedDepartment = '';
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365 * 22));

  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<RegisterCubit, RegisterStates>(
        listener: _handleRegisterState,
        child: SafeArea(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                RegisterHeader(
                  currentStep: _currentStep,
                  onBackPressed: () => context.go('/login'),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: _currentStep == 0
                          ? _buildPersonalInfoStep()
                          : _buildAccountInfoStep(),
                    ),
                  ),
                ),
                RegisterBottomButton(
                  currentStep: _currentStep,
                  onPressed: _handleButtonPress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoStep() {
    return PersonalInfoStep(
      nameController: _nameController,
      phoneController: _phoneController,
      ageController: _ageController,
      selectedGender: _selectedGender,
      onGenderChanged: (value) => setState(() => _selectedGender = value),
      selectedDepartment: _selectedDepartment,
      onDepartmentChanged: (value) => setState(() => _selectedDepartment = value),
      birthDate: _birthDate,
      onBirthDateChanged: (date) => setState(() => _birthDate = date),
    );
  }

  Widget _buildAccountInfoStep() {
    return AccountInfoStep(
      emailController: _emailController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      obscurePassword: _obscurePassword,
      onPasswordVisibilityToggle: () =>
          setState(() => _obscurePassword = !_obscurePassword),
      obscureConfirmPassword: _obscureConfirmPassword,
      onConfirmPasswordVisibilityToggle: () =>
          setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
    );
  }

  void _handleButtonPress() {
    if (_currentStep == 0) {
      if (_validateStep1()) {
        setState(() => _currentStep = 1);
      }
    } else {
      _submitRegister();
    }
  }

  bool _validateStep1() {
    if (_nameController.text.trim().isEmpty) return false;
    if (_phoneController.text.trim().isEmpty) return false;
    if (_selectedDepartment.isEmpty) return false;
    return true;
  }

  void _submitRegister() {
    if (_formKey.currentState!.validate()) {
      final registerData = RegisterModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text,
        age: int.parse(_ageController.text.trim()),
        department: _selectedDepartment,
        gender: _selectedGender,
        birthDate: _birthDate,
      );
      context.read<RegisterCubit>().register(registerData: registerData);
    }
  }

  void _handleRegisterState(BuildContext context, RegisterStates state) {
    if (state is RegisterSuccessState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم إنشاء الحساب بنجاح'),
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