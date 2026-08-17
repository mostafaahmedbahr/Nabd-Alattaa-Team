import '../../../../../common_imports.dart';
import '../../../../users/data/models/user_model.dart';
import '../../../../users/presentation/widgets/user_search_dropdown.dart';
import '../../../data/models/task_model.dart';
import '../../view_model/task_cubit.dart';

class ForwardTaskSheet extends StatefulWidget {
  final TaskModel task;

  const ForwardTaskSheet({super.key, required this.task});

  @override
  State<ForwardTaskSheet> createState() => _ForwardTaskSheetState();
}

class _ForwardTaskSheetState extends State<ForwardTaskSheet> {
  String? _selectedUserId;
  String? _selectedUserName;
  final _noteController = TextEditingController();
  bool _isForwarding = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(16.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              const Text(
                'توجيه المهمة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'المهمة',
                      style: TextStyle(fontSize: 12, color: AppColors.grey400),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      widget.task.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'الموظف الحالي: ${widget.task.assigneeName}',
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              const Text(
                'الموظف المستلم',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8.h),
              UserSearchDropdown(
                selectedUserId: _selectedUserId,
                selectedUserName: _selectedUserName,
                onUserSelected: (UserModel user) {
                  setState(() {
                    _selectedUserId = user.id;
                    _selectedUserName = user.name;
                  });
                },
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: _noteController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'ملاحظة اختيارية للتوجيه',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isForwarding || _selectedUserId == null
                      ? null
                      : () {
                          setState(() => _isForwarding = true);
                          context.read<TaskCubit>().forwardTask(
                                originalTask: widget.task,
                                toUserId: _selectedUserId!,
                                toUserName: _selectedUserName!,
                                note: _noteController.text.trim().isEmpty
                                    ? null
                                    : _noteController.text.trim(),
                              );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isForwarding
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'توجيه المهمة',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }
}
