import 'package:flutter/material.dart';
<<<<<<< HEAD

import '../globals.dart';
import '../services/social_store.dart';
import '../services/auth_service_mock.dart';
import '../theme.dart';

import 'group_detail_page.dart';
import 'tournament_detail_page.dart';
import 'create_group_page.dart';
import 'create_tournament_page.dart';


=======
import 'shared_header.dart';
import '../widgets_paywall.dart';
import 'settings_page.dart';
>>>>>>> origin/main

class CommunityTabPage extends StatefulWidget {
  final bool isPremium;
  const CommunityTabPage({super.key, this.isPremium = false});
<<<<<<< HEAD

=======
>>>>>>> origin/main
  @override
  State<CommunityTabPage> createState() => _CommunityTabPageState();
}

class _CommunityTabPageState extends State<CommunityTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tc;
<<<<<<< HEAD
  late final SocialStore _social;
  late final AuthServiceMock _auth;
=======
  final Set<int> _joinedGroupIds = {};
  final Set<int> _joinedTournamentIds = {};
>>>>>>> origin/main

  @override
  void initState() {
    super.initState();
    _tc = TabController(length: 3, vsync: this)..addListener(() => setState(() {}));
<<<<<<< HEAD
    _social = Globals.social;
    _auth   = Globals.auth;

    _social.addListener(_onStoreChanged);
    _auth.addListener(_onStoreChanged); // <-- ensure this line exists
=======
>>>>>>> origin/main
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _social.removeListener(_onStoreChanged);
    _auth.removeListener(_onStoreChanged);   // <-- and this
    _tc.dispose();
    super.dispose();
  }
  void _onStoreChanged() {
    if (mounted) setState(() {});
  }


  Widget? _buildFab({required bool isPremium}) {
    // Tab indices: 0=Active, 1=Tournaments, 2=Groups
    if (!isPremium) return null;
    if (_tc.index == 1) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTournamentPage()),
          );
        },
        icon: const Icon(Icons.emoji_events),
        label: const Text('Create tournament'),
      );
    }
    if (_tc.index == 2) {
      return FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateGroupPage()),
          );
        },
        icon: const Icon(Icons.groups),
        label: const Text('Create group'),
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user   = _auth.current;
    final userId = user?.id ?? 'guest';
    final isPremium = widget.isPremium || _auth.isPremium;  // <-- use your boolean


    final tournaments = _social.tournaments;
    final groups = _social.groups;

    final activeTournaments =
    tournaments.where((t) => _social.isInTournament(t.id, userId)).toList();
    final activeGroups =
    groups.where((g) => _social.isInGroup(g.id, userId)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: Column(
        children: [
          // === PILL TAB BAR ===
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.purpleLight,
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.all(6),
              child: TabBar(
                controller: _tc,
                indicator: BoxDecoration(
                  color: AppTheme.purple,
                  borderRadius: BorderRadius.circular(999),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: const TextStyle(fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(text: 'Active'),
                  Tab(text: 'Tournaments'),
                  Tab(text: 'Groups'),
                ],
              ),
            ),
          ),

          // === CONTENT ===
=======
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
>>>>>>> origin/main
          Expanded(
            child: TabBarView(
              controller: _tc,
              children: [
<<<<<<< HEAD
                // ---- Active (tab 0) ----
                _ActiveTab(
                  activeTournaments: activeTournaments,
                  activeGroups: activeGroups,
                  isPremium: isPremium,
                  onToggleTournament: (id) {
                    final joined = _social.isInTournament(id, userId);
                    if (joined) {
                      _social.leaveTournament(id, userId);
                    } else {
                      _social.joinTournament(id, userId);
                    }
                  },
                  onToggleGroup: (id) {
                    if (!isPremium) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Groups are a Premium feature. Upgrade to join.'),
                        ),
                      );
                      return;
                    }
                    final joined = _social.isInGroup(id, userId);
                    if (joined) {
                      _social.leaveGroup(id, userId);
                    } else {
                      _social.joinGroup(id, userId);
                    }
                  },

                  onOpenTournament: (id) {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => TournamentDetailPage(tournamentId: id)),
                    );
                  },
                  onOpenGroup: (id) {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (_) => GroupDetailPage(groupId: id)),
                    );
                  },
                ),

                // ---- Tournaments (tab 1) ----
                _SectionList(
                  emptyText: 'No tournaments yet.',
                  children: tournaments
                      .map((t) => _TournamentTile(
                    t: t,
                    joined: _social.isInTournament(t.id, userId),
                    onJoinToggle: () {
                      final joined =
                      _social.isInTournament(t.id, userId);
                      if (joined) {
                        _social.leaveTournament(t.id, userId);
                      } else {
                        _social.joinTournament(t.id, userId);
                      }
                    },
                    onOpen: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TournamentDetailPage(tournamentId: t.id)),
                      );
                    },

                  ))
                      .toList(),
                ),

                // ---- Groups (tab 2) ----
                _SectionList(
                  emptyText: 'No groups yet.',
                  children: groups
                      .map((g) => _GroupTile(
                    g: g,
                    isPremium: isPremium,
                    joined: _social.isInGroup(g.id, userId),
                    onJoinToggle: () {
                      if (!isPremium) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Groups are a Premium feature. Upgrade to join.'),
                          ),
                        );
                        return;
                      }
                      final joined = _social.isInGroup(g.id, userId);
                      if (joined) {
                        _social.leaveGroup(g.id, userId);
                      } else {
                        _social.joinGroup(g.id, userId);
                      }
                    },

                    onOpen: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => GroupDetailPage(groupId: g.id)),
                      );
                    },

                  ))
                      .toList(),
