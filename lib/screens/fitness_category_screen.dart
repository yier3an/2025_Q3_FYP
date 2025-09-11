import 'package:flutter/material.dart';
import 'package:wise_workout_admin/widgets/side_nav.dart';
import 'package:wise_workout_admin/models/fitness_category.dart';
import 'package:wise_workout_admin/services/fitness_category_service.dart';

class FitnessCategoryScreen extends StatefulWidget {
  const FitnessCategoryScreen({super.key});
  @override
  State<FitnessCategoryScreen> createState() => _FitnessCategoryScreenState();
}

class _FitnessCategoryScreenState extends State<FitnessCategoryScreen> {
  final _service = FitnessCategoryService();
  String _query = '';
  String _statusFilter = 'All'; // All | Active | Inactive

  List<FitnessCategory> _applyFilters(List<FitnessCategory> raw) {
    final q = _query.toLowerCase();
    return raw.where((c) {
      final matchesQuery = q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.description.toLowerCase().contains(q);
      final matchesStatus = _statusFilter == 'All' ||
          (_statusFilter == 'Active' ? c.isActive : !c.isActive);
      return matchesQuery && matchesStatus;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                      // Header row + Add
                      Row(
                        children: [
                          const Text('Admin Dashboard',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const Spacer(),
                          FilledButton.icon(
                            icon: const Icon(Icons.add),
                            label: const Text('Add Category'),
                            onPressed: _addDialog,
                          ),
                          const SizedBox(width: 10),
                          FilledButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text('Fitness Category',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),

                      // Search + Filter
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (v) => setState(() => _query = v),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search by name or exercise',
                                isDense: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: const Color(0xFFF6F6FB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 160,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: const Color(0xFFF6F6FB),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _statusFilter,
                                  items: const [
                                    DropdownMenuItem(value: 'All', child: Text('Filter All')),
                                    DropdownMenuItem(value: 'Active', child: Text('Active')),
                                    DropdownMenuItem(value: 'Inactive', child: Text('Inactive')),
                                  ],
                                  onChanged: (v) => setState(() => _statusFilter = v ?? 'All'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Live list
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Material(
                            color: Colors.white,
                            child: StreamBuilder<List<FitnessCategory>>(
                              stream: _service.streamCategories(),
                              builder: (context, snap) {
                                if (snap.hasError) {
                                  return Center(child: Text('Error: ${snap.error}'));
                                }
                                if (!snap.hasData) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                final list = _applyFilters(snap.data!);
                                if (list.isEmpty) {
                                  return const Center(child: Text('No categories match your filters.'));
                                }

                                return ListView.separated(
                                  itemCount: list.length,
                                  separatorBuilder: (_, __) => const Divider(height: 1),
                                  itemBuilder: (_, i) {
                                    final c = list[i];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                      child: Row(
                                        children: [
                                          // Category name
                                          Expanded(
                                            child: Text(c.name,
                                                style: const TextStyle(fontWeight: FontWeight.w600)),
                                          ),
                                          // Description
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              c.description,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(color: Colors.grey[800]),
                                            ),
                                          ),
                                          // Status badge
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: _Pill(
                                                c.isActive ? 'Active' : 'Inactive',
                                                c.isActive
                                                    ? const Color(0xFFE9F9EF)
                                                    : const Color(0xFFFFEAEA),
                                                c.isActive
                                                    ? const Color(0xFF118A41)
                                                    : const Color(0xFFCA2C2C),
                                              ),
                                            ),
                                          ),
                                          // Actions
                                          SizedBox(
                                            width: 330,
                                            child: Wrap(
                                              spacing: 8,
                                              children: [
                                                // View exercises
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: const Color(0xFFEFE7FF)),
                                                  onPressed: () => Navigator.pushNamed(
                                                    context,
                                                    '/fitness/exercises',
                                                    arguments: {'id': c.id, 'name': c.name},
                                                  ),
                                                  child: const Text('View Exercise'),
                                                ),
                                                // Toggle active
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: const Color(0xFFE9F9EF)),
                                                  onPressed: () =>
                                                      _service.setActive(c.id, !c.isActive),
                                                  child: Text(c.isActive ? 'Set Inactive' : 'Set Active'),
                                                ),
                                                // Edit
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: const Color(0xFFEAF6FF)),
                                                  onPressed: () => _editDialog(c),
                                                  child: const Text('Edit'),
                                                ),
                                                // Delete
                                                TextButton(
                                                  style: TextButton.styleFrom(
                                                      backgroundColor: const Color(0xFFFFEAEA)),
                                                  onPressed: () => _confirmDelete(c),
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

  // ---------- Dialogs ----------

  Future<void> _addDialog() async {
    String name = '';
    String desc = '';
    bool isActive = true;

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
            const Text('Add Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
              onChanged: (v) => desc = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Active'),
                const SizedBox(width: 8),
                StatefulBuilder(
                  builder: (_, setSB) => Switch(
                    value: isActive,
                    onChanged: (v) => setSB(() => isActive = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () async {
                  if (name.trim().isEmpty) return;
                  await _service.addCategory(
                    name: name.trim(),
                    description: desc.trim(),
                    isActive: isActive,
                  );
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

  Future<void> _editDialog(FitnessCategory c) async {
    String name = c.name;
    String desc = c.description;
    bool isActive = c.isActive;

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
            const Text('Edit Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: name),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              controller: TextEditingController(text: desc),
              maxLines: 3,
              onChanged: (v) => desc = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Active'),
                const SizedBox(width: 8),
                StatefulBuilder(
                  builder: (_, setSB) => Switch(
                    value: isActive,
                    onChanged: (v) => setSB(() => isActive = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: () async {
                  final updated = c.copyWith(
                    name: name.trim(),
                    description: desc.trim(),
                    isActive: isActive,
                  );
                  await _service.updateCategory(updated);
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Save changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(FitnessCategory c) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete category?'),
        content: Text('This will remove "${c.name}". This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      await _service.deleteCategory(c.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Deleted ${c.name}')),
        );
      }
    }
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text, this.bg, this.fg);
  final String text;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
