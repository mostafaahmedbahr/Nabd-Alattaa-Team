import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../users/data/models/user_model.dart';

class EmployeeCard extends StatelessWidget {
  final UserModel employee;
  final ValueChanged<bool>? onToggleActive;
  final VoidCallback? onAddPoints;
  final VoidCallback? onTap;

  const EmployeeCard({
    super.key,
    required this.employee,
    this.onToggleActive,
    this.onAddPoints,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
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
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        _buildChip(employee.department, AppColors.info),
                        const SizedBox(width: 6),
                        _buildRoleChip(),
                        const SizedBox(width: 6),
                        _buildChip('${employee.points} نقطة', AppColors.accent),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Text(
                          'مفعل',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Switch(
                          value: employee.isActive,
                          onChanged: onToggleActive,
                          activeColor: AppColors.primary,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                        if (onAddPoints != null) ...[
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: onAddPoints,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.add_circle_outline,
                                    size: 14,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    'نقاط',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.accent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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

    return Container(
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
