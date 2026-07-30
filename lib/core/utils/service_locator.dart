import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_messaging_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerLazySingleton<SharedPreferences>(
        () => sharedPreferences,
  );

  sl.registerLazySingleton<FirebaseAuth>(
        () => FirebaseAuth.instance,
  );

  sl.registerLazySingleton<FirebaseFirestore>(
        () => FirebaseFirestore.instance,
  );

  sl.registerLazySingleton<FirebaseMessaging>(
        () => FirebaseMessaging.instance,
  );

  sl.registerLazySingleton<FirebaseAnalytics>(
        () => FirebaseAnalytics.instance,
  );

  sl.registerLazySingleton<FirebaseCrashlytics>(
        () => FirebaseCrashlytics.instance,
  );

  sl.registerLazySingleton<FirebaseMessagingService>(
        () => FirebaseMessagingService(
      messaging: sl<FirebaseMessaging>(),
      preferences: sl<SharedPreferences>(),
    ),
  );
}