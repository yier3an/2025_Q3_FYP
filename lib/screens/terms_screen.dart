import 'package:flutter/material.dart';
import '../widgets/side_nav.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final controller = TextEditingController(text: '''
Wise Workout – Terms of Service (Draft)
1. Be kind. No harassment or hate speech.
2. Only upload content you own.
3. Admin may suspend accounts that violate rules.
4. This is a prototype; terms will change.
''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNav(currentRoute: '/tos'),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text('Terms of Service',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () {
                          // later: save to Firestore; for now just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Saved locally (prototype)')),
                          );
                        },
                        icon: const Icon(Icons.save_outlined),
                        label: const Text('Save'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: TextField(
                          controller: controller,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write your Terms of Service here...',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
