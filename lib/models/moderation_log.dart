import 'package:cloud_firestore/cloud_firestore.dart';

class ModerationLog {
  final String id;

  /// What the log is about
  final String entityType;   // 'report' | 'user'
  final String entityId;     // reportId or userId

  /// What action was taken and the outcome
  final String action;       // e.g. 'suspend', 'dismiss', 'reopen', 'update_role', 'suspend_user'
  final String status;       // 'success' | 'pending' | 'failed'

  /// Optional context
  final String? reason;      // e.g. 'Spam', 'Role changed'
  final String? note;        // free text

  /// Who performed the action
  final String? performedByEmail;
  final String? performedByName;

  /// Target user (useful for both 'user' and 'report' entities)
  final String? targetUserId;
  final String? targetUserEmail;
  final String? targetUserName;

  /// Audit trail (role/status before and after)
  final String? oldStatus;   // we reuse this for either status or role
  final String? newStatus;

  final DateTime createdAt;

  ModerationLog({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.action,
    required this.status,
    required this.createdAt,
    this.reason,
    this.note,
    this.performedByEmail,
    this.performedByName,
    this.targetUserId,
    this.targetUserEmail,
    this.targetUserName,
    this.oldStatus,
    this.newStatus,
  });

  factory ModerationLog.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    DateTime _toDate(v) =>
        v is Timestamp ? v.toDate() : DateTime.tryParse('$v') ?? DateTime.now();
    return ModerationLog(
      id: d.id,
      entityType: (m['entityType'] ?? '') as String,
      entityId: (m['entityId'] ?? '') as String,
      action: (m['action'] ?? '') as String,
      status: (m['status'] ?? 'success') as String,
      reason: m['reason'] as String?,
      note: m['note'] as String?,
      performedByEmail: m['performedByEmail'] as String?,
      performedByName: m['performedByName'] as String?,
      targetUserId: m['targetUserId'] as String?,
      targetUserEmail: m['targetUserEmail'] as String?,
      targetUserName: m['targetUserName'] as String?,
      oldStatus: m['oldStatus'] as String?,
      newStatus: m['newStatus'] as String?,
      createdAt: _toDate(m['createdAt']),
    );
  }

  Map<String, dynamic> toMap() => {
        'entityType': entityType,
        'entityId': entityId,
        'action': action,
        'status': status,
        'reason': reason,
        'note': note,
        'performedByEmail': performedByEmail,
        'performedByName': performedByName,
        'targetUserId': targetUserId,
        'targetUserEmail': targetUserEmail,
        'targetUserName': targetUserName,
        'oldStatus': oldStatus,
        'newStatus': newStatus,
        'createdAt': Timestamp.fromDate(createdAt),
      };
}
