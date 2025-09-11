import 'package:flutter/material.dart';
import 'package:wise_workout_admin/widgets/side_nav.dart';
import 'package:wise_workout_admin/models/moderation_log.dart';
import 'package:wise_workout_admin/services/moderation_log_service.dart';

class ModerationLogScreen extends StatefulWidget {
  const ModerationLogScreen({super.key});
  @override
  State<ModerationLogScreen> createState() => _ModerationLogScreenState();
}

class _ModerationLogScreenState extends State<ModerationLogScreen> {
  final _service = ModerationLogService();
  String _query = '';
  String _action = 'All';  // All | Suspend | Dismiss | Reopen | Update | Suspend_user | Restore_user | Update_role | Delete_user | Create_user
  String _status = 'All';  // All | Success | Pending | Failed

  List<ModerationLog> _apply(List<ModerationLog> raw) {
    final q = _query.toLowerCase();
    return raw.where((l) {
      final inQuery = q.isEmpty ||
          l.entityId.toLowerCase().contains(q) ||
          (l.performedByEmail ?? '').toLowerCase().contains(q) ||
          (l.performedByName ?? '').toLowerCase().contains(q) ||
          (l.targetUserEmail ?? '').toLowerCase().contains(q) ||
          (l.targetUserName ?? '').toLowerCase().contains(q) ||
          (l.reason ?? '').toLowerCase().contains(q) ||
          (l.note ?? '').toLowerCase().contains(q);
      final inStatus = _status == 'All' || l.status.toLowerCase() == _status.toLowerCase();
      final act = _action.toLowerCase();
      final inAction = _action == 'All' || l.action.toLowerCase() == act;
      return inQuery && inStatus && inAction;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNav(currentRoute: '/moderation'),
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
                          const Text('Admin Dashboard',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                          const Spacer(),
                          FilledButton(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      const Text('Moderation Log',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (v) => setState(() => _query = v),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search by report/user ID, user or admin',
                                isDense: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                filled: true,
                                fillColor: const Color(0xFFF6F6FB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          _Dropdown(
                            value: _action,
                            items: const [
                              'All',
                              'Suspend', 'Dismiss', 'Reopen', 'Update',
                              'Suspend_user', 'Restore_user', 'Update_role', 'Delete_user', 'Create_user',
                            ],
                            onChanged: (v) => setState(() => _action = v ?? 'All'),
                          ),
                          const SizedBox(width: 12),
                          _Dropdown(
                            value: _status,
                            items: const ['All', 'Success', 'Pending', 'Failed'],
                            onChanged: (v) => setState(() => _status = v ?? 'All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Header row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                        child: Row(
                          children: const [
                            SizedBox(width: 70,  child: _Header('Log ID')),
                            SizedBox(width: 140, child: _Header('Action')),
                            Expanded(child: _Header('Performed by')),
                            Expanded(child: _Header('Reason')),
                            SizedBox(width: 180, child: _Header('Datetime')),
                            SizedBox(width: 120, child: _Header('Status')),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      Expanded(
                        child: StreamBuilder<List<ModerationLog>>(
                          stream: _service.streamLogs(),
                          builder: (context, snap) {
                            if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
                            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                            final logs = _apply(snap.data!);
                            if (logs.isEmpty) return const Center(child: Text('No logs found.'));

                            return ListView.separated(
                              itemCount: logs.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (_, i) {
                                final l = logs[i];
                                final shortId = '#${l.id.substring(0, 4).toUpperCase()}';
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                                  child: Row(
                                    children: [
                                      SizedBox(width: 70, child: Text(shortId)),
                                      SizedBox(width: 140, child: _Linkish(l.action)),
                                      Expanded(child: Text(l.performedByName ?? l.performedByEmail ?? '—')),
                                      Expanded(child: Text(l.reason ?? '—', overflow: TextOverflow.ellipsis)),
                                      SizedBox(width: 180, child: Text(_fmt(l.createdAt),
                                          style: TextStyle(color: Colors.grey[700], fontSize: 12))),
                                      SizedBox(
                                        width: 120,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: _Pill(
                                            _cap(l.status),
                                            l.status == 'success'
                                                ? const Color(0xFFE9F9EF)
                                                : l.status == 'pending'
                                                    ? const Color(0xFFFFF6E5)
                                                    : const Color(0xFFFFEAEA),
                                            l.status == 'success'
                                                ? const Color(0xFF118A41)
                                                : l.status == 'pending'
                                                    ? const Color(0xFFB38700)
                                                    : const Color(0xFFCA2C2C),
                                          ),
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

class _Dropdown extends StatelessWidget {
  const _Dropdown({required this.value, required this.items, required this.onChanged});
  final String value; final List<String> items; final ValueChanged<String?> onChanged;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 180,
    child: InputDecorator(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true, fillColor: const Color(0xFFF6F6FB),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true, value: value,
          items: items.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF7A7A7A)),
  );
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

class _Linkish extends StatelessWidget {
  const _Linkish(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    _cap(text),
    style: const TextStyle(color: Color(0xFF6A53E7), fontWeight: FontWeight.w700, decoration: TextDecoration.underline),
  );
}

String _fmt(DateTime dt) {
  final dd = dt.day.toString().padLeft(2, '0');
  final mm = dt.month.toString().padLeft(2, '0');
  final yyyy = dt.year.toString();
  final hh = dt.hour.toString().padLeft(2, '0');
  final mi = dt.minute.toString().padLeft(2, '0');
  final ss = dt.second.toString().padLeft(2, '0');
  return '$dd-$mm-$yyyy $hh:$mi:$ss';
}
String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
