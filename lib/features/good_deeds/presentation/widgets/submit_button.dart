import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/good_deeds/presentation/view_model/good_deed_cubit.dart';
import 'package:nabd_alattaa_team/features/good_deeds/presentation/view_model/good_deed_state.dart';

import '../../../../common_imports.dart';
import '../../../home/presentation/view_model/home_cubit.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.cubit});
  final GoodDeedCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoodDeedCubit , GoodDeedStates>(
      listener:(context,state){
        if(state is GoodDeedAddSuccess){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("تمت اضافة المشاركة الخيرية بنجاح"),
              backgroundColor: AppColors.secondaryDark,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
            ),
          );
          context.read<GoodDeedCubit>().loadGoodDeeds();

          context.read<HomeCubit>().loadHomeData(FirebaseAuth.instance.currentUser?.uid ?? 'current_user_id',
              forceRefresh: false);
          context.pop();
        }
        else if (state is GoodDeedActionError){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:   Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context,state){
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
      },

    );
  }


}
