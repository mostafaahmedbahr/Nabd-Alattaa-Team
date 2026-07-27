import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
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
                  const Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.goodDeedContent,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'عمل الخير يبقى وأثره يدوم',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _controller,
                    textDirection: TextDirection.rtl,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'اكتب هنا...',
                      hintStyle: const TextStyle(color: AppColors.textHint),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignLabelWithHint: true,
                    ),
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
