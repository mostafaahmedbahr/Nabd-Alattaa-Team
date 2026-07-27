import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/user_profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileModel profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: AppColors.textWhite.withOpacity(0.2),
            child: Text(
              profile.name.isNotEmpty ? profile.name[0] : '?',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.textWhite,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.position,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textWhite.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.textWhite.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors.secondaryLight,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  '${profile.points} نقطة',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textWhite,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
