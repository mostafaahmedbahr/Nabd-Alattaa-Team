import '../../../../common_imports.dart';
import '../view_model/announcement_cubit.dart';
import '../view_model/announcement_state.dart';
import 'announcement_form_field.dart';
import 'announcement_form_section.dart';
import 'announcement_submit_button.dart';
import 'announcement_type_selector.dart';

class CreateAnnouncementForm extends StatelessWidget {
  const CreateAnnouncementForm({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AnnouncementCubit>();

    return BlocListener<AnnouncementCubit, AnnouncementState>(
      listener: (context, state) {
        if (state is AnnouncementError) {
          _showSnackBar(
            context: context,
            message: state.message,
            icon: Icons.error_outline_rounded,
            backgroundColor: AppColors.error,
          );
        }
        if (state is AnnouncementCreated) {
          context.read<AnnouncementCubit>().clearForm();
          _showSnackBar(
            context: context,
            message: 'تم نشر الإعلان بنجاح!',
            icon: Icons.check_circle_rounded,
            backgroundColor: AppColors.success,
          );
          context.pop();
        }
      },
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Form(
          key: cubit.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnnouncementFormSection(
                title: 'عنوان الإعلان',
                icon: Icons.title_rounded,
                child: AnnouncementFormField(
                  controller: cubit.titleController,
                  hint: 'اكتب عنوان الإعلان...',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'العنوان مطلوب';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 28.h),
              AnnouncementFormSection(
                title: 'تفاصيل الإعلان',
                icon: Icons.description_rounded,
                child: AnnouncementFormField(
                  controller: cubit.contentController,
                  hint: 'اكتب تفاصيل الإعلان...',
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'التفاصيل مطلوبة';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 28.h),
              AnnouncementFormSection(
                title: 'نوع الإعلان',
                icon: Icons.category_rounded,
                child: AnnouncementTypeSelector(
                  selectedType: cubit.selectedType,
                  onChanged: (type) => cubit.selectedType = type,
                ),
              ),
              SizedBox(height: 36.h),
              BlocBuilder<AnnouncementCubit, AnnouncementState>(
                buildWhen: (previous, current) =>
                    current is AnnouncementCreating,
                builder: (context, state) {
                  return AnnouncementSubmitButton(
                    isLoading: state is AnnouncementCreating,
                    onPressed: () => _submit(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit(BuildContext context) {
    final cubit = context.read<AnnouncementCubit>();
    if (cubit.formKey.currentState!.validate()) {
      cubit.createAnnouncement();
    }
  }

  void _showSnackBar({
    required BuildContext context,
    required String message,
    required IconData icon,
    required Color backgroundColor,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: AppColors.textWhite, size: 20),
            SizedBox(width: 10.w),
            Text(message),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}