=======
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
>>>>>>> origin/main
                ),
              ],
            ),
          ),
        ],
      ),
<<<<<<< HEAD
      floatingActionButton: _buildFab(isPremium: isPremium),
=======
>>>>>>> origin/main
    );
  }
}

<<<<<<< HEAD
/// Simple section list wrapper with safe padding/spacing.
class _SectionList extends StatelessWidget {
  final List<Widget> children;
  final String emptyText;
  const _SectionList({
    required this.children,
    required this.emptyText,
  });

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) {
      return Center(
        child: Text(
          emptyText,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      itemBuilder: (_, i) => children[i],
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: children.length,
    );
  }
}

class _TournamentTile extends StatelessWidget {
  final Tournament t;
  final bool joined;
  final VoidCallback onJoinToggle;
  final VoidCallback onOpen;

  const _TournamentTile({
    required this.t,
    required this.joined,
    required this.onJoinToggle,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final members = t.leaderboard.length;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: AppTheme.purpleLight.withOpacity(0.35),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: AppTheme.purpleLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.emoji_events),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.name,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      t.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text('Participants: $members'),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: onJoinToggle,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                child: Text(joined ? 'Leave' : 'Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  final Group g;
  final bool isPremium;          // controls the lock badge + join gating in parent
  final bool joined;
  final VoidCallback onJoinToggle;
  final VoidCallback onOpen;

  const _GroupTile({
    required this.g,
    required this.isPremium,
    required this.joined,
    required this.onJoinToggle,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final members = g.members.length;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: AppTheme.purpleLight.withOpacity(0.35),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onOpen, // tap anywhere to open details
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              // Left icon + optional lock badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppTheme.purpleLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.groups),
                  ),
                  if (!isPremium)
                    Positioned(
                      right: -4,
                      bottom: -4,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.lock, size: 14, color: Colors.white),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),

              // Title, description, meta
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(g.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(
                      g.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text('Members: $members'),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Join/Leave button (parent should gate with isPremium before calling onJoinToggle)
              ElevatedButton(
                onPressed: onJoinToggle,
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
                child: Text(joined ? 'Leave' : 'Join'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _ActiveTab extends StatelessWidget {
  final List<Tournament> activeTournaments;
  final List<Group> activeGroups;
  final bool isPremium;
  final void Function(String tournamentId) onToggleTournament;
  final void Function(String groupId) onToggleGroup;
  final void Function(String tournamentId) onOpenTournament;
  final void Function(String groupId) onOpenGroup;

  const _ActiveTab({
    required this.activeTournaments,
    required this.activeGroups,
    required this.isPremium,
    required this.onToggleTournament,
    required this.onToggleGroup,
    required this.onOpenTournament,
    required this.onOpenGroup,
  });

  @override
  Widget build(BuildContext context) {
    if (activeTournaments.isEmpty && activeGroups.isEmpty) {
      return const Center(child: Text('You haven’t joined anything yet.'));
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      children: [
        if (activeTournaments.isNotEmpty) ...[
          Text('Your Tournaments',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...activeTournaments.map((t) => _TournamentTile(
            t: t,
            joined: true,
            onJoinToggle: () => onToggleTournament(t.id),
            onOpen: () => onOpenTournament(t.id),
          )),
          const SizedBox(height: 20),
        ],
        if (activeGroups.isNotEmpty) ...[
          Text('Your Groups',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ...activeGroups.map((g) => _GroupTile(
            g: g,
            isPremium: isPremium,
            joined: true,
            onJoinToggle: () => onToggleGroup(g.id),
            onOpen: () => onOpenGroup(g.id),
          )),
        ],
=======
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
>>>>>>> origin/main
      ],
    );
  }
}
