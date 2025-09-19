import 'package:flutter/material.dart';
import 'shared_header.dart';
import '../widgets_paywall.dart';
import 'settings_page.dart';

class CommunityTabPage extends StatefulWidget {
  final bool isPremium;
  const CommunityTabPage({super.key, this.isPremium = false});
  @override
  State<CommunityTabPage> createState() => _CommunityTabPageState();
}

class _CommunityTabPageState extends State<CommunityTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tc;
  final Set<int> _joinedGroupIds = {};
  final Set<int> _joinedTournamentIds = {};

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 3, vsync: this)..addListener(() => setState(() {}));
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
          TabBar(
            controller: _tc,
            tabs: const [
              Tab(text: 'Active'),
              Tab(text: 'Tournaments'),
              Tab(text: 'Groups'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            indicator: BoxDecoration(
                color: Colors.black, borderRadius: BorderRadius.circular(22)),
            indicatorSize: TabBarIndicatorSize.tab,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tc,
              children: [
                _ActiveView(
                  joinedGroups: _joinedGroupIds,
                  joinedTournaments: _joinedTournamentIds,
                ),
                _TournamentsView(
                  joined: _joinedTournamentIds,
                  onToggle: (id) {
                    setState(() {
                      if (!_joinedTournamentIds.remove(id)) _joinedTournamentIds.add(id);
                    });
                  },
                ),
                _GroupsView(
                  isPremium: widget.isPremium,
                  joined: _joinedGroupIds,
                  onToggle: (id) {
                    setState(() {
                      if (!_joinedGroupIds.remove(id)) _joinedGroupIds.add(id);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveView extends StatelessWidget {
  final Set<int> joinedGroups;
  final Set<int> joinedTournaments;
  const _ActiveView({required this.joinedGroups, required this.joinedTournaments});

  @override
  Widget build(BuildContext context) {
    final t = joinedTournaments.toList()..sort();
    final g = joinedGroups.toList()..sort();
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Active Tournaments', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        if (t.isEmpty) const ListTile(title: Text('None joined yet')),
        for (final id in t)
          Card(child: ListTile(leading: const Icon(Icons.emoji_events_outlined), title: Text('Tournament #$id'))),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text('Active Groups', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        if (g.isEmpty) const ListTile(title: Text('None joined yet')),
        for (final id in g)
          Card(child: ListTile(leading: const Icon(Icons.group_outlined), title: Text('Group #$id'))),
      ],
    );
  }
}

class _TournamentsView extends StatelessWidget {
  final Set<int> joined;
  final void Function(int id) onToggle;
  const _TournamentsView({super.key, required this.joined, required this.onToggle});
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        for (var id = 1; id <= 5; id++)
          Card(
            child: ListTile(
              leading: const Icon(Icons.emoji_events_outlined),
              title: Text('Tournament #$id'),
              subtitle: const Text('7-day challenge'),
              trailing: TextButton(
                onPressed: () => onToggle(id),
                child: Text(joined.contains(id) ? 'Leave' : 'Join'),
              ),
            ),
          ),
      ],
    );
  }
}

class _GroupsView extends StatelessWidget {
  final bool isPremium;
  final Set<int> joined;
  final void Function(int id) onToggle;
  const _GroupsView({super.key, required this.isPremium, required this.joined, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      padding: const EdgeInsets.all(12),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
            onPressed: isPremium ? () {} : null,
            icon: const Icon(Icons.add),
            label: const Text('Create group'),
          ),
        ),
        const SizedBox(height: 8),
        for (var id = 1; id <= 5; id++)
          Card(
            child: ListTile(
              leading: const Icon(Icons.group_outlined),
              title: Text('Group #$id'),
              subtitle: const Text('Social fitness group'),
              trailing: TextButton(
                onPressed: isPremium ? () => onToggle(id) : null,
                child: Text(joined.contains(id) ? 'Leave' : 'Join'),
              ),
            ),
          ),
      ],
    );

    return Stack(
      children: [
        list,
        if (!isPremium)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                alignment: Alignment.center,
                color: Colors.white.withOpacity(0.70),
                child: const PremiumWall(
                  title: 'Premium Feature',
                  message: 'Create and join groups with Premium',
                ),
              ),
            ),
          ),
      ],
    );
  }
}
