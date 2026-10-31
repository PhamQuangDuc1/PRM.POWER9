import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/app_user.dart';
import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  FirebaseAuthService({FirebaseAuth? auth, GoogleSignIn? google})
    : _auth = auth ?? FirebaseAuth.instance,
      _google = google ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _google;
  Future<void>? _googleReady;

  Future<void> _initializeGoogle() async {
    try {
      await (_googleReady ??= _google.initialize());
    } catch (_) {
      _googleReady = null;
      rethrow;
    }
  }

  @override
  Stream<AppUser?> watchSession() => _auth.authStateChanges().map(
    (user) => user == null
        ? null
        : AppUser(
            uid: user.uid,
            displayName: user.displayName,
            email: user.email,
          ),
  );

  @override
  Future<void> signInWithGoogle() async {
    try {
      await _initializeGoogle();
      final account = await _google.authenticate();
      final token = account.authentication.idToken;
      if (token == null) {
        throw const AuthFailure(
          'Chưa thể xác nhận tài khoản Google. Vui lòng thử lại.',
        );
      }
      await _auth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: token),
      );
    } on GoogleSignInException catch (error) {
      throw AuthFailure(
        error.code == GoogleSignInExceptionCode.canceled
            ? 'Bạn đã hủy đăng nhập. Có thể thử lại khi sẵn sàng.'
            : 'Chưa thể kết nối đăng nhập Google. Vui lòng thử lại sau.',
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure(switch (error.code) {
        'network-request-failed' =>
          'Không có kết nối mạng. Vui lòng kiểm tra rồi thử lại.',
        'too-many-requests' =>
          'Bạn đã thử nhiều lần. Vui lòng chờ một chút rồi thử lại.',
        'user-disabled' => 'Tài khoản này đã bị vô hiệu hóa.',
        _ => 'Chưa thể đăng nhập. Vui lòng thử lại sau.',
      });
    }
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
    try {
      await _initializeGoogle();
      await _google.signOut();
    } catch (_) {
      // Firebase is already signed out; Google cleanup must not retain app access.
    }
  }
}
