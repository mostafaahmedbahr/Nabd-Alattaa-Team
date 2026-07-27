import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/idea_model.dart';
import '../view_model/idea_cubit.dart';

class CreateIdeaScreen extends StatefulWidget {
  const CreateIdeaScreen({super.key});

  @override
  State<CreateIdeaScreen> createState() => _CreateIdeaScreenState();
}

class _CreateIdeaScreenState extends State<CreateIdeaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.submitIdea)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: AppStrings.ideaTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'العنوان مطلوب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _contentController,
                labelText: AppStrings.ideaContent,
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.send,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final idea = IdeaModel(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      content: _contentController.text,
                      creatorId: 'current_user',
                      creatorName: 'المستخدم',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    context.read<IdeaCubit>().createIdea(idea);
                    context.pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
