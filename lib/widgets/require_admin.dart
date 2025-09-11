import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wise_workout_admin/services/auth_service.dart';
import 'package:wise_workout_admin/screens/login_screen.dart';

/// Shows [child] only if the user is signed in AND has `admin: true` claim.
class RequireAdmin extends StatelessWidget {
  const RequireAdmin({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().authChanges,
      builder: (context, snap) {
        final user = snap.data;
        if (snap.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (user == null) return const LoginScreen();

        return FutureBuilder<bool>(
          future: AuthService().isAdmin(),              // calls getIdTokenResult(true)
          builder: (context, s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (s.data == true) return child;           // allowed
            return Scaffold(                             // not authorized UI
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Not authorized'),
                    FilledButton(
                      onPressed: () async { await AuthService().signOut(); },
                      child: const Text('Sign out'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
