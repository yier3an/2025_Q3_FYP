import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String email;
  final String name;           // stored as displayName in Firestore
  final String role;           // 'free'|'premium'|'fitness'|'admin'
  final bool isActive;         // canonical active flag
  final DateTime joinedAt;
  final String? avatarUrl;

  String get status => isActive ? 'active' : 'inactive';

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isActive,
    required this.joinedAt,
    this.avatarUrl,
  });

  factory AppUser.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    DateTime toDate(v) =>
        v is Timestamp ? v.toDate() : DateTime.tryParse('$v') ?? DateTime.now();
    return AppUser(
      id: d.id,
      email: (m['email'] ?? '') as String,
      name: (m['displayName'] ?? '') as String,
      role: (m['role'] ?? 'free').toString().toLowerCase(),
      isActive: (m['isActive'] ?? true) as bool,
      joinedAt: toDate(m['createdAt'] ?? m['joinedAt']),
      avatarUrl: m['avatarUrl'] as String?,
    );
  }
}
