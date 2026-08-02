import '../../../../common_imports.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../view_model/good_deed_cubit.dart';
import '../view_model/good_deed_state.dart';

class CreateGoodDeedScreen extends StatefulWidget {
  const CreateGoodDeedScreen({super.key});

  @override
  State<CreateGoodDeedScreen> createState() => _CreateGoodDeedScreenState();
}

class _CreateGoodDeedScreenState extends State<CreateGoodDeedScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<GoodDeedCubit>().addGoodDeed(
            content: _controller.text.trim(),
            creatorId: 'current_user_id',
          );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppStrings.goodDeedShared),
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
        appBar: const CustomAppBar(title: AppStrings.shareGoodDeed),
        body: BlocListener<GoodDeedCubit, GoodDeedState>(
          listener: (context, state) {
            if (state is GoodDeedActionError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Icon(
                    Icons.favorite_border,
                    size: 64.sp,
                    color: AppColors.primary,
                  ),
                    SizedBox(height: 24.h),
                    Text(
                    AppStrings.goodDeedContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                    SizedBox(height: 8.h),
                    Text(
                    'عمل الخير يبقى وأثره يدوم',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                    SizedBox(height: 24.h),
                  CustomTextField(
                    controller: _controller,
                    maxLines: 5,
                    hintText: 'اكتب هنا...',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'اكتب عمل الخير الذي قمت به';
                      }
                      if (value.trim().length < 5) {
                        return 'اكتب المزيد من التفاصيل';
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  CustomButton(
                    text: 'مشاركة',
                    onPressed: _submit,
                    icon: Icons.send_outlined,
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
