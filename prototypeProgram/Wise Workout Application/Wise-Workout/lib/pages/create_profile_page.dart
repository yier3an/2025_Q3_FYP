import 'package:flutter/material.dart';
import '../services/auth_service_mock.dart';
import '../globals.dart';
import '../mock_data.dart';

class CreateProfilePage extends StatefulWidget {
  final bool editing; // true when opened from Settings
  const CreateProfilePage({super.key, this.editing = false});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final goals = const ['Weight Loss', 'Muscle Gain', 'Endurance', 'General Health'];
  int? selected;
  late final AppUser user;

  @override
  void initState() {
    super.initState();
    user = Globals.auth.currentUser!;
    final existing = Globals.auth.profileFor(user.id);
    if (existing != null) {
      selected = goals.indexOf(existing.goal);
    }
  }

  List<Exercise> _planFor(String goal) {
    switch (goal) {
      case 'Weight Loss':
        return [
          Exercise('Run', 'Total: 3 KM', 'Completed: 0 m'),
          Exercise('Jump Rope', 'Total: 10 min', 'Completed: 0 min'),
          Exercise('Pushups', 'Total: 3 sets of 10', 'Completed: 0 sets'),
        ];
      case 'Muscle Gain':
        return [
          Exercise('Pushups', 'Total: 5 sets of 12', 'Completed: 0 sets'),
          Exercise('Dumbbell Lateral Raises', 'Total: 4 sets of 12', 'Completed: 0 sets'),
          Exercise('Situps', 'Total: 4 sets of 15', 'Completed: 0 sets'),
        ];
      case 'Endurance':
        return [
          Exercise('Run', 'Total: 5 KM', 'Completed: 0 m'),
          Exercise('Rowing', 'Total: 15 min', 'Completed: 0 min'),
          Exercise('Burpees', 'Total: 3 sets of 12', 'Completed: 0 sets'),
        ];
      default: // General Health
        return [
          Exercise('Walk', 'Total: 5,000 steps', 'Completed: 0 steps'),
          Exercise('Pushups', 'Total: 3 sets of 10', 'Completed: 0 sets'),
          Exercise('Situps', 'Total: 3 sets of 12', 'Completed: 0 sets'),
        ];
    }
  }

  void _save() {
    if (selected == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please select a goal')));
    } else {
      final goal = goals[selected!];
      // 1) save profile
      Globals.auth.setProfile(user.id, UserProfile(goal: goal));
      // 2) generate + apply a plan into Workouts tab (mock in-memory)
      MockData.exercises
        ..clear()
        ..addAll(_planFor(goal));
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.editing ? 'Update Profile' : 'Create Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Text('Wise Workout', style: Theme.of(context).textTheme.headlineSmall)),
            const SizedBox(height: 24),
            Text('Hello ${user.displayName},', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            const Text('What are your primary fitness goals?'),
            const SizedBox(height: 16),
            ...List.generate(goals.length, (i) {
              final active = selected == i;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () => setState(() => selected = i),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: active ? Colors.black : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(goals[i], style: TextStyle(color: active ? Colors.white : Colors.black)),
                  ),
                ),
              );
            }),
            const Spacer(),
            Center(child: FilledButton(onPressed: _save, child: Text(widget.editing ? 'Save' : 'Continue'))),
          ],
        ),
      ),
    );
  }
}
