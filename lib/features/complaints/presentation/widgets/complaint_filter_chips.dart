import 'package:nabd_alattaa_team/features/complaints/presentation/view_model/complaint_state.dart';

import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../view_model/complaint_cubit.dart';
import 'complaint_filter_chip.dart';

class ComplaintFilterChips extends StatelessWidget {
  const ComplaintFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplaintCubit,ComplaintState>(
      builder: (context,state){
        final cubit = context.read<ComplaintCubit>();
        return Container(
          color: AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              ComplaintFilterChip(
                label: 'الكل',
                filter: 'all',
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor('all'),
              ),
                SizedBox(width: 8.w),
              ComplaintFilterChip(
                label: 'قيد الانتظار',
                filter: 'pending',
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor('pending'),
              ),
                 SizedBox(width: 8.w),
              ComplaintFilterChip(
                label: 'قيد التنفيذ',
                filter: 'in_progress',
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor('in_progress'),
              ),
              SizedBox(width: 8.w),
              ComplaintFilterChip(
                label: 'مكتمل',
                filter: ComplaintStatus.resolved,
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor(ComplaintStatus.resolved),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _chipColor(String filter) {
    switch (filter) {
      case 'pending':
        return AppColors.primary;
      case 'in_progress':
        return AppColors.info;
      case ComplaintStatus.resolved:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }
}
