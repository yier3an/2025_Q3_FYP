import 'package:flutter/material.dart';
import 'package:wise_workout_admin/widgets/side_nav.dart';
import 'package:wise_workout_admin/models/report.dart';
import 'package:wise_workout_admin/services/report_service.dart';

class ReportReviewScreen extends StatefulWidget {
  const ReportReviewScreen({super.key});
  @override
  State<ReportReviewScreen> createState() => _ReportReviewScreenState();
}

class _ReportReviewScreenState extends State<ReportReviewScreen> {
  final _service = ReportService();

  String _query = '';
  String _statusFilter = 'pending'; // default to 'pending' like we agreed
  final List<String> _statusItems = const ['pending', 'actioned', 'dismissed', 'all'];

  List<Report> _apply(List<Report> raw) {
    final q = _query.toLowerCase();
    return raw.where((r) {
      final inQuery = q.isEmpty ||
          r.id.toLowerCase().contains(q) ||
          r.reportedUserEmail.toLowerCase().contains(q) ||
          r.reporterEmail.toLowerCase().contains(q) ||
          r.reportedUserName.toLowerCase().contains(q) ||
          r.reporterName.toLowerCase().contains(q);
      return inQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const SideNav(currentRoute: '/reports'),
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
                      const Text('Report Review',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (v) => setState(() => _query = v),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: 'Search by report ID, reporter or reported email',
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
                                filled: true, fillColor: const Color(0xFFF6F6FB),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _statusFilter,
                                  items: _statusItems
                                      .map((s) => DropdownMenuItem(value: s, child: Text(_cap(s))))
                                      .toList(),
                                  onChanged: (v) => setState(() => _statusFilter = v ?? 'pending'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // header
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                        child: Row(
                          children: const [
                            Expanded(flex: 2, child: _Header('Report ID')),
                            Expanded(flex: 3, child: _Header('Reported User')),
                            Expanded(flex: 3, child: _Header('Reporter')),
                            Expanded(flex: 2, child: _Header('Category')),
                            Expanded(flex: 2, child: _Header('Details')),
                            SizedBox(width: 180, child: _Header('Actions')),
                          ],
                        ),
                      ),
                      const Divider(height: 1),

                      Expanded(
                        child: StreamBuilder<List<Report>>(
                          stream: _service.streamReports(status: _statusFilter),
                          builder: (context, snap) {
                            if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
                            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                            final list = _apply(snap.data!);
                            if (list.isEmpty) return const Center(child: Text('No reports found.'));
                            return ListView.separated(
                              itemCount: list.length,
                              separatorBuilder: (_, __) => const Divider(height: 1),
                              itemBuilder: (_, i) => _ReportRow(
                                r: list[i],
                                onDismiss: () => _dismiss(list[i]),
                                onSuspend: () => _suspend(list[i]),
                                onReopen: () => _reopen(list[i]),
                              ),
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

  Future<void> _dismiss(Report r) async {
    final note = await _promptNote('Dismiss report', 'Optional note');
    if (note == null) return;
    await _service.dismissReport(
      r,
      note: note,
      adminEmail: 'admin@example.com',
      adminName: 'Admin',
    );
  }

  Future<void> _suspend(Report r) async {
    final note = await _promptNote('Suspend user', 'Reason / note');
    if (note == null) return;
    await _service.actionSuspend(
      r,
      note: note,
      adminEmail: 'admin@example.com',
      adminName: 'Admin',
    );
  }

  Future<void> _reopen(Report r) async {
    final note = await _promptNote('Reopen report', 'Optional note');
    if (note == null) return;
    await _service.markPending(
      r,
      note: note,
      adminEmail: 'admin@example.com',
      adminName: 'Admin',
    );
  }

  Future<String?> _promptNote(String title, String hint) async {
    final c = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: c, decoration: InputDecoration(isDense: true, hintText: hint)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, c.text.trim()), child: const Text('OK')),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF7A7A7A)));
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

class _ReportRow extends StatelessWidget {
  const _ReportRow({required this.r, required this.onDismiss, required this.onSuspend, required this.onReopen});

  final Report r;
  final VoidCallback onDismiss;
  final VoidCallback onSuspend;
  final VoidCallback onReopen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(_short(r.id), style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(
            flex: 3,
            child: Row(children: [
              _Avatar(r.reportedUserName),
              const SizedBox(width: 8),
              Flexible(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(r.reportedUserEmail, overflow: TextOverflow.ellipsis),
                  Text(r.reportedUserName, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                ]),
              ),
            ]),
          ),
          Expanded(
            flex: 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.reporterEmail, overflow: TextOverflow.ellipsis),
              Text(r.reporterName, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
            ]),
          ),
          Expanded(flex: 2, child: _Pill(r.category, const Color(0xFFE6F3FF), const Color(0xFF0E6FD1))),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                _Pill(_cap(r.status), r.status == 'pending' ? const Color(0xFFFFF6E5) : const Color(0xFFE9F9EF),
                    r.status == 'pending' ? const Color(0xFFB38700) : const Color(0xFF118A41)),
                const SizedBox(width: 8),
                if ((r.action ?? '').isNotEmpty) Text(r.action!, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
              ],
            ),
          ),
          SizedBox(
            width: 180,
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              if (r.status != 'dismissed')
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: const Color(0xFFEAF6FF)),
                  onPressed: onDismiss,
                  child: const Text('Dismiss'),
                ),
              const SizedBox(width: 8),
              if (r.status != 'actioned')
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: const Color(0xFFF2E9FF)),
                  onPressed: onSuspend,
                  child: const Text('Suspend'),
                ),
              const SizedBox(width: 8),
              if (r.status != 'pending')
                TextButton(
                  style: TextButton.styleFrom(backgroundColor: const Color(0xFFF6F6F6)),
                  onPressed: onReopen,
                  child: const Text('Reopen'),
                ),
            ]),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar(this.name, {Key? key}) : super(key: key);

  final String name;

  String get initials {
    final s = name.trim();
    return s.isEmpty ? '?' : s[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: const Color(0xFF7A3EF2),
      child: Text(initials, style: const TextStyle(color: Colors.white)),
    );
  }
}

String _short(String id) => '#${id.substring(0, 6).toUpperCase()}';
String _cap(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
