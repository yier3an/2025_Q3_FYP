class AuthServiceMock {
  // Single hardcoded account
  final String demoEmail = 'pro@wiseworkout.app';
  final String demoPassword = 'Password123!';
  String? _currentEmail;

  bool get isLoggedIn => _currentEmail != null;
  String get currentEmail => _currentEmail ?? '';

  bool login(String email, String password) {
    if (email.trim() == demoEmail && password == demoPassword) {
      _currentEmail = email.trim();
      return true;
    }
    return false;
  }

  void logout() => _currentEmail = null;
}
