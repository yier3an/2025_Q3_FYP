
import 'package:flutter/material.dart';
import 'plan_page.dart';
import '../services/auth_service_mock.dart';
import 'shared_header.dart';
import '../app/di.dart';
import 'settings_page.dart';

class ProfileTabPage extends StatelessWidget {
  final AuthServiceMock auth;
  final DI di;

  const ProfileTabPage({super.key, required this.auth, required this.di});

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser!;
    return Scaffold(
      appBar: SharedHeader(onSettings: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))),
      body: ListView(
        children: [
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                const CircleAvatar(radius: 44, child: Icon(Icons.person, size: 44)),
                const SizedBox(height: 8),
                Text(user.displayName, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(user.tier, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()))),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Renew / Manage Plan'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanPage())),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.phonelink_lock_outlined),
            title: const Text('Two-Factor Authentication'),
            value: true,
            onChanged: (v) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('2FA toggled (mock)'))),
          ),
          ListTile(
            leading: const Icon(Icons.link_outlined),
            title: const Text('Link Social Account'),
            onTap: () => showDialog(context: context, builder: (_) => const AlertDialog(title: Text('Link account'), content: Text('Linked to @irfaan (mock).'))),
          ),
          ListTile(
            leading: const Icon(Icons.watch_outlined),
            title: const Text('Pair Wearable Device'),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Paired with DemoWatch (mock)'))),
          ),
          const ListTile(leading: Icon(Icons.privacy_tip_outlined), title: Text('Terms & Privacy Policy')),
          ListTile(leading: const Icon(Icons.logout, color: Colors.red), title: const Text('Log Out', style: TextStyle(color: Colors.red)), onTap: () => di.authUseCase.logOut()),
        ],
      ),
    );
  }
}
