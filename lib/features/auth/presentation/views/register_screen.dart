import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
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
  DateTime _birthDate = DateTime.now().subtract(const Duration(days: 365 * 20));

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('إنشاء حساب'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        elevation: 0,
      ),
      body: BlocListener<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء الحساب بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/login');
          } else if (state is RegisterError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo
                  Center(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.jpg',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Name
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'الاسم الكامل',
                    prefixIcon: Icons.person_outline,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email
                  CustomTextField(
                    controller: _emailController,
                    labelText: AppStrings.email,
                    prefixIcon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return AppStrings.emailRequired;
                      }
                      if (!value.contains('@')) {
                        return AppStrings.emailRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone
                  CustomTextField(
                    controller: _phoneController,
                    labelText: 'رقم الهاتف',
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'رقم الهاتف مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Age
                  CustomTextField(
                    controller: _ageController,
                    labelText: 'العمر',
                    prefixIcon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'العمر مطلوب';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age < 18 || age > 100) {
                        return 'يرجى إدخال عمر صحيح';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Birth Date
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
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'تاريخ الميلاد',
                        prefixIcon: const Icon(Icons.calendar_today,
                            color: AppColors.grey500, size: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.grey300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: AppColors.grey300),
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                      child: Text(
                        '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Gender
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'الجنس',
                      prefixIcon: const Icon(Icons.wc_outlined,
                          color: AppColors.grey500, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.grey300),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        items: const [
                          DropdownMenuItem(
                              value: 'male', child: Text('ذكر')),
                          DropdownMenuItem(
                              value: 'female', child: Text('أنثى')),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Department
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'القسم',
                      prefixIcon: const Icon(Icons.business_outlined,
                          color: AppColors.grey500, size: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.grey300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: AppColors.grey300),
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDepartment.isEmpty
                            ? null
                            : _selectedDepartment,
                        hint: const Text('اختر القسم'),
                        isExpanded: true,
                        dropdownColor: AppColors.surface,
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
                  const SizedBox(height: 16),

                  // Password
                  CustomTextField(
                    controller: _passwordController,
                    labelText: AppStrings.password,
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    suffixIcon: _obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixTap: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppStrings.passwordRequired;
                      }
                      if (value.length < 6) {
                        return AppStrings.passwordTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password
                  CustomTextField(
                    controller: _confirmPasswordController,
                    labelText: 'تأكيد كلمة المرور',
                    prefixIcon: Icons.lock_outline,
                    obscureText: _obscureConfirmPassword,
                    textInputAction: TextInputAction.done,
                    suffixIcon: _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    onSuffixTap: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'تأكيد كلمة المرور مطلوب';
                      }
                      if (value != _passwordController.text) {
                        return 'كلمتا المرور غير متطابقتين';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  BlocBuilder<RegisterCubit, RegisterState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: 'إنشاء حساب',
                        isLoading: state is RegisterLoading,
                        onPressed: () {
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
                            context
                                .read<RegisterCubit>()
                                .register(registerData: registerData);
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'لديك حساب بالفعل؟ ',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
