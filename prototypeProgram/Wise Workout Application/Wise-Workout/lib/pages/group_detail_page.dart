import 'package:flutter/material.dart';
import '../globals.dart';
import '../services/social_store.dart';
import '../services/auth_service_mock.dart';
import '../theme.dart';

class GroupDetailPage extends StatefulWidget {
  final String groupId;
  const GroupDetailPage({super.key, required this.groupId});

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  late final SocialStore _social;
  late final AuthServiceMock _auth;
  final TextEditingController _msg = TextEditingController();
  void _onChange() {
    if (mounted) setState(() {});
  }
  @override
  void initState() {
    super.initState();
    _social = Globals.social;
    _auth = Globals.auth;
    _social.addListener(_onChange);
  }



  @override
  void dispose() {
    _social.removeListener(_onChange);
    _msg.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final g = _social.groupById(widget.groupId);
    if (g == null) {
      return const Scaffold(body: Center(child: Text('Group not found')));
    }

    final user   = _auth.current;
    final userId = user?.id ?? 'guest';
    final isPremium = _auth.isPremium;            // ✅ use your boolean
    final joined    = _social.isInGroup(g.id, userId);

    final members = g.members.toList()..sort();
    final msgs = _social.messagesForGroup(g.id);
    void _onChange() {
      if (mounted) setState(() {});
    }
    @override
    void initState() {
      super.initState();
      _social = Globals.social;
      _auth   = Globals.auth;

      _social.addListener(_onChange);
      _auth.addListener(_onChange);   // ✅ listen to auth too
    }



    @override
    void dispose() {
      _social.removeListener(_onChange);
      _auth.removeListener(_onChange); // ✅ remove listener
      _msg.dispose();
      super.dispose();
    }


    return Scaffold(
      appBar: AppBar(title: Text(g.name)),
      body: Column(
        children: [
          // Header / description / join button
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Card(
              color: AppTheme.purpleLight.withOpacity(0.35),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            color: AppTheme.purpleLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.groups),
                        ),
                        if (!isPremium)
                          Positioned(
                            right: -2, bottom: -2,
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
                    Expanded(
                      child: Text(g.description, style: const TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Members: ${members.length}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (!isPremium) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Groups are a Premium feature.')),
                      );
                      return;
                    }
                    if (joined) {
                      _social.leaveGroup(g.id, userId);
                    } else {
                      _social.joinGroup(g.id, userId);
                    }
                  },
                  child: Text(joined ? 'Leave group' : 'Join group'),
                ),


              ],
            ),
          ),

          const SizedBox(height: 6),
          // Members list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                Text('Members', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (members.isEmpty)
                  const Text('No members yet.')
                else
                  ...members.map((m) => ListTile(
                    dense: true,
                    leading: const CircleAvatar(child: Icon(Icons.person, size: 16)),
                    title: Text(m == userId ? 'You ($m)' : m),
                  )),
                const SizedBox(height: 16),
                Text('Group Chat', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (msgs.isEmpty)
                  const Text('No messages yet. Say hi! 👋')
                else
                  ...msgs.map((m) {
                    final isYou = m.userId == userId;
                    return Align(
                      alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isYou ? AppTheme.purple : AppTheme.purpleLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isYou)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Text(m.userId, style: const TextStyle(fontSize: 11, color: Colors.black54)),
                              ),
                            Text(
                              m.text,
                              style: TextStyle(color: isYou ? Colors.white : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 70),
              ],
            ),
          ),
          // Composer (disabled if not premium or not a member)
          SafeArea(
            top: false,
            minimum: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msg,
                    enabled: isPremium && joined,
                    decoration: InputDecoration(
                      hintText: isPremium
                          ? (joined ? 'Message...' : 'Join to chat')
                          : 'Upgrade to Premium to chat',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(999)),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: (!isPremium || !joined)
                      ? null
                      : () {
                    final text = _msg.text;
                    _msg.clear();
                    _social.postMessage(groupId: g.id, userId: userId, text: text);
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
