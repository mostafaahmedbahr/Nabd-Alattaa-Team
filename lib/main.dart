import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/fcm_service.dart';
import 'core/utils/app_bloc_observer.dart';
import 'core/utils/service_locator.dart' as di;
import 'features/users/data/repos/users_repo.dart';
import 'my_app.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}
Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );
  await FCMService.initialize();
  Bloc.observer = AppBlocObserver();

  await di.init();

  print('🔥 [main] Testing UsersRepo.getAllUsers() directly...');
  try {
    final usersRepo = di.sl<UsersRepo>();
    final result = await usersRepo.getAllUsers();
    result.fold(
      (failure) => print('❌ [main] Failure: ${failure.message}'),
      (users) {
        print('✅ [main] Success! Got ${users.length} users');
        for (var user in users) {
          print('   👤 Name: ${user.name}, Email: ${user.email}, Role: ${user.role}');
        }
      },
    );
  } catch (e) {
    print('❌ [main] Exception: $e');
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

void main() async {
  await initializeApp();
  runApp(const NabdAlattaaApp());
}


