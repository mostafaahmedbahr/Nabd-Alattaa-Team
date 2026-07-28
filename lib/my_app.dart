import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'common_imports.dart';
import 'core/utils/service_locator.dart' as di;
import 'features/auth/data/repos/auth_repo.dart';
import 'features/auth/data/repos_impl/register_repo_impl.dart';
import 'features/auth/presentation/view_model/auth_bloc.dart';
import 'features/auth/presentation/view_model/auth_event.dart';
import 'features/auth/presentation/view_model/register_cubit.dart';




class NabdAlattaaApp extends StatelessWidget {
  const NabdAlattaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc(
              authRepository: di.sl<AuthRepository>(),
            )..add(CheckAuthStatusEvent()),
          ),
          BlocProvider(
            create: (_) => RegisterCubit(
              registerRepo: RegisterRepoImpl(
                firebaseAuth: di.sl(),
                firestore: di.sl(),
              ),
            ),
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