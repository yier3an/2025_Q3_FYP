import 'package:flutter/material.dart';
import '../services/auth_service_mock.dart';
import 'shared_header.dart';

class ProfileTabPage extends StatelessWidget {
  final AuthServiceMock auth;
  const ProfileTabPage({super.key, required this.auth});

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser!;
    return Scaffold(
      appBar: const SharedHeader(),
      body: ListView(
        padding: const EdgeInsets.all(12),
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
          const ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
          const ListTile(leading: Icon(Icons.workspace_premium), title: Text('Renew Plans')),
          const ListTile(leading: Icon(Icons.watch_outlined), title: Text('Sync Wearables')),
          const ListTile(leading: Icon(Icons.privacy_tip_outlined), title: Text('Terms & Privacy Policy')),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () => auth.signOut(),
          ),
        ],
      ),
    );
  }
}
