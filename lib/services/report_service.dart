import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wise_workout_admin/models/report.dart';
import 'package:wise_workout_admin/services/moderation_log_service.dart';

class ReportService {
  final _col  = FirebaseFirestore.instance.collection('reports');
  final _logs = ModerationLogService();

  // Tolerant stream, sorted client-side; filter done client-side to avoid indexes.
  Stream<List<Report>> streamReports({String status = 'pending'}) {
    return _col.snapshots().map((s) {
      // ignore: avoid_print
      print('reports snapshot: ${s.docs.length}');
      final list = s.docs.map((d) => Report.fromDoc(d)).toList();
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (status == 'all') return list;
      return list.where((r) => r.status == status).toList();
    });
  }

  Future<void> setStatus(
    String id,
    String status, {
    String? resolvedBy,
    String? action,
    String? actionNote,
    String? adminEmail,
    String? adminName,
    Report? fullReport,
    String? oldStatus,
  }) async {
    final data = <String, dynamic>{
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (status == 'pending') {
      data['resolvedAt'] = null;
      data['resolvedBy'] = null;
      data['action']     = null;
      data['actionNote'] = actionNote;
    } else {
      data['resolvedAt'] = FieldValue.serverTimestamp();
      if (resolvedBy != null) data['resolvedBy'] = resolvedBy;
      data['action']     = action;
      data['actionNote'] = actionNote;
    }

    await _col.doc(id).update(data);

    if (fullReport != null) {
      final newStatus = status;
      String actionLabel;
      if (newStatus == 'actioned' && action == 'suspend') {
        actionLabel = 'suspend';
      } else if (newStatus == 'dismissed') {
        actionLabel = 'dismiss';
      } else if (newStatus == 'pending') {
        actionLabel = 'reopen';
      } else {
        actionLabel = 'update';
      }

      await _logs.logReportChange(
        report: fullReport,
        action: actionLabel,
        outcomeStatus: 'success',
        adminEmail: adminEmail,
        adminName: adminName,
        note: actionNote,
        oldStatus: oldStatus,
        newStatus: newStatus,
      );
    }
  }

  Future<void> dismissReport(
    Report r, {
    String? note,
    String? adminEmail,
    String? adminName,
  }) =>
      setStatus(
        r.id, 'dismissed',
        resolvedBy: adminEmail,
        actionNote: note,
        adminEmail: adminEmail,
        adminName: adminName,
        fullReport: r,
        oldStatus: r.status,
      );

  Future<void> actionSuspend(
    Report r, {
    String? note,
    String? adminEmail,
    String? adminName,
    int days = 3,
  }) =>
      setStatus(
        r.id, 'actioned',
        resolvedBy: adminEmail,
        action: 'suspend',
        actionNote: note ?? 'Suspended for $days day(s).',
        adminEmail: adminEmail,
        adminName: adminName,
        fullReport: r,
        oldStatus: r.status,
      );

  Future<void> markPending(
    Report r, {
    String? note,
    String? adminEmail,
    String? adminName,
  }) =>
      setStatus(
        r.id, 'pending',
        actionNote: note,
        adminEmail: adminEmail,
        adminName: adminName,
        fullReport: r,
        oldStatus: r.status,
      );
}
