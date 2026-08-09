import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/good_deeds/presentation/view_model/good_deed_cubit.dart';

import '../../../../common_imports.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.cubit});
  final GoodDeedCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.secondaryLight],
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 16.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: (){
          if (cubit.formKey.currentState!.validate()) {
            cubit.addGoodDeed(
              title: cubit.titleController.text.trim(),
              content: cubit.descriptionController.text.trim(),
              creatorId: FirebaseAuth.instance.currentUser?.uid ?? 'current_user_id',
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("تم إنشاء المهمة بنجاح"),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 2),
              ),
            );
            context.pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        child:   Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_rounded, color: AppColors.textWhite,
                size: 20.sp),
            SizedBox(width: 10.w),
            Text(
              'مشاركة',
              style: TextStyle(
                color: AppColors.textWhite,
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


}
