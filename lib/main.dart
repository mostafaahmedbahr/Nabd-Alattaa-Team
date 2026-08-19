import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/services/fcm_service.dart';
import 'core/utils/app_bloc_observer.dart';
import 'core/utils/service_locator.dart' as di;
import 'firebase_options.dart';
import 'my_app.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );
  await FCMService.initialize();
  print("FCM Token: ${FCMService.token}");

  // لما التطبيق يكون شغال (foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('استلمت إشعار: ${message.notification?.title}');
    // تقدر تعرضه بـ flutter_local_notifications
  });

// لما المستخدم يدوس على الإشعار والتطبيق في الخلفية
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // تنقله لصفحة معينة مثلاً
  });
  Bloc.observer = AppBlocObserver();

  await di.init();

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
