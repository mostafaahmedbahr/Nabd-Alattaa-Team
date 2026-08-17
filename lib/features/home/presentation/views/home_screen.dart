import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/common_imports.dart';
import 'package:nabd_alattaa_team/features/layout/presentation/view_model/layout_cubit.dart';
import '../../../notifications/presentation/view_model/notification_cubit.dart';
import '../../../notifications/presentation/view_model/notification_state.dart';
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
    _loadNotifications();
  }

  void _loadData({bool forceRefresh = false}) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<HomeCubit>().loadHomeData(user.uid, forceRefresh: forceRefresh);
    }
  }

  void _loadNotifications() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<NotificationCubit>().loadNotifications(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("الرئيسية"),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              final count = state is NotificationLoaded ? state.unreadCount : 0;
              return Badge(
                label: Text(count.toString()),
                isLabelVisible: count > 0,
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    context.push('/notifications');
                  },
                ),
              );
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
              return CustomErrorWidget(
                onRetry: (){
                  _loadData(forceRefresh: true);
                },
                message: 'إعادة المحاولة',

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
