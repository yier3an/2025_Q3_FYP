
import 'package:flutter/material.dart';
import 'settings_page.dart';
import '../mock_data.dart';
import 'shared_header.dart';

class HomeTabPage extends StatelessWidget {
  const HomeTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    final posts = MockData.feed;
    return Scaffold(
      appBar: SharedHeader(
        onSettings: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: [
          _GoalsCard(goals: MockData.goals),
          const SizedBox(height: 12),
          ...posts.map((p) => Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)),
              title: Row(
                children: [
                  Text(p.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Text(p.timeAgo, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(p.text),
              ),
              isThreeLine: true,
              trailing: const Icon(Icons.more_horiz, size: 20),
            ),
          )),
        ],
      ),
    );
  }
}

class _GoalsCard extends StatelessWidget {
  final List<Goal> goals;
  const _GoalsCard({required this.goals});

  @override
  Widget build(BuildContext context) {
    TextSpan row(Goal g) => TextSpan(children: [
      TextSpan(text: '${g.title} ', style: const TextStyle(color: Colors.black)),
      TextSpan(text: g.bold, style: const TextStyle(fontWeight: FontWeight.bold)),
      TextSpan(text: ' ${g.trailing}'),
    ]);
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.black.withOpacity(0.8), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Your Goals For Today', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...goals.map((g) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: RichText(text: row(g)),
          )),
        ]),
      ),
    );
  }
}
