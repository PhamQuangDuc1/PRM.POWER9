import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_notification_service.dart';

class FirebaseBootstrap {
  static bool _backgroundRegistered = false;
  Future<void> initialize() async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    if (!_backgroundRegistered) {
      FirebaseMessaging.onBackgroundMessage(power9BackgroundMessage);
      _backgroundRegistered = true;
    }
  }
}
