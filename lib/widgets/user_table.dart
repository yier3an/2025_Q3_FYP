import 'package:flutter/material.dart';
import 'package:wise_workout_admin/models/app_user.dart';
import 'package:wise_workout_admin/services/user_service.dart';

class UserTable extends StatefulWidget {
  const UserTable({super.key});
  @override
  State<UserTable> createState() => _UserTableState();
}

class _UserTableState extends State<UserTable> {
  final _service = UserService();
  String _query = '';
  String _roleFilter = 'All';

  List<AppUser> _applyFilters(List<AppUser> raw) {
    final q = _query.toLowerCase();
    return raw.where((u) {
      final matchesQuery =
          q.isEmpty || u.name.toLowerCase().contains(q) || u.email.toLowerCase().contains(q);
      final matchesRole =
          (_roleFilter == 'All' || _roleFilter == 'Role') || u.role.toLowerCase() == _roleFilter.toLowerCase();
      return matchesQuery && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('User Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Search by name or email',
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: const Color(0xFFF6F6FB),
                ),
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 180,
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
                    value: _roleFilter,
                    items: const [
                      DropdownMenuItem(value: 'All', child: Text('Role')),
                      DropdownMenuItem(value: 'free', child: Text('Free')),
                      DropdownMenuItem(value: 'premium', child: Text('Premium')),
                      DropdownMenuItem(value: 'fitness', child: Text('Fitness')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (v) => setState(() => _roleFilter = v ?? 'All'),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Colors.white,
              child: StreamBuilder<List<AppUser>>(
                stream: _service.streamUsers(),
                builder: (context, snap) {
                  if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
                  if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                  final users = _applyFilters(snap.data!);
                  if (users.isEmpty) return const Center(child: Text('No users match your filters.'));
                  return ListView.separated(
                    itemCount: users.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => _UserRow(
                      user: users[i],
                      onToggleStatus: () async {
                        final newStatus = users[i].isActive ? 'inactive' : 'active';
                        await _service.setStatus(users[i].id, newStatus);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Status → $newStatus')),
                          );
                        }
                      },
                      onUpdate: () => _showUpdateSheet(context, users[i]),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showUpdateSheet(BuildContext context, AppUser u) {
    String role = u.role;
    bool active = u.isActive;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Update ${u.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Role'),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: role,
                    items: const [
                      DropdownMenuItem(value: 'free', child: Text('Free')),
                      DropdownMenuItem(value: 'premium', child: Text('Premium')),
                      DropdownMenuItem(value: 'fitness', child: Text('Fitness')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: (v) => setState(() => role = v ?? role),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text('Status'),
                  const SizedBox(width: 16),
                  DropdownButton<bool>(
                    value: active,
                    items: const [
                      DropdownMenuItem(value: true, child: Text('Active')),
                      DropdownMenuItem(value: false, child: Text('Inactive')),
                    ],
                    onChanged: (v) => setState(() => active = v ?? active),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () async {
                    await Future.wait([
                      _service.setRole(u.id, role),
                      _service.setStatus(u.id, active ? 'active' : 'inactive'),
                    ]);
                    if (mounted) Navigator.pop(context);
                  },
                  child: const Text('Save changes'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UserRow extends StatelessWidget {
  const _UserRow({
    required this.user,
    required this.onToggleStatus,
    required this.onUpdate,
  });

  final AppUser user;
  final VoidCallback onToggleStatus;
  final VoidCallback onUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF7A3EF2),
            backgroundImage: (user.avatarUrl != null && user.avatarUrl!.isNotEmpty)
                ? NetworkImage(user.avatarUrl!)
                : null,
            child: (user.avatarUrl == null || user.avatarUrl!.isEmpty)
                ? Text(user.name.isNotEmpty ? user.name[0] : '?',
                    style: const TextStyle(color: Colors.white))
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.email, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(user.name, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
              ],
            ),
          ),
          Expanded(child: _RoleBadge(user.role)),
          Expanded(child: _StatusBadge(user.isActive)),
          Expanded(
            child: Text(_formatJoined(user.joinedAt),
                style: TextStyle(color: Colors.grey[700], fontSize: 12)),
          ),
          SizedBox(
            width: 220,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF2E9FF),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: onToggleStatus,
                  child: Text(user.isActive ? 'Suspend' : 'Restore'),
                ),
                const SizedBox(width: 8),
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: const Color(0xFFEAF6FF)),
                  onPressed: onUpdate,
                  child: const Text('Update'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;
  final Color bg;
  final Color fg;
  const _Pill(this.text, this.bg, this.fg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(999)),
      child: Text(text, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final String role;
  const _RoleBadge(this.role);
  @override
  Widget build(BuildContext context) {
    switch (role.toLowerCase()) {
      case 'premium':
        return const _Pill('Premium', Color(0xFFFFF3D6), Color(0xFFB38700));
      case 'fitness':
        return const _Pill('Fitness', Color(0xFFE6F3FF), Color(0xFF0E6FD1));
      case 'admin':
        return const _Pill('Admin', Color(0xFFEFE7FF), Color(0xFF6D39E5));
      default:
        return const _Pill('Free', Color(0xFFF1F5FF), Color(0xFF4660D9));
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;
  const _StatusBadge(this.active);
  @override
  Widget build(BuildContext context) {
    return _Pill(
      active ? 'Active' : 'Inactive',
      active ? const Color(0xFFE9F9EF) : const Color(0xFFFFEAEA),
      active ? const Color(0xFF118A41) : const Color(0xFFCA2C2C),
    );
  }
}

String _formatJoined(DateTime dt) {
  const months = ['JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} ${months[dt.month - 1]} $hh:$mm';
}
