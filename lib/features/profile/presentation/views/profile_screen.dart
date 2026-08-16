import 'package:firebase_auth/firebase_auth.dart';
import '../../../../common_imports.dart';
import '../view_model/profile_cubit.dart';
import '../view_model/profile_state.dart';
import '../widgets/profile_content.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<ProfileCubit>().loadProfile(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم تحديث الملف الشخصي'),
                backgroundColor: AppColors.success,
              ),
            );
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              context.read<ProfileCubit>().refreshProfile(user.uid);
            }
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const LoadingWidget(message: 'جاري التحميل...');
            }

            if (state is ProfileError) {
              return CustomErrorWidget(
                message: state.message,
                onRetry: _loadProfile,
              );
            }

            if (state is ProfileLoaded || state is ProfileUpdating) {
              final profile = state is ProfileLoaded
                  ? state.profile
                  : (state as ProfileUpdating).profile;
              return ProfileContent(profile : profile);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }





}
