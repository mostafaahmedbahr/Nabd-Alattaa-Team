import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/complaints/presentation/view_model/complaint_cubit.dart';
import 'package:nabd_alattaa_team/features/complaints/presentation/view_model/complaint_state.dart';
import 'package:nabd_alattaa_team/features/profile/presentation/view_model/profile_cubit.dart';
import 'package:nabd_alattaa_team/features/profile/presentation/view_model/profile_state.dart';

import '../../../../common_imports.dart';
import '../../../home/presentation/view_model/home_cubit.dart';

class ComplaintSubmitButton extends StatelessWidget {
  const ComplaintSubmitButton({super.key, required this.cubit});

  final ComplaintCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ComplaintCubit, ComplaintState>(
      listener: (context, state) {
        if (state is ComplaintAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: AppColors.textWhite, size: 20),
                  SizedBox(width: 10),
                  Text('تم إرسال الشكوى بنجاح!'),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          context.read<ComplaintCubit>().refresh();

          context.read<HomeCubit>().loadHomeData(
                FirebaseAuth.instance.currentUser?.uid ?? 'current_user_id',
                forceRefresh: true,
                showLoading: false,
              );
          context.pop();
        } else if (state is ComplaintAddError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is ComplaintAddLoading;
        return Container(
          height: 56.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.complaintsGradientEnd],
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 16.r,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    if (cubit.formKey.currentState!.validate()) {
                      _submit(context);
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.send_rounded, color: AppColors.textWhite, size: 20),
                SizedBox(width: 10),
                Text(
                  'إرسال الشكوى',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _submit(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? '';
    final profileState = context.read<ProfileCubit>().state;
    final userName = profileState is ProfileLoaded
        ? profileState.profile.name
        : 'مستخدم';

    cubit.createComplaint(
      title: cubit.titleController.text.trim(),
      content: cubit.contentController.text.trim(),
      creatorId: userId,
      creatorName: userName,
    );
  }
}
