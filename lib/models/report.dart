import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  Report({
    required this.id,
    required this.reportedUserId,
    required this.reportedUserEmail,
    required this.reportedUserName,
    this.reportedUserAvatar,
    required this.reporterUserId,
    required this.reporterEmail,
    required this.reporterName,
    required this.category,
    required this.description,
    required this.status,       // 'pending' | 'dismissed' | 'actioned'
    required this.createdAt,
    this.resolvedAt,
    this.resolvedBy,
    this.action,                // e.g., 'suspend'
    this.actionNote,
  });

  final String id;

  final String reportedUserId;
  final String reportedUserEmail;
  final String reportedUserName;
  final String? reportedUserAvatar;

  final String reporterUserId;
  final String reporterEmail;
  final String reporterName;

  final String category;
  final String description;

  final String status;
  final DateTime createdAt;

  final DateTime? resolvedAt;
  final String? resolvedBy;
  final String? action;
  final String? actionNote;

  factory Report.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    DateTime toDate(v) =>
        v is Timestamp ? v.toDate() : DateTime.tryParse('$v') ?? DateTime.now();
    return Report(
      id: d.id,
      reportedUserId: m['reportedUserId'] ?? '',
      reportedUserEmail: m['reportedUserEmail'] ?? '',
      reportedUserName: m['reportedUserName'] ?? '',
      reportedUserAvatar: m['reportedUserAvatar'],
      reporterUserId: m['reporterUserId'] ?? '',
      reporterEmail: m['reporterEmail'] ?? '',
      reporterName: m['reporterName'] ?? '',
      category: m['category'] ?? 'Other',
      description: m['description'] ?? '',
      status: (m['status'] ?? 'pending').toString().toLowerCase(),
      createdAt: toDate(m['createdAt']),
      resolvedAt: m['resolvedAt'] != null ? toDate(m['resolvedAt']) : null,
      resolvedBy: m['resolvedBy'],
      action: m['action'],
      actionNote: m['actionNote'],
    );
  }
}
