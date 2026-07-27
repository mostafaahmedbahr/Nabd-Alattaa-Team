import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'core/utils/app_bloc_observer.dart';
import 'core/utils/service_locator.dart' as di;
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_strings.dart';
import 'features/auth/presentation/view_model/auth_bloc.dart';
import 'features/auth/data/repos_impl/auth_repo_impl.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
            authRepository: di.sl<AuthRepoImpl>(),
          )..add(const CheckAuthStatusEvent()),
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
      ),
    );
  }
}
