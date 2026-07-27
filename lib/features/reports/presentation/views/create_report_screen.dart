import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../data/models/report_model.dart';
import '../view_model/report_cubit.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedType = 'other';

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createReport)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: AppStrings.reportTitle,
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
                labelText: AppStrings.reportContent,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedType,
                decoration: const InputDecoration(labelText: 'نوع البلاغ'),
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
              const SizedBox(height: 24),
              CustomButton(
                text: AppStrings.send,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final report = ReportModel(
                      id: const Uuid().v4(),
                      title: _titleController.text,
                      content: _contentController.text,
                      type: _selectedType,
                      creatorId: 'current_user',
                      creatorName: 'المستخدم',
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    context.read<ReportCubit>().createReport(report);
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
