import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../data/models/user_model.dart';
import '../view_model/users_cubit.dart';
import '../view_model/users_states.dart';

class UserSearchDropdown extends StatefulWidget {
  final String? selectedUserId;
  final String? selectedUserName;
  final ValueChanged<UserModel> onUserSelected;

  const UserSearchDropdown({
    super.key,
    this.selectedUserId,
    this.selectedUserName,
    required this.onUserSelected,
  });

  @override
  State<UserSearchDropdown> createState() => _UserSearchDropdownState();
}

class _UserSearchDropdownState extends State<UserSearchDropdown> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showUserBottomSheet(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            Icon(Icons.person_outline, color: AppColors.grey400, size: 20.r),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                widget.selectedUserName ?? 'اختر الموظف',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: widget.selectedUserName != null
                      ? AppColors.textPrimary
                      : AppColors.grey400,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: AppColors.grey400, size: 20.r),
          ],
        ),
      ),
    );
  }

  void _showUserBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<UsersCubit>(),
        child: _UserSearchSheet(
          selectedUserId: widget.selectedUserId,
          onUserSelected: (user) {
            widget.onUserSelected(user);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}

class _UserSearchSheet extends StatefulWidget {
  final String? selectedUserId;
  final ValueChanged<UserModel> onUserSelected;

  const _UserSearchSheet({
    this.selectedUserId,
    required this.onUserSelected,
  });

  @override
  State<_UserSearchSheet> createState() => _UserSearchSheetState();
}

class _UserSearchSheetState extends State<_UserSearchSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر الموظف',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'بحث بالاسم...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: BlocBuilder<UsersCubit, UsersStates>(
                  builder: (context, state) {
                    if (state is UsersLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is UsersErrorState) {
                      return Center(child: Text(state.message));
                    }

                    if (state is UsersSuccessState) {
                      final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                      final filteredUsers = state.users.where((user) {
                        if (user.id == currentUserId) return false;
                        final name = user.name.toLowerCase();
                        final query = _searchQuery.toLowerCase();
                        return name.contains(query);
                      }).toList();

                      if (filteredUsers.isEmpty) {
                        return const Center(child: Text('لا يوجد نتائج'));
                      }

                      return ListView.builder(
                        controller: scrollController,
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          final isSelected = user.id == widget.selectedUserId;

                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Text(
                                user.name.isNotEmpty ? user.name[0] : '?',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.position.isNotEmpty ? user.position : user.email),
                            trailing: isSelected
                                ? Icon(Icons.check_circle, color: AppColors.primary)
                                : null,
                            onTap: () => widget.onUserSelected(user),
                          );
                        },
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
