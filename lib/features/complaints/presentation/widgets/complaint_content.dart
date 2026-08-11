import '../../../../common_imports.dart';
import '../view_model/complaint_cubit.dart';
import '../view_model/complaint_state.dart';
import 'complaint_card.dart';
import 'complaint_empty_state.dart';
///mostafa
class ComplaintContent extends StatelessWidget {
  const ComplaintContent({super.key, required this.state});

  final ComplaintState state;

  @override
  Widget build(BuildContext context) {
    if (state is ComplaintLoading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'جاري التحميل...'),
      );
    }

    if (state is ComplaintError) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: (state as ComplaintError).message,
          onRetry: () {
            context.read<ComplaintCubit>().refresh();
          },
        ),
      );
    }

    if (state is ComplaintLoaded) {
      final loadedState = state as ComplaintLoaded;

      if (loadedState.complaints.isEmpty) {
        return const SliverFillRemaining(child: ComplaintEmptyState());
      }

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        sliver: SliverList.separated(
          itemCount: loadedState.complaints.length,
          separatorBuilder: (_, _) => SizedBox(height: 4.h),
          itemBuilder: (context, index) {
            return ComplaintCard(
              complaint: loadedState.complaints[index],
              index: index,
            );
          },
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }
}
