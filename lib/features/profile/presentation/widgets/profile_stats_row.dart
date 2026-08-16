import 'package:nabd_alattaa_team/features/profile/presentation/widgets/profile_stat_card.dart';

import '../../../../common_imports.dart';
import '../../data/models/user_profile_model.dart';

class ProfileStatsRow extends StatelessWidget {
  const ProfileStatsRow({super.key, required this.profile});
  final UserProfileModel profile;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileStatCard(
          icon: Icons.star_rounded,
          label: 'النقاط',
          value: '${profile.points}',
          color: AppColors.secondary,
        ),
          SizedBox(width: 12.w),
        ProfileStatCard(
          icon: Icons.business_outlined,
          label: 'القسم',
          value: profile.department.isNotEmpty ? profile.department : '-',
          color: AppColors.primary,
        ),
          SizedBox(width: 12.w),
        ProfileStatCard(
          icon: Icons.work_outlined,
          label: 'المنصب',
          value: profile.position.isNotEmpty ? profile.position : '-',
          color: AppColors.info,
        ),
      ],
    );
  }
}
