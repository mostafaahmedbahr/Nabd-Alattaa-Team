import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nabd_alattaa_team/features/layout/presentation/views/layout_view.dart';
import 'app_routes.dart';
import '../../features/register/presentation/views/register_view.dart';
import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/login/presentation/views/login_view.dart';
import '../../features/home/presentation/views/home_screen.dart';
import '../../features/tasks/presentation/views/tasks_screen.dart';
import '../../features/tasks/presentation/views/create_task_screen.dart';
import '../../features/tasks/presentation/views/task_details_screen.dart';
import '../../features/complaints/presentation/views/complaints_screen.dart';
import '../../features/complaints/presentation/views/create_complaint_screen.dart';
import '../../features/library/presentation/views/library_screen.dart';
import '../../features/ideas/presentation/views/ideas_screen.dart';
import '../../features/ideas/presentation/views/create_idea_screen.dart';
import '../../features/reports/presentation/views/reports_screen.dart';
import '../../features/reports/presentation/views/create_report_screen.dart';
import '../../features/notifications/presentation/views/notifications_screen.dart';
import '../../features/chat/presentation/views/chat_list_screen.dart';
import '../../features/chat/presentation/views/chat_room_screen.dart';
import '../../features/good_deeds/presentation/views/good_deeds_screen.dart';
import '../../features/good_deeds/presentation/views/create_good_deed_screen.dart';
import '../../features/meals/presentation/views/meals_screen.dart';
import '../../features/profile/presentation/views/profile_screen.dart';
import '../../features/profile/presentation/views/edit_profile_screen.dart';

class AppRouter {
  AppRouter._();

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,

    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;

      final isSplash = state.matchedLocation == Routes.splash;
      final isOnboarding = state.matchedLocation == Routes.onboarding;
      final isLogin = state.matchedLocation == Routes.login;
      final isRegister = state.matchedLocation == Routes.register;

      final isAuth = isLogin || isRegister;

      if (isSplash || isOnboarding) {
        return null;
      }

      if (user == null && !isAuth) {
        return Routes.login;
      }

      if (user != null && isAuth) {
        return Routes.home;
      }

      return null;
    },

    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) => const SplashView(),
      ),

      GoRoute(
        path: Routes.onboarding,
        builder: (_, _) => const OnboardingView(),
      ),

      GoRoute(
        path: Routes.login,
        builder: (_, _) => const LoginView(),
      ),

      GoRoute(
        path: Routes.register,
        builder: (_, _) => const RegisterView(),
      ),

      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => LayoutView(),
        routes: [
          GoRoute(
            path: Routes.home,
            builder: (_, _) => const HomeScreen(),
          ),

          GoRoute(
            path: Routes.tasks,
            builder: (_, _) => const TasksScreen(),
          ),

          GoRoute(
            path: Routes.complaints,
            builder: (_, _) => const ComplaintsScreen(),
          ),

          GoRoute(
            path: Routes.library,
            builder: (_, _) => const LibraryScreen(),
          ),

          GoRoute(
            path: Routes.ideas,
            builder: (_, _) => const IdeasScreen(),
          ),

          GoRoute(
            path: Routes.reports,
            builder: (_, _) => const ReportsScreen(),
          ),

          GoRoute(
            path: Routes.notifications,
            builder: (_, _) => const NotificationsScreen(),
          ),

          GoRoute(
            path: Routes.chat,
            builder: (_, _) => const ChatListScreen(),
          ),

          GoRoute(
            path: '${Routes.chat}/:roomId',
            builder: (context, state) => ChatRoomScreen(
              chatRoomId: state.pathParameters['roomId']!,
              chatRoomName: '',
            ),
          ),

          GoRoute(
            path: Routes.goodDeeds,
            builder: (_, _) => const GoodDeedsScreen(),
          ),

          GoRoute(
            path: Routes.meals,
            builder: (_, _) => const MealsScreen(),
          ),

          GoRoute(
            path: Routes.profile,
            builder: (_, _) => const ProfileScreen(),
          ),
        ],
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.createTask,
        builder: (_, _) => const CreateTaskScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: '${Routes.taskDetails}/:taskId',
        builder: (context, state) => TaskDetailsScreen(
          taskId: state.pathParameters['taskId']!,
        ),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.createComplaint,
        builder: (_, _) => const CreateComplaintScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.createIdea,
        builder: (_, _) => const CreateIdeaScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.createReport,
        builder: (_, _) => const CreateReportScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.createGoodDeed,
        builder: (_, _) => const CreateGoodDeedScreen(),
      ),

      GoRoute(
        parentNavigatorKey: _rootNavigatorKey,
        path: Routes.editProfile,
        builder: (_, _) => EditProfileScreen(
          userId: FirebaseAuth.instance.currentUser?.uid ?? '',
        ),
      ),
    ],
  );
}