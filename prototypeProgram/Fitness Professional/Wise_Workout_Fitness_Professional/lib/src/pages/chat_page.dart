import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> _messages = [
    {'fromMe': false, 'text': 'Hi!', 'ts': 'Nov 28, 2023, 12:01 AM'},
    {'fromMe': true, 'text': 'This is the main chat template.', 'ts': 'Nov 28, 2023, 12:02 AM'},
    {'fromMe': false, 'text': 'How does it work?', 'ts': 'Nov 28, 2023, 12:03 AM'},
    {'fromMe': true, 'text': 'Type in the message and press send.', 'ts': 'Nov 28, 2023, 12:04 AM'},
  ];

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Text('Chat', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                TextButton.icon(onPressed: () => Navigator.of(context).pushReplacementNamed('/chats'), icon: const Icon(Icons.chevron_left), label: const Text('Back')),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (ctx, i) {
                final m = _messages[i];
                final align = m['fromMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start;
                final bubbleColor = m['fromMe'] ? Colors.black : Colors.white;
                final textColor = m['fromMe'] ? Colors.white : Colors.black87;
                return Column(
                  crossAxisAlignment: align,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      decoration: BoxDecoration(
                        color: bubbleColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(m['text'], style: TextStyle(color: textColor)),
                    ),
                    Text(m['ts'], style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller, decoration: const InputDecoration(hintText: 'Message...'))),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    if (_controller.text.trim().isEmpty) return;
                    setState(() {
                      _messages.add({'fromMe': true, 'text': _controller.text.trim(), 'ts': DateTime.now().toString()});
                    });
                    _controller.clear();
                  },
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
