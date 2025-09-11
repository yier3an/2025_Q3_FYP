import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wise_workout_admin/widgets/side_nav.dart';

class ExerciseListScreen extends StatefulWidget {
  const ExerciseListScreen({super.key});
  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late final String categoryId;
  late final String categoryName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    categoryId = args['id'] as String;
    categoryName = args['name'] as String;
  }

  Future<void> _addExercise() async {
    String name = '';
    bool active = true;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16, top: 16,
          bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Exercise to $categoryName',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Exercise name'),
              onChanged: (v) => name = v,
            ),
            Row(
              children: [
                const Text('Active'),
                StatefulBuilder(
                  builder: (_, setSB) => Switch(
                    value: active,
                    onChanged: (v) => setSB(() => active = v),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () async {
                  if (name.trim().isEmpty) return;
                  await FirebaseFirestore.instance
                      .collection('fitness_categories')
                      .doc(categoryId)
                      .collection('exercises')
                      .add({
                    'name': name.trim(),
                    'isActive': active,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Create'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final q = FirebaseFirestore.instance
        .collection('fitness_categories')
        .doc(categoryId)
        .collection('exercises')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      body: Row(
        children: [
          const SideNav(currentRoute: '/fitness'),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight, end: Alignment.bottomLeft,
                  colors: [Color(0xFF7A3EF2), Color(0xFF3F0FFF)],
                ),
              ),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin: const EdgeInsets.all(22),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Exercises • $categoryName',
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const Spacer(),
                          FilledButton.icon(
                            onPressed: _addExercise,
                            icon: const Icon(Icons.add),
                            label: const Text('Add Exercise'),
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Back'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: q.snapshots(),
                          builder: (context, snap) {
                            if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
                            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                            final docs = snap.data!.docs;
                            if (docs.isEmpty) return const Center(child: Text('No exercises yet'));
                            return ListView.separated(
                              itemCount: docs.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final d = docs[i];
                                final m = d.data();
                                final name = (m['name'] ?? '') as String;
                                final active = (m['isActive'] ?? true) as bool;
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                      Expanded(
                                        child: _Pill(
                                          active ? 'Active' : 'Inactive',
                                          active ? const Color(0xFFE9F9EF) : const Color(0xFFFFEAEA),
                                          active ? const Color(0xFF118A41) : const Color(0xFFCA2C2C),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 220,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              style: TextButton.styleFrom(backgroundColor: const Color(0xFFE9F9EF)),
                                              onPressed: () => d.reference.update({'isActive': !active}),
                                              child: Text(active ? 'Set Inactive' : 'Set Active'),
                                            ),
                                            const SizedBox(width: 8),
                                            TextButton(
                                              style: TextButton.styleFrom(backgroundColor: const Color(0xFFFFEAEA)),
                                              onPressed: () => d.reference.delete(),
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.bg, this.fg);
  final String text; final Color bg; final Color fg;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
    child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}
