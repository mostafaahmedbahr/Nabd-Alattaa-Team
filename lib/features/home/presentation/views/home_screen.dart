import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/common_imports.dart';
import 'package:nabd_alattaa_team/features/layout/presentation/view_model/layout_cubit.dart';
import '../view_model/home_cubit.dart';
import '../view_model/home_states.dart';
import '../widgets/welcome_section.dart';
import '../widgets/quick_actions_grid.dart';
import '../widgets/tasks_section.dart';
import '../widgets/stats_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final state = context.read<HomeCubit>().state;
    if (state is! HomeLoaded) {
      _loadData();
    }
  }

  void _loadData({bool forceRefresh = false}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<HomeCubit>().loadHomeData(user.uid, forceRefresh: forceRefresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("الرئيسية"),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              context.push('/notifications');
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<HomeCubit, HomeStates>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            if (state is HomeError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => _loadData(forceRefresh: true),
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            if (state is HomeLoaded) {
              return RefreshIndicator(
                onRefresh: () async => _loadData(forceRefresh: true),
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
                        reportsCount: state.reportsCount,
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
      ),
    );
  }
}
