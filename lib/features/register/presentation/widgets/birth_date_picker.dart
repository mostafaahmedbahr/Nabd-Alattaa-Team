import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'field_label.dart';

class BirthDatePicker extends StatelessWidget {
  final DateTime birthDate;
  final ValueChanged<DateTime> onBirthDateChanged;
  final TextEditingController ageController;

  const BirthDatePicker({
    super.key,
    required this.birthDate,
    required this.onBirthDateChanged,
    required this.ageController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FieldLabel('تاريخ الميلاد'),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: birthDate,
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
              onBirthDateChanged(date);
              ageController.text =
                  ((DateTime.now().difference(date).inDays) / 365)
                      .floor()
                      .toString();
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
                  '${birthDate.day}/${birthDate.month}/${birthDate.year}',
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
    );
  }
}