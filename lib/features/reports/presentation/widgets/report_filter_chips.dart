import 'package:nabd_alattaa_team/features/reports/presentation/view_model/report_state.dart';

import '../../../../common_imports.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../view_model/report_cubit.dart';
import 'report_filter_chip.dart';

class ReportFilterChips extends StatelessWidget {
  const ReportFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportCubit, ReportState>(
      builder: (context, state) {
        final cubit = context.read<ReportCubit>();
        return Container(
          color: AppColors.background,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            children: [
              ReportFilterChip(
                label: 'الكل',
                filter: 'all',
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor('all'),
              ),
              const SizedBox(width: 8),
              ReportFilterChip(
                label: 'مفتوح',
                filter: ReportStatus.open,
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor(ReportStatus.open),
              ),
              const SizedBox(width: 8),
              ReportFilterChip(
                label: 'قيد التنفيذ',
                filter: ReportStatus.inProgress,
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor(ReportStatus.inProgress),
              ),
              const SizedBox(width: 8),
              ReportFilterChip(
                label: 'تم الحل',
                filter: ReportStatus.resolved,
                selectedFilter: cubit.selectedFilter,
                onFilterSelected: cubit.changeFilter,
                color: _chipColor(ReportStatus.resolved),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _chipColor(String filter) {
    switch (filter) {
      case ReportStatus.open:
        return AppColors.info;
      case ReportStatus.inProgress:
        return AppColors.warning;
      case ReportStatus.resolved:
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }
}
