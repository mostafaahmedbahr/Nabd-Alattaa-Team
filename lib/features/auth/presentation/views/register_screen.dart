import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/register_model.dart';
import '../view_model/register_cubit.dart';
import '../view_model/register_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  final List<String> _departments = [
    'الإدارة العامة',
    'تقنية المعلومات',
    'الموارد البشرية',
    'التسويق',
    'المبيعات',
    'المحاسبة',
    'خدمة العملاء',
    'التشغيل',
    'الصيانة',
    'النقل',
    'الأمن',
    'النظافة',
  ];

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
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
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
          } else if (state is RegisterError) {
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
        },
        child: SafeArea(
          child: SizedBox(
            height: size.height,
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryDark,
                        AppColors.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => context.go('/login'),
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: AppColors.textWhite,
                              size: 20,
                            ),
                          ),
                          const Spacer(),
                          ClipOval(
                            child: Image.asset(
                              'assets/images/logo.jpg',
                              width: 44,
                              height: 44,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Spacer(),
                          const SizedBox(width: 48),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'أكمل بياناتك للانضمام إلينا',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Step Indicator
                      _buildStepIndicator(),
                    ],
                  ),
                ),

                // Form
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

                // Bottom Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        return ElevatedButton(
                          onPressed: state is RegisterLoading
                              ? null
                              : () {
                                  if (_currentStep == 0) {
                                    if (_validateStep1()) {
                                      setState(() {
                                        _currentStep = 1;
                                      });
                                    }
                                  } else {
                                    _submitRegister();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textWhite,
                            disabledBackgroundColor: AppColors.primaryLight,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: state is RegisterLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _currentStep == 0 ? 'التالي' : 'إنشاء الحساب',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(
                                      _currentStep == 0
                                          ? Icons.arrow_back_ios
                                          : Icons.check_circle_outline,
                                      size: 20,
                                    ),
                                  ],
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepCircle(0, 'البيانات الشخصية'),
        _buildStepLine(0),
        _buildStepCircle(1, 'بيانات الحساب'),
      ],
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep >= step;
    final isCurrent = _currentStep == step;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? Colors.white : Colors.white.withOpacity(0.3),
            border: Border.all(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Center(
            child: isActive && !isCurrent
                ? const Icon(Icons.check, size: 16, color: AppColors.primary)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCurrent
                          ? AppColors.primary
                          : AppColors.primaryDark.withOpacity(0.5),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 10,
            color: Colors.white.withOpacity(isActive ? 1 : 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(int afterStep) {
    return Container(
      width: 60,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _currentStep > afterStep
            ? Colors.white
            : Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }

  bool _validateStep1() {
    if (_nameController.text.trim().isEmpty) return false;
    if (_phoneController.text.trim().isEmpty) return false;
    if (_selectedDepartment.isEmpty) return false;
    return true;
  }

  Widget _buildPersonalInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('المعلومات الأساسية'),
        const SizedBox(height: 16),

        // Name
        _buildFieldLabel('الاسم الكامل'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _nameController,
          hintText: 'أدخل اسمك الكامل',
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'الاسم مطلوب';
            return null;
          },
        ),
        const SizedBox(height: 18),

        // Phone
        _buildFieldLabel('رقم الهاتف'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _phoneController,
          hintText: '01XXXXXXXXX',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'رقم الهاتف مطلوب';
            return null;
          },
        ),
        const SizedBox(height: 18),

        // Birth Date & Age
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('تاريخ الميلاد'),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _birthDate,
                        firstDate: DateTime(1960),
                        lastDate: DateTime.now().subtract(
                          const Duration(days: 365 * 18),
                        ),
                        locale: const Locale('ar'),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primary,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() {
                          _birthDate = date;
                          _ageController.text =
                              ((DateTime.now().difference(date).inDays) / 365)
                                  .floor()
                                  .toString();
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              color: AppColors.grey400, size: 18),
                          const SizedBox(width: 10),
                          Text(
                            '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFieldLabel('العمر'),
                  const SizedBox(height: 8),
                  CustomTextField(
                    controller: _ageController,
                    hintText: '---',
                    prefixIcon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'العمر مطلوب';
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Gender
        _buildFieldLabel('الجنس'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('male', 'ذكر', Icons.male),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildGenderOption('female', 'أنثى', Icons.female),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Department
        _buildFieldLabel('القسم'),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grey200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedDepartment.isEmpty ? null : _selectedDepartment,
              hint: const Text(
                'اختر القسم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textHint,
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              dropdownColor: AppColors.surface,
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.grey400),
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
                fontSize: 14,
              ),
              items: _departments
                  .map((dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDepartment = value ?? '';
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('بيانات الحساب'),
        const SizedBox(height: 16),

        // Email
        _buildFieldLabel('البريد الإلكتروني'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _emailController,
          hintText: 'example@nabd.com',
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return AppStrings.emailRequired;
            }
            if (!value.contains('@')) return AppStrings.emailRequired;
            return null;
          },
        ),
        const SizedBox(height: 18),

        // Password
        _buildFieldLabel('كلمة المرور'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _passwordController,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          suffixIcon: _obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) return AppStrings.passwordRequired;
            if (value.length < 6) return AppStrings.passwordTooShort;
            return null;
          },
        ),
        const SizedBox(height: 8),

        // Password Strength
        _buildPasswordStrength(_passwordController.text),
        const SizedBox(height: 18),

        // Confirm Password
        _buildFieldLabel('تأكيد كلمة المرور'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: _confirmPasswordController,
          hintText: '••••••••',
          prefixIcon: Icons.lock_outline,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          suffixIcon: _obscureConfirmPassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          onSuffixTap: () {
            setState(() {
              _obscureConfirmPassword = !_obscureConfirmPassword;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
            if (value != _passwordController.text) return 'كلمتا المرور غير متطابقتين';
            return null;
          },
        ),
        const SizedBox(height: 24),

        // Info Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.primarySurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.primary.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'سيتم إرسال طلب التسجيل للمدير للموافقة على حسابك',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildFieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.grey200,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.primary : AppColors.grey400,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 6) strength++;
    if (password.length >= 8) strength++;
    if (RegExp(r'[A-Z]').hasMatch(password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) strength++;

    Color color;
    String text;
    if (strength <= 1) {
      color = AppColors.error;
      text = 'ضعيفة';
    } else if (strength <= 2) {
      color = AppColors.warning;
      text = 'متوسطة';
    } else if (strength <= 3) {
      color = AppColors.info;
      text = 'جيد';
    } else {
      color = AppColors.success;
      text = 'قوية';
    }

    if (password.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(5, (index) {
            return Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: index < strength ? color : AppColors.grey200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          'قوة كلمة المرور: $text',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 11,
            color: color,
          ),
        ),
      ],
    );
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
}
