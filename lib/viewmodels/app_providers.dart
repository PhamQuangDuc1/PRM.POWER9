import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/firebase_auth_service.dart';
import '../services/firebase_bootstrap.dart';

final bootstrapServiceProvider = Provider((ref) => FirebaseBootstrap());
final bootstrapProvider = FutureProvider<void>(
  (ref) => ref.read(bootstrapServiceProvider).initialize(),
);
final authServiceProvider = Provider<AuthService>(
  (ref) => FirebaseAuthService(),
);
final sessionProvider = StreamProvider<AppUser?>(
  (ref) => ref.watch(authServiceProvider).watchSession(),
);
