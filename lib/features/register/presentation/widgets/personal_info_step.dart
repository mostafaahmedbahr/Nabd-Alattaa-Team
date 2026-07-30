import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_text_field.dart';
import 'section_title.dart';
import 'field_label.dart';
import 'gender_selector.dart';
import 'department_dropdown.dart';
import 'birth_date_picker.dart';

class PersonalInfoStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;
  final String selectedDepartment;
  final ValueChanged<String> onDepartmentChanged;
  final DateTime birthDate;
  final ValueChanged<DateTime> onBirthDateChanged;

  const PersonalInfoStep({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.ageController,
    required this.selectedGender,
    required this.onGenderChanged,
    required this.selectedDepartment,
    required this.onDepartmentChanged,
    required this.birthDate,
    required this.onBirthDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('المعلومات الأساسية'),
        const SizedBox(height: 16),
        _buildNameField(),
        const SizedBox(height: 18),
        _buildPhoneField(),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: BirthDatePicker(
                birthDate: birthDate,
                onBirthDateChanged: onBirthDateChanged,
                ageController: ageController,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildAgeField(),
            ),
          ],
        ),
        const SizedBox(height: 18),
        GenderSelector(
          selectedGender: selectedGender,
          onGenderChanged: onGenderChanged,
        ),
        const SizedBox(height: 18),
        DepartmentDropdown(
          selectedDepartment: selectedDepartment,
          onDepartmentChanged: onDepartmentChanged,
        ),
      ],
    );
  }

  Widget _buildNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('الاسم الكامل'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: nameController,
          hintText: 'أدخل اسمك الكامل',
          prefixIcon: Icons.person_outline,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'الاسم مطلوب';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('رقم الهاتف'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: phoneController,
          hintText: '01XXXXXXXXX',
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          validator: (value) {
            if (value == null || value.trim().isEmpty) return 'رقم الهاتف مطلوب';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAgeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('العمر'),
        const SizedBox(height: 8),
        CustomTextField(
          controller: ageController,
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
    );
  }
}