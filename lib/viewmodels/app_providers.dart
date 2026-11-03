import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_bootstrap.dart';
import 'observability_providers.dart';

final bootstrapServiceProvider = Provider((ref) => FirebaseBootstrap());
final bootstrapProvider = FutureProvider<void>((ref) async {
  await ref.read(bootstrapServiceProvider).initialize();
  await ref.read(telemetryProvider).initialize();
  unawaited(ref.read(appConfigProvider.notifier).refresh());
});
final authServiceProvider = Provider<AuthService>(
  (ref) => FirebaseAuthService(telemetry: ref.read(telemetryProvider)),
);
final sessionProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authServiceProvider).watchSession().asyncMap((user) async {
    await ref.read(telemetryProvider).identify(user?.uid);
    return user;
  }),
);
