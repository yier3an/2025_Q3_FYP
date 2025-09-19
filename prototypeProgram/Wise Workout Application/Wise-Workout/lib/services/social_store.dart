import 'package:flutter/foundation.dart';
// ADD near your other classes
class Message {
  final String id;
  final String groupId;
  final String userId;
  final String text;
  final DateTime ts;

  Message({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.text,
    required this.ts,
  });
}

class Tournament {
  final String id;
  String name;
  String description;
  // userId -> score
  final Map<String, int> leaderboard;

  Tournament({
    required this.id,
    required this.name,
    required this.description,
    Map<String, int>? leaderboard,
  }) : leaderboard = leaderboard ?? {};
}

class Group {
  final String id;
  String name;
  String description;
  // Set of userIds
  final Set<String> members;

  Group({
    required this.id,
    required this.name,
    required this.description,
    Set<String>? members,
  }) : members = members ?? {};
}

/// In-memory store for tournaments and groups.
/// - Persists for the entire app session.
/// - Notifies listeners on change so UIs update automatically.
class SocialStore extends ChangeNotifier {
  // Demo seed data
  final Map<String, List<Message>> _groupMessages = {
    'g1': [
      Message(
        id: 'm1',
        groupId: 'g1',
        userId: 'user1',
        text: 'Welcome to Early Risers! 🌅',
        ts: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ],
    'g2': [],
  };
  List<Message> messagesForGroup(String groupId) =>
      List.unmodifiable(_groupMessages[groupId] ?? const []);

  void postMessage({required String groupId, required String userId, required String text}) {
    if (text.trim().isEmpty) return;
    final list = _groupMessages.putIfAbsent(groupId, () => []);
    list.add(Message(
      id: 'm${DateTime.now().microsecondsSinceEpoch}',
      groupId: groupId,
      userId: userId,
      text: text.trim(),
      ts: DateTime.now(),
    ));
    notifyListeners();
  }

  final Map<String, Tournament> _tournaments = {
    't1': Tournament(
      id: 't1',
      name: '5K Weekly Sprint',
      description: 'Rack up distance this week. 1 point per 100m!',
      leaderboard: {'user1': 120, 'user2': 90},
    ),
    't2': Tournament(
      id: 't2',
      name: 'Push-up Showdown',
      description: 'Max push-ups in 7 days. 1 point per rep.',
      leaderboard: {'user3': 210},
    ),
  };

  final Map<String, Group> _groups = {
    'g1': Group(
      id: 'g1',
      name: 'Early Risers',
      description: '6am accountability crew. Post your morning workout!',
      members: {'user1'},
    ),
    'g2': Group(
      id: 'g2',
      name: 'Strength Club',
      description: 'Hypertrophy & strength training talk.',
      members: {'user2'},
    ),
  };




  // -------- Read APIs --------
  List<Tournament> get tournaments => _tournaments.values.toList(growable: false);
  List<Group> get groups => _groups.values.toList(growable: false);
  Tournament? tournamentById(String id) => _tournaments[id];
  Group? groupById(String id) => _groups[id];

  bool isInGroup(String groupId, String userId) =>
      _groups[groupId]?.members.contains(userId) ?? false;

  bool isInTournament(String tournamentId, String userId) =>
      _tournaments[tournamentId]?.leaderboard.containsKey(userId) ?? false;

  // -------- Mutations (emit notifyListeners) --------
  void joinGroup(String groupId, String userId) {
    final g = _groups[groupId];
    if (g == null) return;
    g.members.add(userId);
    notifyListeners();
  }

  void leaveGroup(String groupId, String userId) {
    final g = _groups[groupId];
    if (g == null) return;
    g.members.remove(userId);
    notifyListeners();
  }

  void joinTournament(String tournamentId, String userId) {
    final t = _tournaments[tournamentId];
    if (t == null) return;
    t.leaderboard.putIfAbsent(userId, () => 0);
    notifyListeners();
  }

  void leaveTournament(String tournamentId, String userId) {
    final t = _tournaments[tournamentId];
    if (t == null) return;
    t.leaderboard.remove(userId);
    notifyListeners();
  }

  // You’ll use these in #4 (create flows), but safe to have now:
  String createTournament({required String name, required String description}) {
    final id = 't${DateTime.now().millisecondsSinceEpoch}';
    _tournaments[id] = Tournament(id: id, name: name, description: description);
    notifyListeners();
    return id;
  }

  String createGroup({required String name, required String description}) {
    final id = 'g${DateTime.now().millisecondsSinceEpoch}';
    _groups[id] = Group(id: id, name: name, description: description);
    notifyListeners();
    return id;
  }

}
