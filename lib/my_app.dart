import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nabd_alattaa_team/features/admin/presentation/view_model/admin_cubit.dart';
import 'package:nabd_alattaa_team/features/layout/presentation/view_model/layout_cubit.dart';
import 'common_imports.dart';
import 'core/utils/service_locator.dart' as di;
import 'features/admin/data/repos_impl/admin_repo_impl.dart';
import 'features/chat/data/repos/chat_repo.dart';
import 'features/chat/presentation/view_model/chat_cubit.dart';
import 'features/complaints/data/repos/complaint_repo_impl.dart';
import 'features/complaints/presentation/view_model/complaint_cubit.dart';
import 'features/good_deeds/data/repos/good_deed_repo_impl.dart';
import 'features/good_deeds/presentation/view_model/good_deed_cubit.dart';
import 'features/home/presentation/view_model/home_cubit.dart';
import 'features/ideas/data/repos_impl/idea_repo_impl.dart';
import 'features/ideas/presentation/view_model/idea_cubit.dart';
import 'features/library/data/repos_impl/library_repo_impl.dart';
import 'features/library/presentation/view_model/library_cubit.dart';
import 'features/meals/data/repos_impl/meal_repo_impl.dart';
import 'features/meals/presentation/view_model/meal_cubit.dart';
import 'features/login/data/repos/login_repos_impl.dart';
import 'features/login/presentation/view_model/login_cubit.dart';

import 'features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'features/profile/data/repos/profile_repo_impl.dart';
import 'features/profile/presentation/view_model/profile_cubit.dart';
import 'features/register/data/repos/register_repos_impl.dart';
import 'features/register/presentation/view_model/register_cubit.dart';
import 'features/tasks/data/repos/task_repo_impl.dart';
import 'features/tasks/presentation/view_model/task_cubit.dart';
import 'features/notifications/data/repos_impl/notification_repo_impl.dart';
import 'features/notifications/presentation/view_model/notification_cubit.dart';
import 'features/users/presentation/view_model/users_cubit.dart';
import 'features/announcements/presentation/view_model/announcement_cubit.dart';

class NabdAlattaaApp extends StatelessWidget {
  const NabdAlattaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=>LayoutCubit()),
          BlocProvider(
            create: (_) => LoginCubit(
              loginRepository: LoginRepoImpl(
                firebaseAuth: di.sl(),
                firestore: di.sl(),
              ),
            ),
          ),
          BlocProvider<UsersCubit>(
            create: (_) {
              print('🟢 [my_app] Creating UsersCubit...');
              final cubit = di.sl<UsersCubit>();
              print('🟢 [my_app] UsersCubit created, calling getAllUsers()...');
              cubit.getAllUsers();
              return cubit;
            },
          ),
          // BlocProvider(
          //   create: (_) => AuthBloc(
          //     authRepository: di.sl<AuthRepository>(),
          //   )..add(CheckAuthStatusEvent()),
          // ),
          BlocProvider(
            create: (_) => RegisterCubit(
              registerRepo: RegisterRepoImpl(
                firebaseAuth: di.sl(),
                firestore: di.sl(),
              ),
            ),
          ),
          BlocProvider(
            create: (_) => OnboardingCubit(),
          ),
          BlocProvider(
            create: (_) => ProfileCubit(ProfileRepoImpl()),
          ),
          BlocProvider(
            create: (_) => TaskCubit(
              taskRepository: TaskRepoImpl(
                firestore: di.sl(),
              ),
            ),
          ),
          BlocProvider(
            create: (_) => HomeCubit(),
          ),
          BlocProvider(
            create: (_) => ChatCubit(
              chatRepository: di.sl<ChatRepository>(),
            ),
          ),
          BlocProvider(
            create: (_) => AdminCubit(
              AdminRepoImpl(),
            ),
          ),
          BlocProvider(
            create: (_) => GoodDeedCubit(
              repository: GoodDeedRepoImpl(),
            ),
          ),
          BlocProvider(
            create: (_) => LibraryCubit(
              libraryRepository: LibraryRepoImpl(firestore: di.sl()),
            ),
          ),
          BlocProvider(
            create: (_) => NotificationCubit(
              repository: NotificationRepoImpl(),
            ),
          ),
          BlocProvider(
            create: (_) => ComplaintCubit(
              repository: ComplaintRepoImpl(),
            ),
          ),
          BlocProvider(
            create: (_) => IdeaCubit(
              ideaRepository: IdeaRepoImpl(firestore: di.sl()),
            ),
          ),
          BlocProvider(
            create: (_) => AnnouncementCubit(),
          ),
          BlocProvider(
            create: (_) => MealCubit(MealRepoImpl()),
          ),

        ],
        child: MaterialApp.router(
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
          // home: LoginView(),
           routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
          locale: const Locale('ar', 'SA'),
          supportedLocales: const [
            Locale('ar', 'SA'),
            Locale('en', 'US'),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        ),
      ),
    );
  }
}
