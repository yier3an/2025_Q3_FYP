import 'package:flutter/material.dart';
import '../globals.dart';
import '../services/social_store.dart';
import '../services/auth_service_mock.dart';
import '../theme.dart';

class TournamentDetailPage extends StatefulWidget {
  final String tournamentId;
  const TournamentDetailPage({super.key, required this.tournamentId});

  @override
  State<TournamentDetailPage> createState() => _TournamentDetailPageState();
}

class _TournamentDetailPageState extends State<TournamentDetailPage> {
  late final SocialStore _social;
  late final AuthServiceMock _auth;

  @override
  void initState() {
    super.initState();
    _social = Globals.social;
    _auth = Globals.auth;
    _social.addListener(_onChange);
  }

  void _onChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _social.removeListener(_onChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _social.tournamentById(widget.tournamentId);
    if (t == null) {
      return const Scaffold(body: Center(child: Text('Tournament not found')));
    }

    final userId = _auth.current?.id ?? 'guest';
    final joined = _social.isInTournament(t.id, userId);

    // Sort leaderboard (desc)
    final lb = t.leaderboard.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: Text(t.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Card(
            color: AppTheme.purpleLight.withOpacity(0.35),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.purpleLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.emoji_events),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      t.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (joined) {
                _social.leaveTournament(t.id, userId);
              } else {
                _social.joinTournament(t.id, userId);
              }
            },
            style: ElevatedButton.styleFrom(shape: const StadiumBorder(), padding: const EdgeInsets.symmetric(vertical: 12)),
            child: Text(joined ? 'Leave tournament' : 'Join tournament'),
          ),
          const SizedBox(height: 20),
          Text('Leaderboard', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (lb.isEmpty)
            const Text('No participants yet.')
          else
            ...lb.asMap().entries.map((e) {
              final rank = e.key + 1;
              final uid = e.value.key;
              final score = e.value.value;
              final isYou = uid == userId;
              return ListTile(
                leading: CircleAvatar(child: Text('$rank')),
                title: Text(isYou ? 'You ($uid)' : uid),
                trailing: Text('$score'),
              );
            }),
        ],
      ),
    );
  }
}
