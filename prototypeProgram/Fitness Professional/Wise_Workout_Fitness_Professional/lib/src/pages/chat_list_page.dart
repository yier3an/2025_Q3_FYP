import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final chats = [
      {'name': 'Isabella Christensen', 'email': 'Isabella@gmail.com', 'last': '11 MAY 12:56'},
      {'name': 'Mathilde Andersen', 'email': 'Mathilde@gmail.com', 'last': '11 MAY 12:56'},
      {'name': 'Karla Sørensen', 'email': 'Karla@gmail.com', 'last': '11 MAY 10:35'},
      {'name': 'Ida Jørgensen', 'email': 'Ida@gmail.com', 'last': '9 MAY 17:38'},
      {'name': 'Albert Andersen', 'email': 'Albert@gmail.com', 'last': '21 July 12:56'},
    ];
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Chats', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: chats.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final c = chats[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text(c['name']![0])),
                    title: Text(c['email']!),
                    subtitle: Text(c['name']!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(c['last']!),
                        const SizedBox(width: 12),
                        OutlinedButton(
                          onPressed: () => Navigator.of(context).pushReplacementNamed('/chat', arguments: c),
                          child: const Text('Enter Chat'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(onPressed: () {}, child: const Text('End Chat')),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
