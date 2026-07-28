import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../features/splash/presentation/views/splash_view.dart';
import '../../features/onboarding/presentation/views/onboarding_view.dart';
import '../../features/login/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/register_screen.dart';
import '../../features/home/presentation/views/main_screen.dart';
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
import '../../features/admin/presentation/views/admin_dashboard_screen.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final isSplashRoute = state.matchedLocation == '/splash';
      final isOnboardingRoute = state.matchedLocation == '/onboarding';
      final isLoginRoute = state.matchedLocation == '/login';
      final isRegisterRoute = state.matchedLocation == '/register';
      final isAuthRoute = isLoginRoute || isRegisterRoute;

      if (isSplashRoute || isOnboardingRoute) {
        return null;
      }

      if (user == null && !isAuthRoute) {
        return '/login';
      }

      if (user != null && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainScreen( ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const MainScreen( ),
          ),
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TasksScreen(),
          ),
          // GoRoute(
          //   path: '/announcements',
          //   builder: (context, state) => const AnnouncementsScreen(),
          // ),
          GoRoute(
            path: '/complaints',
            builder: (context, state) => const ComplaintsScreen(),
          ),
          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryScreen(),
          ),
          GoRoute(
            path: '/ideas',
            builder: (context, state) => const IdeasScreen(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatListScreen(),
          ),
          GoRoute(
            path: '/chat/:roomId',
            builder: (context, state) => ChatRoomScreen(
              chatRoomId: state.pathParameters['roomId']!,
              chatRoomName: state.pathParameters['chatRoomName']!,
            ),
          ),
          GoRoute(
            path: '/good-deeds',
            builder: (context, state) => const GoodDeedsScreen(),
          ),
          GoRoute(
            path: '/meals',
            builder: (context, state) => const MealsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/admin',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/create-task',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateTaskScreen(),
      ),
      GoRoute(
        path: '/task-details/:taskId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => TaskDetailsScreen(
          taskId: state.pathParameters['taskId']!,
        ),
      ),
      // GoRoute(
      //   path: '/create-announcement',
      //   parentNavigatorKey: _rootNavigatorKey,
      //   builder: (context, state) => const CreateAnnouncementScreen(),
      // ),
      GoRoute(
        path: '/create-complaint',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateComplaintScreen(),
      ),
      GoRoute(
        path: '/create-idea',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateIdeaScreen(),
      ),
      GoRoute(
        path: '/create-report',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateReportScreen(),
      ),
      GoRoute(
        path: '/create-good-deed',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CreateGoodDeedScreen(),
      ),
    ],
  );
}
