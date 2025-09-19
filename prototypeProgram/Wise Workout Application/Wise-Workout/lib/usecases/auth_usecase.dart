
import '../services/auth_service_mock.dart';

class AuthUseCase {
  final AuthServiceMock _auth;
  AuthUseCase(this._auth);

  Future<void> logIn({required String email, required String password}) {
    return _auth.signIn(email: email, password: password);
  }

  void logOut() => _auth.signOut();
}
