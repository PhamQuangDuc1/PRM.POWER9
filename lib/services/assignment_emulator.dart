import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

const assignmentEmulatorEnabled =
    kDebugMode &&
    bool.fromEnvironment('POWER9_ASSIGNMENT') &&
    bool.fromEnvironment('POWER9_USE_EMULATORS');

const _appName = 'power9-assignment';

FirebaseAuth assignmentEmulatorAuth() =>
    FirebaseAuth.instanceFor(app: Firebase.app(_appName));

FirebaseFirestore assignmentEmulatorFirestore() =>
    FirebaseFirestore.instanceFor(app: Firebase.app(_appName));

Future<void>? _initializing;

Future<void> initializeAssignmentEmulator() => _initializing ??= _initialize();

Future<void> _initialize() async {
  try {
    if (!Firebase.apps.any((app) => app.name == _appName)) {
      await Firebase.initializeApp(
        name: _appName,
        options: const FirebaseOptions(
          apiKey: 'demo-api-key',
          appId: '1:123456789:android:0000000000000000',
          messagingSenderId: '123456789',
          projectId: 'demo-power9',
        ),
      );
    }
    // ADB reverse forwards these loopback ports to the host.
    await assignmentEmulatorAuth().useAuthEmulator(
      '127.0.0.1',
      9099,
      automaticHostMapping: false,
    );
    assignmentEmulatorFirestore().useFirestoreEmulator(
      '127.0.0.1',
      8080,
      automaticHostMapping: false,
    );
  } catch (_) {
    _initializing = null;
    rethrow;
  }
}
