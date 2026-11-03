import '../models/app_user.dart';

abstract interface class AuthService {
  Stream<AppUser?> watchSession();
  Future<void> signInWithGoogle();
  Future<void> signOut();
}

class AuthFailure implements Exception {
  const AuthFailure(this.message);
  final String message;
}
