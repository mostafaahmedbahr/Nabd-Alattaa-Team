import 'package:nabd_alattaa_team/features/home/presentation/widgets/quick_actions_grid.dart';
import 'package:nabd_alattaa_team/features/home/presentation/widgets/stats_section.dart';
import 'package:nabd_alattaa_team/features/home/presentation/widgets/tasks_section.dart';
import 'package:nabd_alattaa_team/features/home/presentation/widgets/welcome_section.dart';
import '../../../../common_imports.dart';
import '../../../layout/presentation/view_model/layout_cubit.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is HomeError) {
            return CustomErrorWidget(
              onRetry: (){
                context.read<HomeCubit>().loadData(forceRefresh: true);
              },
              message: 'إعادة المحاولة',

            );
          }
          if (state is HomeLoaded) {
            return RefreshIndicator(
              onRefresh: () async =>  context.read<HomeCubit>().loadData(forceRefresh: true),
              color: AppColors.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const WelcomeSection(),
                    SizedBox(height: 20.h),
                    StatsSection(
                      goodDeedsCount: state.goodDeedsCount,
                      complaintsCount: state.complaintsCount,
                      ideasCount: state.ideasCount,
                    ),
                    SizedBox(height: 20.h),
                    const QuickActionsGrid(),
                    SizedBox(height: 20.h),
                    TasksSection(
                      tasks: state.tasks.take(2).toList(),
                      totalCount: state.totalTasksCount,
                      onSeeAll: () {
                        context.read<LayoutCubit>().changeBottomNav(1);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
