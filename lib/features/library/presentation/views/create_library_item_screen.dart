import '../../../../common_imports.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../view_model/library_cubit.dart';
import '../view_model/library_state.dart';

class CreateLibraryItemScreen extends StatefulWidget {
  const CreateLibraryItemScreen({super.key});

  @override
  State<CreateLibraryItemScreen> createState() => _CreateLibraryItemScreenState();
}

class _CreateLibraryItemScreenState extends State<CreateLibraryItemScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const _categories = [
    ('الكل', ''),
    ('اللوجو', 'logo'),
    ('العقود', 'contracts'),
    ('السياسات', 'policies'),
    ('Word', 'word'),
    ('Excel', 'excel'),
    ('PDF', 'pdf'),
  ];

  String _selectedCategory = '';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<LibraryCubit>().addItem(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim(),
            category: _selectedCategory,
            fileUrl: _linkController.text.trim(),
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تمت إضافة الرابط بنجاح'),
          backgroundColor: AppColors.success,
        ),
      );

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'إضافة رابط'),
        body: BlocListener<LibraryCubit, LibraryState>(
          listener: (context, state) {
            if (state is LibraryActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Icon(
                    Icons.link_rounded,
                    size: 64.sp,
                    color: AppColors.primary,
                  ),
                    SizedBox(height: 24.h),
                    Text(
                    'جمع الروابط المهمة في مكان واحد',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                    SizedBox(height: 24.h),
                  TextFormField(
                    controller: _nameController,
                    textDirection: TextDirection.rtl,
                    decoration: InputDecoration(
                      labelText: 'اسم الرابط',
                      hintText: 'مثال: نموذج طلب إجازة',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'اكتب اسم الرابط';
                      }
                      return null;
                    },
                  ),
                    SizedBox(height: 16.h),
                  TextFormField(
                    controller: _descriptionController,
                    textDirection: TextDirection.rtl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'وصف مختصر (اختياري)',
                      hintText: 'وصف بسيط للرابط',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  ),
                    SizedBox(height: 16.h),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _linkController,
                    textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.url,
                    decoration: InputDecoration(
                      labelText: 'الرابط',
                      hintText: 'https://example.com',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'اكتب الرابط';
                      }
                      final uri = Uri.tryParse(value.trim());
                      if (uri == null ||
                          (uri.scheme != 'http' && uri.scheme != 'https')) {
                        return 'اكتب رابط صحيح يبدأ بـ http أو https';
                      }
                      return null;
                    },
                  ),
                    SizedBox(height: 16.h),
                    Text(
                    'التصنيف',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                    SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories
                        .where((c) => c.$2.isNotEmpty)
                        .map(
                          (category) => ChoiceChip(
                            label: Text(category.$1),
                            selected: _selectedCategory == category.$2,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = selected
                                    ? category.$2
                                    : '';
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                    SizedBox(height: 24.h),
                  CustomButton(
                    text: 'إضافة',
                    onPressed: _submit,
                    icon: Icons.add_link_rounded,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
