import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';

import '../firebase_options.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_notification_service.dart';
import 'assignment_emulator.dart';

class FirebaseBootstrap {
  static bool _backgroundRegistered = false;
  static bool _appCheckActivated = false;
  Future<void> initialize() async {
    if (assignmentEmulatorEnabled) return initializeAssignmentEmulator();
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    if (!_appCheckActivated &&
        const bool.fromEnvironment('POWER9_ASSIGNMENT')) {
      await FirebaseAppCheck.instance.activate(
        providerAndroid:
            kDebugMode && const bool.fromEnvironment('POWER9_APP_CHECK_DEBUG')
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
      );
      _appCheckActivated = true;
    }
    if (!_backgroundRegistered) {
      FirebaseMessaging.onBackgroundMessage(power9BackgroundMessage);
      _backgroundRegistered = true;
    }
  }
}
