import '../models/app_user.dart';
import 'assignment_emulator.dart';
import 'auth_service.dart';

class EmulatorAuthService implements AuthService {
  final _auth = assignmentEmulatorAuth();

  @override
  Stream<AppUser?> watchSession() => _auth.authStateChanges().map(
    (user) => user == null
        ? null
        : AppUser(uid: user.uid, displayName: 'User thử nghiệm'),
  );

  @override
  Future<void> signInWithGoogle() async {
    await _auth.signInAnonymously();
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
