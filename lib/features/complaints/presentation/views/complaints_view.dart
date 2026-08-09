import 'package:nabd_alattaa_team/features/complaints/presentation/widgets/complaint_content.dart';
import 'package:nabd_alattaa_team/features/complaints/presentation/widgets/complaint_filter_chips.dart';
import '../../../../common_imports.dart';
import '../view_model/complaint_cubit.dart';
import '../view_model/complaint_state.dart';
import '../widgets/complaints_header.dart';

class ComplaintsView extends StatefulWidget {
  const ComplaintsView({super.key});

  @override
  State<ComplaintsView> createState() => _ComplaintsViewState();
}

class _ComplaintsViewState extends State<ComplaintsView> {
  @override
  void initState() {
    super.initState();
    context.read<ComplaintCubit>().loadComplaints();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<ComplaintCubit, ComplaintState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<ComplaintCubit>().refresh();
            },
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const ComplaintsHeader(),
                const SliverToBoxAdapter(child: ComplaintFilterChips()),
                ComplaintContent(state: state),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cubit = context.read<ComplaintCubit>();
          await context.push(Routes.createComplaint);
          if (mounted) {
            cubit.refresh();
          }
        },
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: AppColors.textWhite, size: 28),
        label:   Text(
          'شكوى جديدة',
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
