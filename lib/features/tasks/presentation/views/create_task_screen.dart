import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../users/data/models/user_model.dart';
import '../../../users/presentation/widgets/user_search_dropdown.dart';
import '../../data/models/task_model.dart';
import '../view_model/task_cubit.dart';
import '../view_model/task_state.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPriority = 'medium';
  String _selectedAssigneeId = '';
  String _selectedAssigneeName = '';
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  String _currentUserName = '';
  String _currentUserId = '';

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  void _loadCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserId = user.uid;
      // Fetch user name from Firestore
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get()
          .then((doc) {
        if (doc.exists) {
          setState(() {
            _currentUserName = doc.data()?['user_name'] ?? '';
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createTask)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _titleController,
                labelText: AppStrings.taskTitle,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'عنوان المهمة مطلوب';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                labelText: AppStrings.taskDescription,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Assignee Dropdown
              UserSearchDropdown(
                selectedUserId: _selectedAssigneeId,
                selectedUserName: _selectedAssigneeName,
                onUserSelected: (UserModel user) {
                  setState(() {
                    _selectedAssigneeId = user.id ?? '';
                    _selectedAssigneeName = user.name;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Priority Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPriority,
                decoration: const InputDecoration(
                  labelText: AppStrings.priority,
                ),
                items: const [
                  DropdownMenuItem(value: 'high', child: Text('عالية')),
                  DropdownMenuItem(value: 'medium', child: Text('متوسطة')),
                  DropdownMenuItem(value: 'low', child: Text('منخفضة')),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedPriority = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Due Date
              ListTile(
                title: const Text(AppStrings.dueDate),
                subtitle: Text(
                  '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _dueDate = date;
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              BlocConsumer<TaskCubit, TaskState>(
                listener: (context, state) {
                  if (state is TaskLoaded) {
                    context.pop();
                  } else if (state is TaskError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                builder: (context, state) {
                  final isLoading = state is TaskCreating;
                  return CustomButton(
                    text: AppStrings.save,
                    isLoading: isLoading,
                    onPressed: isLoading
                        ? null
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final task = TaskModel(
                                id: const Uuid().v4(),
                                title: _titleController.text,
                                description: _descriptionController.text,
                                assigneeId: _selectedAssigneeId,
                                assigneeName: _selectedAssigneeName,
                                creatorId: _currentUserId,
                                creatorName: _currentUserName,
                                priority: _selectedPriority,
                                status: 'not_started',
                                dueDate: _dueDate,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              );

                              context.read<TaskCubit>().createTask(task);
                            }
                          },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
