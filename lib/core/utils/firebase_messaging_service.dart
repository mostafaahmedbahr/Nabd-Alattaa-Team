import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseMessagingService {
  FirebaseMessagingService({
    required FirebaseMessaging messaging,
    required SharedPreferences preferences,
  })  : _messaging = messaging,
        _preferences = preferences;

  final FirebaseMessaging _messaging;
  final SharedPreferences _preferences;

  static const String tokenKey = 'fcm_token';

  Future<void> initialize() async {
    await _requestPermission();

    await _cacheToken();

    _listenToTokenRefresh();

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    FirebaseMessaging.onMessage.listen((message) {
      log(
        'Foreground Notification: ${message.notification?.title}',
      );
    });
  }

  Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _cacheToken() async {
    final token = await _messaging.getToken();

    if (token != null) {
      await _preferences.setString(tokenKey, token);
      log('FCM Token: $token');
    }
  }

  void _listenToTokenRefresh() {
    _messaging.onTokenRefresh.listen((newToken) async {
      await _preferences.setString(tokenKey, newToken);

      log('Refreshed Token: $newToken');

      // TODO: Send the new token to your backend
    });
  }

  /// Returns the cached token first.
  /// If it doesn't exist, it fetches it from Firebase.
  Future<String?> getToken() async {
    final cached = _preferences.getString(tokenKey);

    if (cached != null && cached.isNotEmpty) {
      return cached;
    }

    final token = await _messaging.getToken();

    if (token != null) {
      await _preferences.setString(tokenKey, token);
    }

    return token;
  }

  Future<void> refreshToken() async {
    final token = await _messaging.getToken();

    if (token != null) {
      await _preferences.setString(tokenKey, token);
    }
  }

  Future<void> deleteToken() async {
    await _messaging.deleteToken();
    await _preferences.remove(tokenKey);
  }
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {
  log('Background Message: ${message.messageId}');
}