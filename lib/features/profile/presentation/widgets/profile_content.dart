import 'package:nabd_alattaa_team/features/profile/presentation/widgets/info_section.dart';
import 'package:nabd_alattaa_team/features/profile/presentation/widgets/profile_sliver_app_bar.dart';
import 'package:nabd_alattaa_team/features/profile/presentation/widgets/profile_stats_row.dart';
import 'package:nabd_alattaa_team/features/profile/presentation/widgets/settings_section.dart';
import '../../../../common_imports.dart';
import '../../data/models/user_profile_model.dart';

class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key,required this.profile});
  final UserProfileModel profile;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        ProfileSliverAppBar(profile : profile),
        SliverToBoxAdapter(
          child: Padding(
            padding:   EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                  SizedBox(height: 20.h),
                ProfileStatsRow(profile : profile),
                  SizedBox(height: 20.h),
                InfoSection(userProfileModel: profile),
                  SizedBox(height: 16.h),
                SettingsSection(isBreakFast: profile.isBreakFast,isAdmin: profile.isAdmin,),
                  SizedBox(height: 32.h),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
