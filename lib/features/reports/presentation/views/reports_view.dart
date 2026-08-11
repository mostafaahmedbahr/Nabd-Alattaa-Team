import 'package:nabd_alattaa_team/features/reports/presentation/widgets/report_content.dart';
import 'package:nabd_alattaa_team/features/reports/presentation/widgets/report_filter_chips.dart';

import '../../../../common_imports.dart';
import '../view_model/report_cubit.dart';
import '../view_model/report_state.dart';
import '../widgets/reports_header.dart';

class ReportsView extends StatefulWidget {
  const ReportsView({super.key});

  @override
  State<ReportsView> createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView> {
  @override
  void initState() {
    super.initState();
    context.read<ReportCubit>().loadReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ReportCubit, ReportState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ReportCubit>().refresh();
            },
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const ReportsHeader(),
                const SliverToBoxAdapter(child: ReportFilterChips()),
                ReportContent(state: state),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cubit = context.read<ReportCubit>();
          await context.push(Routes.createReport);
          if (mounted) {
            cubit.refresh();
          }
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 28),
        label: Text(
          'بلاغ جديد',
          style: TextStyle(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
