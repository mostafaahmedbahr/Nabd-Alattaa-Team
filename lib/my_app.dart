import 'package:flutter_localizations/flutter_localizations.dart';
import 'common_imports.dart';
import 'core/utils/service_locator.dart' as di;
import 'features/login/data/repos/login_repos_impl.dart';
import 'features/login/presentation/view_model/login_cubit.dart';

import 'features/onboarding/presentation/view_model/onboarding_cubit.dart';
import 'features/profile/data/repos_impl/profile_repo_impl.dart';
import 'features/profile/presentation/view_model/profile_cubit.dart';
import 'features/register/data/repos/register_repos_impl.dart';
import 'features/register/presentation/view_model/register_cubit.dart';
import 'features/users/data/repos/users_repo.dart';
import 'features/users/presentation/view_model/users_cubit.dart';

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
        ],
        child: MaterialApp.router(
          title: AppStrings.appName,
          theme: AppTheme.lightTheme,
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
