import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'field_label.dart';

class DepartmentDropdown extends StatelessWidget {
  final String selectedDepartment;
  final ValueChanged<String> onDepartmentChanged;

  const DepartmentDropdown({
    super.key,
    required this.selectedDepartment,
    required this.onDepartmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    const departments = [
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('القسم'),
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
              value: selectedDepartment.isEmpty ? null : selectedDepartment,
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
              items: departments
                  .map((dept) => DropdownMenuItem(
                value: dept,
                child: Text(dept),
              ))
                  .toList(),
              onChanged: (value) {
                onDepartmentChanged(value ?? '');
              },
            ),
          ),
        ),
      ],
    );
  }
}