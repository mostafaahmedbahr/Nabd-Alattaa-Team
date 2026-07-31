import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  FCMService._();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String? _token;

  static String? get token => _token;

  static Future<void> initialize() async {
    try {
      final settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('Notification Permission: ${settings.authorizationStatus}');

      _token = await _messaging.getToken();

      print('FCM Token: $_token');

      _messaging.onTokenRefresh.listen((newToken) {
        _token = newToken;
        print('FCM Token Refreshed: $newToken');
      });
    } catch (e) {
      print('FCM Initialize Error: $e');
    }
  }

  static Future<String?> getToken() async {
    try {
      _token ??= await _messaging.getToken();
      return _token;
    } catch (e) {
      print('FCM Get Token Error: $e');
      return null;
    }
  }

  static Future<void> refreshToken() async {
    try {
      await _messaging.deleteToken();
      _token = await _messaging.getToken();
      print('New FCM Token: $_token');
    } catch (e) {
      print('FCM Refresh Error: $e');
    }
  }
}