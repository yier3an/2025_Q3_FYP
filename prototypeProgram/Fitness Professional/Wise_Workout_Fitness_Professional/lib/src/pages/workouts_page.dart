import 'package:flutter/material.dart';
import '../widgets/workout_card.dart';

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});
  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  final List<Map<String, String>> _workouts = [
    {
      'title': 'Push-ups',
      'desc': 'A calisthenic exercise for upper body strength. Keep back straight and core engaged.',
      'created': '11 MAY 12:56',
    },
    {
      'title': 'Sit-ups',
      'desc': 'Abdominal exercise performed while lying on your back. Control the movement.',
      'created': '11 MAY 10:35',
    },
  ];

  void _createOrEdit({int? index}) async {
    final titleCtrl = TextEditingController(text: index != null ? _workouts[index]['title'] : '');
    final descCtrl = TextEditingController(text: index != null ? _workouts[index]['desc'] : '');
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(index == null ? 'Create Workout' : 'Edit Workout'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description'), maxLines: 4),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, {'title': titleCtrl.text, 'desc': descCtrl.text}), child: const Text('Save')),
        ],
      ),
    );
    if (result != null) {
      setState(() {
        if (index == null) {
          _workouts.add({'title': result['title']!, 'desc': result['desc']!, 'created': DateTime.now().toString()});
        } else {
          _workouts[index]['title'] = result['title']!;
          _workouts[index]['desc'] = result['desc']!;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Your Workouts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                ),
                FilledButton.icon(onPressed: () => _createOrEdit(), icon: const Icon(Icons.add), label: const Text('Create')),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: _workouts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final item = _workouts[i];
                  return WorkoutCard(
                    title: item['title']!,
                    description: item['desc']!,
                    createdLabel: item['created'] ?? '',
                    onDelete: () => setState(() => _workouts.removeAt(i)),
                    onEdit: () => _createOrEdit(index: i),
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
