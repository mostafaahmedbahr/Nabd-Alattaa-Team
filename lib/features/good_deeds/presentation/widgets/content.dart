import '../../../../common_imports.dart';
import '../../data/models/good_deed_model.dart';
import '../view_model/good_deed_cubit.dart';
import '../view_model/good_deed_state.dart';
import 'deed_details_bottom_sheet.dart';
import 'empty_state.dart';
import 'good_deed_card.dart';

class GoodDeedContent extends StatelessWidget {
  const GoodDeedContent({
    super.key,
    required this.state,


  });

  final GoodDeedState state;



  @override
  Widget build(BuildContext context) {

    if (state is GoodDeedLoading) {
      return const SliverFillRemaining(
        child: LoadingWidget(message: 'جاري التحميل...'),
      );
    }

    if (state is GoodDeedError) {
      return SliverFillRemaining(
        child: CustomErrorWidget(
          message: (state as GoodDeedError).message,
          onRetry: () {
            context.read<GoodDeedCubit>().loadGoodDeeds();
          },
        ),
      );
    }

    if (state is GoodDeedLoaded) {
      final loadedState = state as GoodDeedLoaded;

      if (loadedState.goodDeeds.isEmpty) {
        return SliverFillRemaining(child: EmptyState());
      }

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        sliver: SliverList.separated(
          itemCount: loadedState.goodDeeds.length,
          separatorBuilder: (_, _) =>   SizedBox(height: 4.h),
          itemBuilder: (context, index) {
            final deed = loadedState.goodDeeds[index];

            return GoodDeedCard(
              deed: deed,
              index: index,
              isLiked: false,
              onLike: () {
                context.read<GoodDeedCubit>().likeDeed(
                  deed.id,
                  'current_user_id',
                );
              },
              onTap: () => _showDeedDetails(deed,context),
            );
          },
        ),
      );
    }

    return const SliverToBoxAdapter(child: SizedBox.shrink());
  }

  void _showDeedDetails(GoodDeedModel deed,BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DeedDetailsBottomSheet(deed: deed),
    );
  }
}
