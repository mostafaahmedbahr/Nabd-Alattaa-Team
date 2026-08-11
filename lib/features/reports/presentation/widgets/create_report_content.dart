import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../view_model/report_cubit.dart';
import '../view_model/report_state.dart';
import 'report_section_title.dart';
import 'report_submit_button.dart';

class CreateReportContent extends StatefulWidget {
  const CreateReportContent({super.key, required this.fadeAnimation});

  final Animation<double> fadeAnimation;

  @override
  State<CreateReportContent> createState() => _CreateReportContentState();
}

class _CreateReportContentState extends State<CreateReportContent> {
  static const _types = [
    ('عطل', ReportType.breakdown, Icons.build_rounded),
    ('مشكلة في الطابعة', ReportType.printer, Icons.print_rounded),
    ('مشكلة في الإنترنت', ReportType.internet, Icons.wifi_off_rounded),
    ('التكييف', ReportType.ac, Icons.ac_unit_rounded),
    ('النظافة', ReportType.cleanliness, Icons.cleaning_services_rounded),
    ('الكهرباء', ReportType.electricity, Icons.bolt_rounded),
    ('أخرى', ReportType.other, Icons.help_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: BlocConsumer<ReportCubit, ReportState>(
        builder: (context, state) {
          final cubit = context.read<ReportCubit>();
          return FadeTransition(
            opacity: widget.fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const ReportSectionTitle(
                      title: 'عنوان البلاغ',
                      icon: Icons.title_rounded,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: cubit.titleController,
                      hintText: 'اكتب عنوان البلاغ...',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'العنوان مطلوب';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 28),
                    const ReportSectionTitle(
                      title: 'تفاصيل البلاغ',
                      icon: Icons.description_rounded,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: cubit.contentController,
                      hintText: 'اشرح المشكلة بالتفصيل...',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 28),
                    const ReportSectionTitle(
                      title: 'نوع المشكلة',
                      icon: Icons.category_rounded,
                    ),
                    const SizedBox(height: 12),
                    _buildTypeSelector(context),
                    const SizedBox(height: 36),
                    ReportSubmitButton(cubit: cubit),
                  ],
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is ReportActionError) {
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
    final cubit = context.read<ReportCubit>();
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
                cubit.selectedType = selected ? type.$2 : ReportType.other;
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
}
