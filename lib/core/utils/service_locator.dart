import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/chat/data/repos/chat_repo.dart';
import '../../features/chat/data/repos/chat_repo_impl.dart';
import '../../features/users/data/repos/users_repo.dart';
import '../../features/users/presentation/view_model/users_cubit.dart';
import '../../features/announcements/data/repos/announcement_repo.dart';
import '../../features/announcements/data/repos/announcement_repo_impl.dart';
import '../../features/admin/data/repos/admin_repo.dart';
import '../../features/admin/data/repos_impl/admin_repo_impl.dart';
import '../../features/admin/presentation/view_model/admin_cubit.dart';
import '../../features/home/data/repos/home_repo.dart';
import '../../features/home/data/repos/home_repo_impl.dart';
import '../../features/home/presentation/view_model/home_cubit.dart';


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

  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
    firestore: sl(),
  ));

  sl.registerLazySingleton<UsersRepo>(() => UsersRepo());
  sl.registerFactory(() => UsersCubit(
    usersRepo: sl(),
  ));

  sl.registerLazySingleton<AnnouncementRepository>(
    () => AnnouncementRepoImpl(firestore: sl()),
  );

  sl.registerLazySingleton<AdminRepository>(() => AdminRepoImpl());
  sl.registerFactory(() => AdminCubit(sl()));

  sl.registerLazySingleton<HomeRepository>(() => HomeRepoImpl());
  sl.registerFactory(() => HomeCubit(homeRepository: sl()));
}
