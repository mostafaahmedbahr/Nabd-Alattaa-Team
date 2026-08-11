import '../../../../common_imports.dart';
import '../view_model/report_cubit.dart';
import '../view_model/report_state.dart';
import 'report_card.dart';
import 'report_empty_state.dart';

class ReportContent extends StatelessWidget {
  const ReportContent({super.key, required this.state});

  final ReportState state;

  @override
  Widget build(BuildContext context) {
    if (state is ReportLoading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'جاري التحميل...'),
      );
    }

    if (state is ReportError) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: (state as ReportError).message,
          onRetry: () {
            context.read<ReportCubit>().refresh();
          },
        ),
      );
    }

    if (state is ReportLoaded) {
      final loadedState = state as ReportLoaded;

      if (loadedState.reports.isEmpty) {
        return const SliverFillRemaining(child: ReportEmptyState());
      }

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        sliver: SliverList.separated(
          itemCount: loadedState.reports.length,
          separatorBuilder: (_, _) => SizedBox(height: 4.h),
          itemBuilder: (context, index) {
            return ReportCard(
              report: loadedState.reports[index],
              index: index,
            );
          },
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
