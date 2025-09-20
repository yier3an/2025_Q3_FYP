import 'package:flutter/material.dart';
import '../auth/auth_service_mock.dart';
<<<<<<< HEAD
import '../theme/app_theme.dart'; //
=======
>>>>>>> origin/main
import 'side_nav.dart';

class Shell extends StatelessWidget {
  final Widget child;
  final AuthServiceMock auth;
  const Shell({super.key, required this.child, required this.auth});

  @override
  Widget build(BuildContext context) {
    if (!auth.isLoggedIn) {
<<<<<<< HEAD
=======
      // If user is not logged in, go back to login screen
>>>>>>> origin/main
      Future.microtask(() => Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false));
    }

    return Scaffold(
      body: Row(
<<<<<<< HEAD
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar on the left
          SideNav(
            onNavigate: (route) => Navigator.of(context).pushNamed(route),
=======
        children: [
          SideNav(
            onNavigate: (route) => Navigator.of(context).pushReplacementNamed(route),
>>>>>>> origin/main
            onLogout: () {
              auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
            },
          ),
<<<<<<< HEAD
          // Content area with Admin gradient background
          Expanded(
            child: Container(
              decoration: AppTheme.dashboardGradient, // ✅ Admin gradient
=======
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF5B00E3), Color(0xFF8A2BE2)],
                ),
              ),
>>>>>>> origin/main
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
<<<<<<< HEAD
                      child: child, // your pages (cards are white by theme)
=======
                      child: child,
>>>>>>> origin/main
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
