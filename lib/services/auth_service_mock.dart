import 'package:flutter/material.dart';

class AppUser {
  final String id;
  final String email;
  final String password; // mock only
  final String displayName;
  final String tier; // "Free User" | "Premium User"
  AppUser({
    required this.id,
    required this.email,
    required this.password,
    required this.displayName,
    this.tier = 'Free User',
  });
}

class AuthServiceMock extends ChangeNotifier {
  final List<AppUser> _accounts;
  AppUser? _current;

  AuthServiceMock(this._accounts);

  AppUser? get currentUser => _current;
  bool get isLoggedIn => _current != null;

  Future<void> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final u = _accounts.firstWhere(
          (a) => a.email.toLowerCase() == email.toLowerCase() && a.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    _current = u;
    notifyListeners();
  }

  void signOut() {
    _current = null;
    notifyListeners();
  }
}
