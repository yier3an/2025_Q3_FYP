
import 'package:flutter/material.dart';
import 'plan_page.dart';
import 'create_profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Update Profile / Goals'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateProfilePage(editing: true)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.workspace_premium),
            title: const Text('Manage / Renew Plan'),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PlanPage())),
          ),
          const Divider(),
          const ListTile(leading: Icon(Icons.notifications_none), title: Text('Notifications')),
          const ListTile(leading: Icon(Icons.privacy_tip_outlined), title: Text('Privacy & Terms')),
          const ListTile(leading: Icon(Icons.help_outline), title: Text('Help & Support')),
        ],
      ),
    );
  }
}
