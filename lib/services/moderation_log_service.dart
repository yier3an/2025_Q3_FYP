import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wise_workout_admin/models/moderation_log.dart';
import 'package:wise_workout_admin/models/report.dart';

class ModerationLogService {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('moderation_logs');

  // newest first
  Stream<List<ModerationLog>> streamLogs() => _col
      .orderBy('createdAt', descending: true)
      .snapshots()
      .map((s) => s.docs.map((d) => ModerationLog.fromDoc(d)).toList());

  Future<void> add(ModerationLog log) async {
    await _col.add(log.toMap());
  }

  /// For Report actions (called by ReportService after status change)
  Future<void> logReportChange({
    required Report report,
    required String action,         // 'suspend' | 'dismiss' | 'reopen' | 'update'
    required String outcomeStatus,  // 'success' | 'pending' | 'failed'
    String? adminEmail,
    String? adminName,
    String? note,
    String? oldStatus,
    String? newStatus,
  }) async {
    final log = ModerationLog(
      id: 'auto',
      entityType: 'report',
      entityId: report.id,
      action: action,
      status: outcomeStatus,
      reason: report.category,
      note: note,
      performedByEmail: adminEmail,
      performedByName: adminName,
      targetUserId: report.reportedUserId,
      targetUserEmail: report.reportedUserEmail,
      targetUserName: report.reportedUserName,
      oldStatus: oldStatus,
      newStatus: newStatus,
      createdAt: DateTime.now(),
    );
    await add(log);
  }

  /// For User actions (called by UserService)
  Future<void> logUserAction({
    required String userId,
    required String userEmail,
    required String userName,
    required String action,                // 'suspend_user' | 'restore_user' | 'update_role' | 'delete_user' | 'create_user'
    String outcomeStatus = 'success',
    String? adminEmail,
    String? adminName,
    String? reason,                        // e.g. 'Spam', 'Role changed'
    String? note,
    String? oldRole,
    String? newRole,
    bool? oldActive,                       // will be mapped to strings below
    bool? newActive,
  }) async {
    String? oldS, newS;
    if (oldActive != null || newActive != null) {
      oldS = oldActive == null ? null : (oldActive ? 'active' : 'suspended');
      newS = newActive == null ? null : (newActive ? 'active' : 'suspended');
    } else if (oldRole != null || newRole != null) {
      oldS = oldRole; newS = newRole;
    }

    final log = ModerationLog(
      id: 'auto',
      entityType: 'user',
      entityId: userId,
      action: action,
      status: outcomeStatus,
      reason: reason,
      note: note,
      performedByEmail: adminEmail,
      performedByName: adminName,
      targetUserId: userId,
      targetUserEmail: userEmail,
      targetUserName: userName,
      oldStatus: oldS,
      newStatus: newS,
      createdAt: DateTime.now(),
    );
    await add(log);
  }
}
