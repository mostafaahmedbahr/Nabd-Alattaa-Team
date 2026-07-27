import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/complaint_model.dart';
import '../view_model/complaint_cubit.dart';

class CreateComplaintScreen extends StatefulWidget {
  const CreateComplaintScreen({super.key});

  @override
  State<CreateComplaintScreen> createState() => _CreateComplaintScreenState();
}

class _CreateComplaintScreenState extends State<CreateComplaintScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedType = 'other';
  bool _isAnonymous = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.submitComplaint)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: AppStrings.complaintTitle,
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
                labelText: AppStrings.complaintContent,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'نوع المشكلة'),
                items: const [
                  DropdownMenuItem(value: 'breakdown', child: Text('عطل')),
                  DropdownMenuItem(value: 'printer', child: Text('مشكلة في الطابعة')),
                  DropdownMenuItem(value: 'internet', child: Text('مشكلة في الإنترنت')),
                  DropdownMenuItem(value: 'ac', child: Text('التكييف')),
                  DropdownMenuItem(value: 'cleanliness', child: Text('النظافة')),
                  DropdownMenuItem(value: 'electricity', child: Text('الكهرباء')),
                  DropdownMenuItem(value: 'other', child: Text('أخرى')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text(AppStrings.anonymous),
                value: _isAnonymous,
                onChanged: (value) {
                  setState(() {
                    _isAnonymous = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.send,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final complaint = ComplaintModel(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      content: _contentController.text,
                      type: _selectedType,
                      isAnonymous: _isAnonymous,
                      creatorId: 'current_user',
                      creatorName: _isAnonymous ? 'مجهول' : 'المستخدم',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    context.read<ComplaintCubit>().createComplaint(complaint);
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
