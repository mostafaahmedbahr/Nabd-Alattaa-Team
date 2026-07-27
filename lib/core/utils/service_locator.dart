import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/data/repos_impl/auth_repo_impl.dart';
import '../../features/auth/data/repos/auth_repo.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
  sl.registerLazySingleton(() => FirebaseAnalytics.instance);
  sl.registerLazySingleton(() => FirebaseCrashlytics.instance);

  // Repos
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepoImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      sharedPreferences: sl(),
    ),
  );
  sl.registerLazySingleton<AuthRepoImpl>(
    () => AuthRepoImpl(
      firebaseAuth: sl(),
      firestore: sl(),
      sharedPreferences: sl(),
    ),
  );
}
