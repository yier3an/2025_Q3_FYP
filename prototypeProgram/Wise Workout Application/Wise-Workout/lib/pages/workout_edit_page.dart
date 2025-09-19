import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';

/// A modernized create/edit workout screen with:
/// - Quick templates (chips)
/// - Workout type chips (Reps / Distance / Time)
/// - Friendly number pickers instead of raw text where possible
/// - Live preview card
/// - Sticky bottom "Save" button
class WorkoutEditPage extends StatefulWidget {
  final int? index; // null => create
  const WorkoutEditPage({super.key, this.index});

  @override
  State<WorkoutEditPage> createState() => _WorkoutEditPageState();
}

enum WorkoutKind { reps, distance, time }

class _WorkoutEditPageState extends State<WorkoutEditPage> {
  final _templates = const [
    {'title': 'Push-ups', 'kind': 'reps', 'a': 3, 'b': 20}, // 3×20
    {'title': 'Run', 'kind': 'distance', 'a': 2, 'b': 400}, // 2.4 km
    {'title': 'Sit-ups', 'kind': 'reps', 'a': 3, 'b': 15},
    {'title': 'Dumbbell Lateral Raises', 'kind': 'reps', 'a': 3, 'b': 12},
  ];
  int _templateIndex = -1;

  late final TextEditingController _title;
  WorkoutKind _kind = WorkoutKind.reps;

  // For reps: a = sets, b = reps
  // For distance: a = kilometers, b = meters remainder
  // For time: a = minutes, b = seconds remainder
  int _a = 3;
  int _b = 10;

  // Optional notes
  final TextEditingController _notes = TextEditingController();

