import 'package:flutter/material.dart';
import '../mock_data.dart';
import 'shared_header.dart';

class WorkoutsTabPage extends StatefulWidget {
  const WorkoutsTabPage({super.key});
  @override
  State<WorkoutsTabPage> createState() => _WorkoutsTabPageState();
}

class _WorkoutsTabPageState extends State<WorkoutsTabPage> with SingleTickerProviderStateMixin {
  late final TabController _tc;

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 4, vsync: this);
    _tc.addListener(() => setState((){})); // to refresh FAB visibility
  }

  @override
  void dispose() {
    _tc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWorkoutsTab = _tc.index == 0;
    return Scaffold(
      appBar: const SharedHeader(),
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
              children: const [
                _WorkoutsListView(),
                _AnalyticsTiles(),
                _LogbookView(),
                Center(child: Text('Fitness Trainer — U/C')),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isWorkoutsTab
          ? FloatingActionButton.extended(
          onPressed: () {}, icon: const Icon(Icons.add), label: const Text('New workout'))
          : null,
    );
  }
}

class _PillTabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;
  const _PillTabBar({required this.controller, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(999),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        indicator: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(999),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black87,
        dividerColor: Colors.transparent,
      ),
    );
  }
}

class _WorkoutsListView extends StatelessWidget {
  const _WorkoutsListView();

  @override
  Widget build(BuildContext context) {
    final ongoing = MockData.ongoing;
    final done = MockData.completed;

    Widget sectionTitle(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
      child: Row(
        children: [
          Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          const Icon(Icons.sync, size: 18),
        ],
      ),
    );

    Widget row(Exercise e, {bool showSync=false}) => ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      leading: const CircleAvatar(child: Icon(Icons.image)), // placeholder for exercise art
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('System', style: TextStyle(color: Colors.grey, fontSize: 12)),
        Text(e.title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ]),
      subtitle: Text('${e.totalText}\n${e.completedText}'),
      isThreeLine: true,
      trailing: showSync ? OutlinedButton(onPressed: (){}, child: const Text('Sync')) : IconButton(icon: const Icon(Icons.edit), onPressed: (){}),
    );

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: FilledButton(
            style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 44)),
            onPressed: () {}, child: const Text('Your Goals For Today'),
          ),
        ),
        sectionTitle('On-going'),
        ...ongoing.map((e) => row(e, showSync: e.title == 'Run')),
        const Divider(),
        sectionTitle('Completed'),
        ...done.map(row),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _AnalyticsTiles extends StatelessWidget {
  const _AnalyticsTiles();
  @override
  Widget build(BuildContext context) {
    Widget tile(String title, String value, IconData icon, {String? sub}) {
      return Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(title),
              if (sub != null) ...[
                const SizedBox(height: 6),
                Text(sub, style: const TextStyle(color: Colors.green)),
              ]
            ],
          ),
        ),
      );
    }

    return GridView.count(
      padding: const EdgeInsets.all(8),
      crossAxisCount: 2,
      childAspectRatio: 1.2,
      children: [
        tile('Calories Burned', '512k', Icons.local_fire_department),
        tile('KM ran', '2M', Icons.directions_run, sub: '+8% of target'),
        tile('Pushups Completed', '2900', Icons.fitness_center, sub: '+5% last 7 days'),
        tile('Activity recorded', '1.2%', Icons.bar_chart, sub: '+5% of target'),
        tile('Streaks', '20 days', Icons.emoji_events_outlined),
        tile('Followers count', '855', Icons.people_alt_outlined),
        tile('Latest Achievement', '100 pushups in a row', Icons.military_tech),
      ],
    );
  }
}

class _LogbookView extends StatelessWidget {
  const _LogbookView();
  @override
  Widget build(BuildContext context) {
    final days = List.generate(31, (i) => i + 1);
    final highlights = {2, 5, 7, 11, 12, 16, 22, 27};

    return ListView(
      children: [
        const SizedBox(height: 8),
        Center(child: Text('December 2025', style: Theme.of(context).textTheme.titleMedium)),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 8, runSpacing: 8,
            children: days.map((d) {
              final active = highlights.contains(d);
              return Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: active ? Colors.black : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text('$d', style: TextStyle(color: active ? Colors.white : Colors.black)),
              );
            }).toList(),
          ),
        ),
        const Divider(height: 24),
        _log('December 10 2025', 'Day 13 of gym training', 'PB: 100KG Bench 5 reps'),
        _log('December 02 2025', 'Day 5 of gym training', 'PB: 90KG Bench 2 reps'),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _log(String date, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Card(
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.image)),
          title: Text(title),
          subtitle: Text('$date\n$subtitle'),
          isThreeLine: true,
          trailing: const Icon(Icons.edit_outlined),
        ),
      ),
    );
  }
}
