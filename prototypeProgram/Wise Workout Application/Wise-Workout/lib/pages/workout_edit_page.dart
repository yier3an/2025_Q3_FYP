import 'package:flutter/material.dart';
import '../mock_data.dart';

class WorkoutEditPage extends StatefulWidget {
  final int? index; // null => create
  const WorkoutEditPage({super.key, this.index});

  @override
  State<WorkoutEditPage> createState() => _WorkoutEditPageState();
}

class _WorkoutEditPageState extends State<WorkoutEditPage> {
  final _templates = const [
    {'title':'Pushups','total':'Total: 60','completed':'Completed: 0'},
    {'title':'Run','total':'Total: 2.4 KM','completed':'Completed: 0 m'},
    {'title':'Situps','total':'Total: 3 sets of 10','completed':'Completed: 0 sets'},
    {'title':'Dumbbell Lateral Raises','total':'Total: 3 sets of 10','completed':'Completed: 0 sets'},
  ];
  int _templateIndex = -1;

  late final TextEditingController title;
  late final TextEditingController total;
  late final TextEditingController completed;

  @override
  void initState() {
    super.initState();
    final ex = (widget.index != null) ? MockData.exercises[widget.index!] : null;
    title = TextEditingController(text: ex?.title ?? '');
    total = TextEditingController(text: ex?.totalText ?? '');
    completed = TextEditingController(text: ex?.completedText ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.index != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Workout' : 'New Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(labelText: 'Template'),
              value: _templateIndex >= 0 ? _templateIndex : null,
              items: List.generate(
                _templates.length,
                    (i) => DropdownMenuItem(value: i, child: Text(_templates[i]['title'] as String)),
              ),
              onChanged: (i) {
                setState(() {
                  _templateIndex = i ?? -1;
                  if (i != null) {
                    title.text = _templates[i]['title'] as String;
                    total.text = _templates[i]['total'] as String;
                    completed.text = _templates[i]['completed'] as String;
                  }
                });
              },
            ),
            const SizedBox(height: 8),
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: total, decoration: const InputDecoration(labelText: 'Total text')),
            TextField(controller: completed, decoration: const InputDecoration(labelText: 'Completed text')),
            const Spacer(),
            FilledButton(
              onPressed: () {
                MockData.upsertExercise(
                  index: widget.index,
                  ex: Exercise(title.text.trim(), total.text.trim(), completed.text.trim(), edited: true),
                );
                Navigator.pop(context, true);
              },
              child: Text(isEdit ? 'Save' : 'Create'),
            )
          ],
        ),
      ),
    );
  }
}