  bool get _isEdit => widget.index != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) {
      final ex = MockData.exercises[widget.index!];
      // Try to parse "Total:" strings back into structured controls
      // Fallback to reps if unknown.
      final title = ex.title;
      String total = ex.totalText.toLowerCase();
      _title = TextEditingController(text: title);

      if (total.contains('km')) {
        _kind = WorkoutKind.distance;
        // very naive parse: "Total: 2.4 km"
        final numPart = total.replaceAll(RegExp(r'[^0-9\.\s]'), '').trim();
        final km = double.tryParse(numPart.split(' ').first) ?? 2.4;
        _a = km.floor();
        _b = ((km - _a) * 1000).round();
      } else if (total.contains('set')) {
        _kind = WorkoutKind.reps;
        // e.g. "Total: 3 sets of 10"
        final m = RegExp(r'(\d+)\s*set.*?(\d+)').firstMatch(total);
        _a = int.tryParse(m?.group(1) ?? '3') ?? 3;
        _b = int.tryParse(m?.group(2) ?? '10') ?? 10;
      } else if (total.contains('min') || total.contains('sec')) {
        _kind = WorkoutKind.time;
        final min = RegExp(r'(\d+)\s*min').firstMatch(total)?.group(1);
        final sec = RegExp(r'(\d+)\s*sec').firstMatch(total)?.group(1);
        _a = int.tryParse(min ?? '10') ?? 10;
        _b = int.tryParse(sec ?? '0') ?? 0;
      } else {
        _kind = WorkoutKind.reps;
        _a = 3;
        _b = 10;
      }
    } else {
      _title = TextEditingController();
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  void _applyTemplate(int i) {
    setState(() {
      _templateIndex = i;
      final t = _templates[i];
      _title.text = t['title'] as String;
      final kind = (t['kind'] as String);
      switch (kind) {
        case 'distance':
          _kind = WorkoutKind.distance;
          _a = (t['a'] as int);
          _b = (t['b'] as int);
          break;
        case 'time':
          _kind = WorkoutKind.time;
          _a = (t['a'] as int);
          _b = (t['b'] as int);
          break;
        default:
          _kind = WorkoutKind.reps;
          _a = (t['a'] as int);
          _b = (t['b'] as int);
      }
    });
  }

  String _formatTotal() {
    switch (_kind) {
      case WorkoutKind.reps:
      // sets x reps
        return 'Total: $_a sets of $_b';
      case WorkoutKind.distance:
        final totalMeters = _a * 1000 + _b;
        final km = totalMeters / 1000.0;
        return 'Total: ${km.toStringAsFixed(1)} KM';
      case WorkoutKind.time:
        final minutes = _a;
        final seconds = _b;
        return 'Total: ${minutes} min ${seconds} sec';
    }
  }

  String _formatCompleted() {
    // new workouts default to zero completed
    switch (_kind) {
      case WorkoutKind.reps:
        return 'Completed: 0 sets';
      case WorkoutKind.distance:
        return 'Completed: 0 m';
      case WorkoutKind.time:
        return 'Completed: 0 sec';
    }
  }

  void _save() {
    final title = _title.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workout title')),
      );
      return;
    }
    final ex = Exercise(title, _formatTotal(), _formatCompleted(), edited: true);
    MockData.upsertExercise(index: widget.index, ex: ex);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = _isEdit;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Workout' : 'Create Workout'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Quick templates',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_templates.length, (i) {
                      final t = _templates[i];
                      final selected = _templateIndex == i;
                      return ChoiceChip(
                        selected: selected,
                        label: Text(t['title'] as String),
                        onSelected: (_) => _applyTemplate(i),
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        selectedColor: AppTheme.purple,
                        backgroundColor: AppTheme.purpleLight,
                        shape: const StadiumBorder(),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                    color: AppTheme.purpleLight.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _title,
                            decoration: const InputDecoration(
                              labelText: 'Workout name',
                              hintText: 'e.g., Push-ups, 5K Run',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Type', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              _kindChip('Reps', WorkoutKind.reps),
                              _kindChip('Distance', WorkoutKind.distance),
                              _kindChip('Time', WorkoutKind.time),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _kindInputs(),
                          const SizedBox(height: 14),
                          TextField(
                            controller: _notes,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Notes (optional)',
                              hintText: 'Add cues, form reminders, etc.',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Preview', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  _previewCard(),
                  const SizedBox(height: 80), // space for sticky button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: const StadiumBorder(),
            ),
            child: Text(isEdit ? 'Save changes' : 'Create workout'),
          ),
        ),
      ),
    );
  }

  Widget _kindChip(String label, WorkoutKind k) {
    final selected = _kind == k;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _kind = k),
      selectedColor: AppTheme.purple,
      backgroundColor: AppTheme.purpleLight,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: FontWeight.w600,
      ),
      shape: const StadiumBorder(),
    );
  }

  Widget _kindInputs() {
    switch (_kind) {
      case WorkoutKind.reps:
        return Row(
          children: [
            Expanded(child: _numberField('Sets', _a, (v) => setState(() => _a = v), min: 1, max: 20)),
            const SizedBox(width: 10),
            Expanded(child: _numberField('Reps', _b, (v) => setState(() => _b = v), min: 1, max: 100)),
          ],
        );
      case WorkoutKind.distance:
        return Row(
          children: [
            Expanded(child: _numberField('Km', _a, (v) => setState(() => _a = v), min: 0, max: 100)),
            const SizedBox(width: 10),
            Expanded(child: _numberField('Meters', _b, (v) => setState(() => _b = v), step: 50, min: 0, max: 950)),
          ],
        );
      case WorkoutKind.time:
        return Row(
          children: [
            Expanded(child: _numberField('Minutes', _a, (v) => setState(() => _a = v), min: 0, max: 240)),
            const SizedBox(width: 10),
            Expanded(child: _numberField('Seconds', _b, (v) => setState(() => _b = v), step: 5, min: 0, max: 55)),
          ],
        );
    }
  }

  Widget _numberField(String label, int value, ValueChanged<int> onChanged,
      {int min = 0, int max = 100, int step = 1}) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: value > min ? () => onChanged(value - step) : null,
            icon: const Icon(Icons.remove),
            tooltip: 'Decrease',
          ),
          Expanded(
            child: Center(
              child: Text(
                '$value',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + step) : null,
            icon: const Icon(Icons.add),
            tooltip: 'Increase',
          ),
        ],
      ),
    );
  }

  Widget _previewCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: AppTheme.purpleLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_kind == WorkoutKind.reps
                  ? Icons.fitness_center
                  : _kind == WorkoutKind.distance
                  ? Icons.directions_run
                  : Icons.timer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_title.text.isEmpty ? 'Workout title' : _title.text,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(_formatTotal()),
                  const SizedBox(height: 2),
                  Text(_formatCompleted(), style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
