import 'package:flutter/material.dart';
import '../auth/auth_service_mock.dart';

class SettingsPage extends StatefulWidget {
  final AuthServiceMock auth;
  const SettingsPage({super.key, required this.auth});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _name = TextEditingController(text: 'Megan Fox');
  final _email = TextEditingController(text: 'MeganF@gmail.com');
  final _password = TextEditingController(text: 'Password123!');
  String _profession = 'Personal Trainer';

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(controller: _name, decoration: const InputDecoration(labelText: 'Username')),
                      const SizedBox(height: 12),
                      TextField(controller: _email, decoration: const InputDecoration(labelText: 'Email Address')),
                      const SizedBox(height: 12),
                      TextField(controller: _password, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _profession,
                        items: const [
                          DropdownMenuItem(value: 'Personal Trainer', child: Text('Personal Trainer')),
                          DropdownMenuItem(value: 'Physiotherapist', child: Text('Physiotherapist')),
                          DropdownMenuItem(value: 'Coach', child: Text('Coach')),
                        ],
                        onChanged: (v) => setState(() => _profession = v ?? _profession),
                        decoration: const InputDecoration(labelText: 'Profession'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          FilledButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved (mock).'))), child: const Text('Edit')),
                          const SizedBox(width: 12),
                          TextButton(onPressed: () {}, child: const Text('Delete')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    Container(
                      width: 180,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: NetworkImage('https://picsum.photos/400/300'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Upload new profile picture'),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
