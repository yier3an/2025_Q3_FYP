import 'package:flutter/material.dart';

class AppUser {
  final String id;
  final String email;
  final String password; // mock only
  final String displayName;
  final String tier; // "Free User" | "Premium User"
  const AppUser({
    required this.id,
    required this.email,
    required this.password,
    required this.displayName,
    this.tier = 'Free User',
  });

  AppUser copyWith({String? tier}) => AppUser(
    id: id,
    email: email,
    password: password,
    displayName: displayName,
    tier: tier ?? this.tier,
  );
}

class UserProfile {
  final String goal; // 'Weight Loss' | 'Muscle Gain' | 'Endurance' | 'General Health'
  const UserProfile({required this.goal});
}


class AuthServiceMock extends ChangeNotifier {
  final List<AppUser> _accounts;
  final Map<String, UserProfile> _profiles = {};
  AppUser? _current;

  UserProfile? profileFor(String userId) => _profiles[userId];

  void setProfile(String userId, UserProfile p) {
    _profiles[userId] = p;
    notifyListeners();
  }

  AuthServiceMock(this._accounts);

  bool get isLoggedIn => _current != null;
  AppUser? get currentUser => _current;
  bool get isPremium => _current?.tier.contains('Premium') == true;

  Future<void> signIn({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final u = _accounts.firstWhere(
          (a) => a.email.toLowerCase() == email.toLowerCase() && a.password == password,
      orElse: () => throw Exception('Invalid email or password'),
    );
    _current = u;
    notifyListeners();
  }

  void upgradeToPremium() {
    if (_current == null) return;
    _current = _current!.copyWith(tier: 'Premium User');
    notifyListeners();
  }

  void downgradeToFree() {
    if (_current == null) return;
    _current = _current!.copyWith(tier: 'Free User');
    notifyListeners();
  }

  void signOut() {
    _current = null;
    notifyListeners();
  }
}
