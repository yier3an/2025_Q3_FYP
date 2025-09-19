import 'package:flutter/material.dart';
import '../mock_data.dart';
import '../theme.dart';
import '../widgets_paywall.dart';
import 'shared_header.dart';
import 'settings_page.dart';
import 'workout_edit_page.dart';
import 'analytics_detail_page.dart';

class WorkoutsTabPage extends StatefulWidget {
  final bool isPremium;
  const WorkoutsTabPage({super.key, this.isPremium = false});
  @override
  State<WorkoutsTabPage> createState() => _WorkoutsTabPageState();
}

class _WorkoutsTabPageState extends State<WorkoutsTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tc;

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 4, vsync: this)
      ..addListener(() => setState(() {})); // <= keeps chip highlight in sync
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SharedHeader(
        onSettings: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => const SettingsPage())),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _PillTabBar(controller: _tc, tabs: const [
            Tab(text: 'Workouts'),
            Tab(text: 'Your Analytics'),
            Tab(text: 'Logbook'),
            Tab(text: 'Fitness Trainer'),
          ]),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tc,
              children: [
                const _WorkoutsView(),
                AnalyticsView(isPremium: widget.isPremium),
                const _LogbookView(),
                const _TrainerView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;
  const _PillTabBar({required this.controller, required this.tabs, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(tabs.length, (i) {
          final active = controller.index == i;
          return GestureDetector(
            onTap: () => controller.animateTo(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: active ? Colors.black : AppTheme.purpleLight,
                borderRadius: BorderRadius.circular(22),
              ),
              child: DefaultTextStyle(
                style: TextStyle(color: active ? Colors.white : Colors.black),
                child: tabs[i],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AnalyticsView extends StatelessWidget {
  final bool isPremium;
  const AnalyticsView({super.key, required this.isPremium});

  @override
  Widget build(BuildContext context) {
    // The overlay paywall stays exactly as you had it.
    return Stack(
      children: [
        GridView.count(
          padding: const EdgeInsets.all(16),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _AnalyticsCard(
              title: 'Workouts',
              value: '5',
              unit: 'sessions',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnalyticsDetailPage(
                      title: 'Workouts',
                      unit: 'sessions',
                      data: [1, 0, 2, 0, 1, 1, 0],
                    ),
                  ),
                );
              },
            ),
            _AnalyticsCard(
              title: 'Distance',
              value: '12.5',
              unit: 'km',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnalyticsDetailPage(
                      title: 'Distance',
                      unit: 'km',
                      data: [2.0, 1.5, 0.0, 3.0, 4.0, 2.0, 0.0],
                    ),
                  ),
                );
              },
            ),
            _AnalyticsCard(
              title: 'Calories',
              value: '3200',
              unit: 'kcal',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnalyticsDetailPage(
                      title: 'Calories',
                      unit: 'kcal',
                      data: [500, 300, 0, 800, 900, 700, 0],
                    ),
                  ),
                );
              },
            ),
            _AnalyticsCard(
              title: 'Steps',
              value: '21k',
              unit: 'steps',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AnalyticsDetailPage(
                      title: 'Steps',
                      unit: 'steps',
                      data: [4000, 2500, 0, 6000, 7000, 1500, 0],
                    ),
                  ),
                );
              },
            ),
          ],
        ),

        if (!isPremium)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.70),
                child: const PremiumWall(
                  title: 'Premium Analytics',
                  message: 'Unlock performance graphs and advanced analytics',
                ),
              ),
            ),
          ),
      ],
    );
  }
}


class _WorkoutsView extends StatefulWidget {
  const _WorkoutsView();
  @override
  State<_WorkoutsView> createState() => _WorkoutsViewState();
}

class _WorkoutsViewState extends State<_WorkoutsView> {
  @override
  Widget build(BuildContext context) {
    final ex = MockData.exercises;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Row(
          children: [
            FilledButton.icon(
              onPressed: () {
                // mimic wearable sync: mutate some values
                if (ex.isNotEmpty) {
                  ex[0] = Exercise(ex[0].title, ex[0].totalText, 'Completed: 20', edited: true);
                }
                if (ex.length > 1) {
                  ex[1] = Exercise(ex[1].title, ex[1].totalText, 'Completed: 1.1 KM', edited: true);
                }
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Synced from wearable (mock)')),
                );
              },
              icon: const Icon(Icons.sync),
              label: const Text('Sync from wearable'),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () async {
                final changed = await Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const WorkoutEditPage()));
                if (changed == true) setState(() {});
              },
              icon: const Icon(Icons.add),
              label: const Text('New workout'),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Dismiss to delete + menu for Edit/Delete
        ...List.generate(ex.length, (i) {
          final e = ex[i];
          return Dismissible(
            key: ValueKey('ex_$i'),
            background: Container(
              color: Colors.red, alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => setState(() => ex.removeAt(i)),
            child: Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
                title: Text(
                  e.title,
                  style: TextStyle(fontWeight: e.edited ? FontWeight.bold : FontWeight.normal),
                ),
                subtitle: Text('${e.totalText}\n${e.completedText}'),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (v) async {
                    if (v == 'edit') {
                      final changed = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => WorkoutEditPage(index: i)),
                      );
                      if (changed == true) setState(() {});
                    } else if (v == 'delete') {
                      setState(() => ex.removeAt(i));
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ),
            ),
          );
        }),

        const SizedBox(height: 12),
        const Text('Tutorial Videos', style: TextStyle(fontWeight: FontWeight.bold)),
        const Card(child: ListTile(leading: Icon(Icons.play_circle_outline), title: Text('Proper Pushup Form'), trailing: Icon(Icons.chevron_right))),
        const Card(child: ListTile(leading: Icon(Icons.play_circle_outline), title: Text('Stretching Basics'), trailing: Icon(Icons.chevron_right))),
      ],
    );
  }
}

class _LogbookView extends StatelessWidget {
  const _LogbookView();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ListTile(title: Text('December 10 2025'), subtitle: Text('Day 13 of gym training\nPB: 100KG Bench 5 reps')),
        ListTile(title: Text('December 02 2025'), subtitle: Text('Day 5 of gym training\nPB: 90KG Bench 2 reps')),
      ],
    );
  }
}

class _TrainerView extends StatelessWidget {
  const _TrainerView();
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Trainer marketplace (placeholder)'));
  }
}

class _MetricCard extends StatelessWidget {
  final String title, value, subtitle;
  const _MetricCard({required this.title, required this.value, required this.subtitle, super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text(subtitle, style: const TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value; // headline number (e.g., "12.5")
  final String unit;  // displayed under value (e.g., "km")
  final VoidCallback onTap;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 0,
        color: AppTheme.purpleLight.withOpacity(0.45),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Text(
                value,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(unit, style: const TextStyle(color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}

