import 'package:flutter/material.dart';
import '../auth/auth_service_mock.dart';
import '../theme/app_theme.dart'; //
import 'side_nav.dart';

class Shell extends StatelessWidget {
  final Widget child;
  final AuthServiceMock auth;
  const Shell({super.key, required this.child, required this.auth});

  @override
  Widget build(BuildContext context) {
    if (!auth.isLoggedIn) {
      Future.microtask(() => Navigator.of(context).pushNamedAndRemoveUntil('/', (r) => false));
    }

    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Sidebar on the left
          SideNav(
            onNavigate: (route) => Navigator.of(context).pushNamed(route),
            onLogout: () {
              auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false);
            },
          ),
          // Content area with Admin gradient background
          Expanded(
            child: Container(
              decoration: AppTheme.dashboardGradient, // ✅ Admin gradient
              child: SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: child, // your pages (cards are white by theme)
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
