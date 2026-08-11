import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/core/utils/log_util.dart';
import '../../../../common_imports.dart';
import '../../../profile/presentation/view_model/profile_cubit.dart';
import '../../../profile/presentation/view_model/profile_state.dart';

class WelcomeSection extends StatefulWidget {
  const WelcomeSection({super.key});

  @override
  State<WelcomeSection> createState() => _WelcomeSectionState();
}

class _WelcomeSectionState extends State<WelcomeSection> {
  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    context.read<ProfileCubit>().loadProfile(user!.uid);
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              AppAssets.logo,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
            SizedBox(width: 16.w),
          Expanded(
            child: BlocListener<ProfileCubit, ProfileState>(
              listener: (context, state) {
                if (state is ProfileError) {
                  logError('🔴 [WelcomeSection] Error: ${state.message}');
                  FirebaseAuth.instance.signOut().then((_) {
                    if (context.mounted) {
                      context.pushReplacement(Routes.login);
                    }
                  });
                }
              },
              child: BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  String userName = 'مستخدم';
                  if (state is ProfileLoaded) {
                    userName = state.profile.name;
                    logSuccess('🟢 [WelcomeSection] User name loaded: $userName');
                  } else if (state is ProfileLoading) {
                    userName = 'جاري التحميل...';
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'مرحباً بك،',
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                        SizedBox(height: 4.h),
                      Text(
                        userName,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                        SizedBox(height: 4.h),
                      Text(
                        'نتمنى لك يوماً موفقاً',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
