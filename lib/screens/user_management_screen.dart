import 'package:flutter/material.dart';
import 'package:wise_workout_admin/widgets/side_nav.dart';
import 'package:wise_workout_admin/widgets/user_table.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNav(currentRoute: '/users'),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight, end: Alignment.bottomLeft,
                  colors: [Color(0xFF7A3EF2), Color(0xFF3F0FFF)],
                ),
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin: const EdgeInsets.all(22),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text('Admin Dashboard',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const Spacer(),
                          FilledButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Expanded(child: UserTable()),
                    ],
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
