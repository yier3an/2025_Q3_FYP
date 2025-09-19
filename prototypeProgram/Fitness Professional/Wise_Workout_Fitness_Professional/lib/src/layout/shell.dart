import 'package:flutter/material.dart';
import '../auth/auth_service_mock.dart';
import 'side_nav.dart';

class Shell extends StatelessWidget {
  final Widget child;
  final AuthServiceMock auth;
  const Shell({super.key, required this.child, required this.auth});

  @override
  Widget build(BuildContext context) {
    if (!auth.isLoggedIn) {
      // If user is not logged in, go back to login screen
      Future.microtask(() => Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false));
    }

    return Scaffold(
      body: Row(
        children: [
          SideNav(
            onNavigate: (route) => Navigator.of(context).pushReplacementNamed(route),
            onLogout: () {
              auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
            },
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B00E3), Color(0xFF8A2BE2)],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
