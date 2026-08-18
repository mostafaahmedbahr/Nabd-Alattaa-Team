import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/adaptive_layout.dart';
import '../../../ideas/data/models/idea_model.dart';
import '../view_model/admin_cubit.dart';
import '../view_model/admin_state.dart';

class ManageIdeasScreen extends StatefulWidget {
  const ManageIdeasScreen({super.key});

  @override
  State<ManageIdeasScreen> createState() => _ManageIdeasScreenState();
}

class _ManageIdeasScreenState extends State<ManageIdeasScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AdminCubit>().loadIdeas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'إدارة الأفكار',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AdminCubit, AdminState>(
        listener: (context, state) {
          if (state is AdminSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
            context.read<AdminCubit>().loadIdeas();
          } else if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const LoadingWidget(message: 'جارٍ التحميل');
          }

          if (state is AdminError) {
            return CustomErrorWidget(
              message: state.message,
              onRetry: () => context.read<AdminCubit>().loadIdeas(),
            );
          }

          if (state is IdeasLoaded) {
            if (state.ideas.isEmpty) {
              return const EmptyStateWidget(
                message: 'لا توجد أفكار',
                icon: Icons.lightbulb_outline,
              );
            }

            return AdaptiveContainer(
              child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: state.ideas.length,
              itemBuilder: (context, index) {
                final idea = state.ideas[index];
                return _IdeaCard(
                  idea: idea,
                  onTap: () => _showStatusSheet(context, idea),
                );
              },
            ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showStatusSheet(BuildContext context, IdeaModel idea) {
    String selectedStatus = idea.status;
    final ratingController =
        TextEditingController(text: idea.rating > 0 ? '${idea.rating}' : '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final options = [
            (IdeaStatus.pending, 'قيد المراجعة', AppColors.info),
            (IdeaStatus.accepted, 'مقبولة', Colors.green),
            (IdeaStatus.rejected, 'مرفوضة', AppColors.error),
            (IdeaStatus.implemented, 'منفذة', AppColors.primary),
          ];

          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'تغيير حالة الفكرة',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ...options.map((option) {
                  final isSelected = selectedStatus == option.$1;
                  return RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(option.$2),
                    secondary: Icon(Icons.circle, color: option.$3, size: 14),
                    value: option.$1,
                    groupValue: selectedStatus,
                    onChanged: (value) =>
                        setSheetState(() => selectedStatus = value!),
                  );
                }),
                const SizedBox(height: 8),
                TextField(
                  controller: ratingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'التقييم (من 5)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final rating =
                          int.tryParse(ratingController.text) ?? 0;
                      Navigator.pop(sheetContext);
                      context
                          .read<AdminCubit>()
                          .changeIdeaStatus(idea.id, selectedStatus, rating);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('تأكيد'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _IdeaCard extends StatelessWidget {
  final IdeaModel idea;
  final VoidCallback onTap;

  const _IdeaCard({required this.idea, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(idea.status);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      idea.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusInfo.$2.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusInfo.$1,
                      style: TextStyle(
                        fontSize: 11,
                        color: statusInfo.$2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                idea.content,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person_outline,
                      size: 14, color: AppColors.grey400),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      idea.creatorName,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (idea.rating > 0) ...[
                    Icon(Icons.star, size: 14, color: AppColors.accent),
                    const SizedBox(width: 2),
                    Text(
                      '${idea.rating}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  (String, Color) _statusInfo(String status) {
    switch (status) {
      case IdeaStatus.accepted:
        return ('مقبولة', Colors.green);
      case IdeaStatus.rejected:
        return ('مرفوضة', AppColors.error);
      case IdeaStatus.implemented:
        return ('منفذة', AppColors.primary);
      default:
        return ('قيد المراجعة', AppColors.info);
    }
  }
}
