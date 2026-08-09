import 'package:nabd_alattaa_team/features/good_deeds/presentation/widgets/section_title.dart';
import 'package:nabd_alattaa_team/features/good_deeds/presentation/widgets/submit_button.dart';
import 'package:nabd_alattaa_team/features/good_deeds/presentation/widgets/tip_card.dart';

import '../../../../common_imports.dart';
import '../view_model/good_deed_cubit.dart';
import '../view_model/good_deed_state.dart';

class CreateGoodDeedContent extends StatelessWidget {
  const CreateGoodDeedContent({super.key, required this.fadeAnimation,});
  final  Animation<double> fadeAnimation;
  @override
  Widget build(BuildContext context) {
    return   SliverToBoxAdapter(
      child: BlocConsumer<GoodDeedCubit, GoodDeedStates>(
        builder: (context,state){
          var goodDeedCubit = context.read<GoodDeedCubit>();
          return FadeTransition(
            opacity: fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: goodDeedCubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SectionTitle(title: 'عنوان عمل الخير',icon: Icons.title_rounded),
                      SizedBox(height: 12.h),
                    CustomTextField(
                      controller: goodDeedCubit.titleController,
                      hintText: 'مثال: مساعدة جارتي في التنظيف',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'اكتب عنوان عمل الخير';
                        }
                        return null;
                      },
                    ),
                      SizedBox(height: 28.h),
                     SectionTitle(title: 'التفاصيل',icon:  Icons.description_rounded),
                      SizedBox(height: 12.h),
                    CustomTextField(
                      controller: goodDeedCubit.descriptionController,
                      hintText: 'اكتب تفاصيل عمل الخير الذي قمت به...',
                      maxLines: 5,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'اكتب تفاصيل عمل الخير';
                        }
                        if (value.trim().length < 5) {
                          return 'اكتب المزيد من التفاصيل';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 32.h),
                    TipCard(),
                    SizedBox(height: 36.h),
                    SubmitButton(cubit:goodDeedCubit ,),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is GoodDeedActionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        },

      ),
    );
  }
}
