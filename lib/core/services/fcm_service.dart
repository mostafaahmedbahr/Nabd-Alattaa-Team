import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static String? token;

  static Future<void> initialize() async {
    if (kIsWeb) {
      // FCM on web requires a VAPID key + service worker setup.
      // The admin web app skips push notifications for now.
      return;
    }

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      String? apnsToken;

      for (int i = 0; i < 10; i++) {
        apnsToken = await _messaging.getAPNSToken();

        if (apnsToken != null) {
          break;
        }

        await Future.delayed(const Duration(seconds: 1));
      }

      print("APNS Token: $apnsToken");

      if (apnsToken == null) {
        print("APNS Token is still null");
        return;
      }
    }

    token = await _messaging.getToken();

    print("FCM Token: $token");
  }
}