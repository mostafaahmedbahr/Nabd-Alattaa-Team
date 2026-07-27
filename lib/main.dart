import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/utils/app_bloc_observer.dart';
import 'core/utils/service_locator.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_strings.dart';
import 'features/auth/presentation/view_model/auth_bloc.dart';
import 'features/auth/presentation/view_model/auth_event.dart';
import 'features/auth/presentation/view_model/register_cubit.dart';
import 'features/auth/data/repos_impl/auth_repo_impl.dart';
import 'features/auth/data/repos_impl/register_repo_impl.dart';
import 'features/auth/data/repos/auth_repo.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(

  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  Bloc.observer = AppBlocObserver();

  await di.init();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const NabdAlAtaaApp());
}

class NabdAlAtaaApp extends StatelessWidget {
  const NabdAlAtaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
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
    );
  }
}
