import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/adaptive_layout.dart';
import '../view_model/profile_cubit.dart';
import '../view_model/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({super.key, required this.userId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  String _selectedDepartment = '';
  bool _initialized = false;

  final _departments = [
    'الإدارة',
    'الموارد البشرية',
    'المالية',
    'المراجعة الداخلية',
    'الشؤون القانونية',
    'البرامج',
    'الأبحاث',
    'المشتريات',
    'المخازن',
    'الاستقبال',
    'الخدمات',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _positionController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final state = context.read<ProfileCubit>().state;
      if (state is ProfileLoaded) {
        _nameController.text = state.profile.name;
        _phoneController.text = state.profile.phone;
        _positionController.text = state.profile.position;
        _selectedDepartment = state.profile.department;
        _initialized = true;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
        centerTitle: true,
      ),
      backgroundColor: AppColors.background,
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded && _initialized) {
            _nameController.text = state.profile.name;
            _phoneController.text = state.profile.phone;
            _positionController.text = state.profile.position;
            _selectedDepartment = state.profile.department;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const LoadingWidget(message: AppStrings.loading);
          }

          return AdaptiveFormContainer(
            child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomTextField(
                    controller: _nameController,
                    labelText: AppStrings.name,
                    prefixIcon: Icons.person_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الاسم مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneController,
                    labelText: AppStrings.phone,
                    prefixIcon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'رقم الهاتف مطلوب';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _positionController,
                    labelText: AppStrings.position,
                    prefixIcon: Icons.work_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الوظيفة مطلوبة';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildDepartmentDropdown(),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: AppStrings.save,
                    isLoading: state is ProfileUpdating,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final data = {
                          FirestoreConstants.userName: _nameController.text.trim(),
                          FirestoreConstants.userPhone: _phoneController.text.trim(),
                          FirestoreConstants.userPosition: _positionController.text.trim(),
                          FirestoreConstants.userDepartment: _selectedDepartment,
                        };
                        context
                            .read<ProfileCubit>()
                            .updateProfile(widget.userId, data);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
        },
      ),
    );
  }

  Widget _buildDepartmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.department,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
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
                  color: AppColors.textHint,
                  fontSize: 14,
                ),
              ),
              isExpanded: true,
              dropdownColor: AppColors.surface,
              icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.grey400),
              style: const TextStyle(
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
                setState(() => _selectedDepartment = value ?? '');
              },
            ),
          ),
        ),
      ],
    );
  }
}
