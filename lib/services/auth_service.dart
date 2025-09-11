import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() => _auth.signOut();

  /// Reads the ID token claims. We’ll set `admin: true` via the Admin SDK (step 4).
  Future<bool> isAdmin() async {
    final u = _auth.currentUser;
    if (u == null) return false;
    final token = await u.getIdTokenResult(true);
    return token.claims?['admin'] == true;
  }
}
