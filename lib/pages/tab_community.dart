import 'package:flutter/material.dart';
import 'shared_header.dart';

class CommunityTabPage extends StatefulWidget {
  const CommunityTabPage({super.key});
  @override
  State<CommunityTabPage> createState() => _CommunityTabPageState();
}

class _CommunityTabPageState extends State<CommunityTabPage> with SingleTickerProviderStateMixin {
  late final TabController _tc;
  @override
  void initState() { super.initState(); _tc = TabController(length: 3, vsync: this); }
  @override
  void dispose() { _tc.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SharedHeader(),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _PillTabs(controller: _tc, tabs: const [Tab(text: 'Active'), Tab(text: 'Challenges'), Tab(text: 'Groups')]),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tc,
              children: const [_ActiveView(), _ChallengesView(), _GroupsView()],
            ),
          ),
        ],
      ),
    );
  }
}

class _PillTabs extends StatelessWidget {
  final TabController controller; final List<Widget> tabs;
  const _PillTabs({required this.controller, required this.tabs});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(999)),
      child: TabBar(
        controller: controller, tabs: tabs,
        indicator: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(999)),
        indicatorSize: TabBarIndicatorSize.tab, labelColor: Colors.white, unselectedLabelColor: Colors.black87, dividerColor: Colors.transparent,
      ),
    );
  }
}

class _ActiveView extends StatelessWidget {
  const _ActiveView();
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: const [
        ListTile(leading: Icon(Icons.emoji_events), title: Text('10k Steps Weekly'), subtitle: Text('Day 4 of 7')),
        ListTile(leading: Icon(Icons.group), title: Text('Morning Runners SG'), subtitle: Text('Last active: 2h ago')),
      ],
    );
  }
}

class _ChallengesView extends StatelessWidget {
  const _ChallengesView();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (ctx, i) => Card(
        child: ListTile(
          leading: const Icon(Icons.flag),
          title: Text('Challenge #${i+1}'),
          subtitle: const Text('Join to compete this month'),
          trailing: TextButton(onPressed: (){}, child: const Text('Join')),
        ),
      ),
    );
  }
}

class _GroupsView extends StatelessWidget {
  const _GroupsView();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      itemBuilder: (ctx, i) => Card(
        child: ListTile(
          leading: const Icon(Icons.group_outlined),
          title: Text('Group #${i+1}'),
          subtitle: const Text('Social fitness group'),
          trailing: TextButton(onPressed: (){}, child: const Text('Join')),
        ),
      ),
    );
  }
}
