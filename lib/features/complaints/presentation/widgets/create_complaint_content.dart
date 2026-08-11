import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../view_model/complaint_cubit.dart';
import '../view_model/complaint_state.dart';
import 'complaint_section_title.dart';
import 'complaint_submit_button.dart';

class CreateComplaintContent extends StatefulWidget {
  const CreateComplaintContent({super.key, required this.fadeAnimation});

  final Animation<double> fadeAnimation;

  @override
  State<CreateComplaintContent> createState() => _CreateComplaintContentState();
}

class _CreateComplaintContentState extends State<CreateComplaintContent> {
  static const _types = [
    ('عطل', ComplaintType.breakdown, Icons.build_rounded),
    ('مشكلة في الطابعة', ComplaintType.printer, Icons.print_rounded),
    ('مشكلة في الإنترنت', ComplaintType.internet, Icons.wifi_off_rounded),
    ('التكييف', ComplaintType.ac, Icons.ac_unit_rounded),
    ('النظافة', ComplaintType.cleanliness, Icons.cleaning_services_rounded),
    ('الكهرباء', ComplaintType.electricity, Icons.bolt_rounded),
    ('أخرى', ComplaintType.other, Icons.help_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocConsumer<ComplaintCubit, ComplaintState>(
        builder: (context, state) {
          final cubit = context.read<ComplaintCubit>();
          return FadeTransition(
            opacity: widget.fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ComplaintSectionTitle(
                      title: 'عنوان الشكوى',
                      icon: Icons.title_rounded,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: cubit.titleController,
                      hintText: 'اكتب عنوان الشكوى...',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'العنوان مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    const ComplaintSectionTitle(
                      title: 'تفاصيل الشكوى',
                      icon: Icons.description_rounded,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: cubit.contentController,
                      hintText: 'اشرح المشكلة بالتفصيل...',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 28),
                    const ComplaintSectionTitle(
                      title: 'نوع المشكلة',
                      icon: Icons.category_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildTypeSelector(context),
                    const SizedBox(height: 28),
                    _buildAnonymousToggle(context),
                    const SizedBox(height: 36),
                    ComplaintSubmitButton(cubit: cubit),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is ComplaintActionError) {
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
      ),
    );
  }

  Widget _buildTypeSelector(BuildContext context) {
    final cubit = context.read<ComplaintCubit>();
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _types.map((type) {
        final isSelected = cubit.selectedType == type.$2;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          child: FilterChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  type.$3,
                  size: 16,
                  color: isSelected ? AppColors.textWhite : AppColors.primary,
                ),
                const SizedBox(width: 6),
                Text(type.$1),
              ],
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                cubit.selectedType = selected ? type.$2 : ComplaintType.other;
              });
            },
            selectedColor: AppColors.primary,
            backgroundColor: AppColors.surface,
            labelStyle: TextStyle(
              color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
            ),
            checkmarkColor: AppColors.textWhite,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 0 : 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAnonymousToggle(BuildContext context) {
    final cubit = context.read<ComplaintCubit>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            cubit.isAnonymous ? Icons.person_off_rounded : Icons.person_rounded,
            size: 22,
            color: cubit.isAnonymous ? AppColors.primary : AppColors.grey500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إرسال مجهول الهوية',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'لن يظهر اسمك للآخرين',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: cubit.isAnonymous,
            onChanged: (value) {
              setState(() => cubit.isAnonymous = value);
            },
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
