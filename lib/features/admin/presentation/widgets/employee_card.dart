import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../users/data/models/user_model.dart';

class EmployeeCard extends StatelessWidget {
  final UserModel employee;
  final VoidCallback? onRoleTap;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onRoleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                employee.name.isNotEmpty ? employee.name[0] : '?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    employee.email,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _buildChip(employee.department, AppColors.info),
                      const SizedBox(width: 6),
                      _buildRoleChip(),
                    ],
                  ),
                ],
              ),
            ),
            if (onRoleTap != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                color: AppColors.primary,
                onPressed: onRoleTap,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildRoleChip() {
    final roleText = _getRoleText(employee.role);
    final roleColor = _getRoleColor(employee.role);

    return GestureDetector(
      onTap: onRoleTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: roleColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              roleText,
              style: TextStyle(
                fontSize: 10,
                color: roleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 14, color: roleColor),
          ],
        ),
      ),
    );
  }

  String _getRoleText(String role) {
    switch (role) {
      case UserRole.superAdmin:
        return 'مدير عام';
      case UserRole.manager:
        return 'مدير';
      default:
        return 'موظف';
    }
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case UserRole.superAdmin:
        return AppColors.error;
      case UserRole.manager:
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }
}
