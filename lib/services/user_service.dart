import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wise_workout_admin/models/app_user.dart';
import 'package:wise_workout_admin/services/moderation_log_service.dart';

class UserService {
  final _col  = FirebaseFirestore.instance.collection('users');
  final _logs = ModerationLogService();

  Stream<List<AppUser>> streamUsers() => _col.snapshots().map((s) {
        // ignore: avoid_print
        print('users snapshot: ${s.docs.length}');
        final list = s.docs.map((d) => AppUser.fromDoc(d)).toList();
        list.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
        return list;
      });

  Future<Map<String, dynamic>> _get(String uid) async {
    final d = await _col.doc(uid).get();
    final m = d.data() ?? {};
    m['id'] = d.id;
    return m;
  }

  // Logging-first methods
  Future<void> suspendUser(String uid,
      {String? reason, String? note, String? adminEmail, String? adminName}) async {
    final m = await _get(uid);
    await _col.doc(uid).update({
      'isActive': false,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _logs.logUserAction(
      userId: uid,
      userEmail: (m['email'] ?? '') as String,
      userName: (m['displayName'] ?? '') as String,
      action: 'suspend_user',
      reason: reason ?? 'Manual suspension',
      note: note,
      adminEmail: adminEmail,
      adminName: adminName,
      oldActive: (m['isActive'] ?? true) as bool,
      newActive: false,
    );
  }

  Future<void> restoreUser(String uid,
      {String? note, String? adminEmail, String? adminName}) async {
    final m = await _get(uid);
    await _col.doc(uid).update({
      'isActive': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _logs.logUserAction(
      userId: uid,
      userEmail: (m['email'] ?? '') as String,
      userName: (m['displayName'] ?? '') as String,
      action: 'restore_user',
      reason: 'Manual restore',
      note: note,
      adminEmail: adminEmail,
      adminName: adminName,
      oldActive: (m['isActive'] ?? false) as bool,
      newActive: true,
    );
  }

  Future<void> updateRole(String uid, String newRole,
      {String? note, String? adminEmail, String? adminName}) async {
    final m = await _get(uid);
    final oldRole = (m['role'] ?? '') as String?;
    await _col.doc(uid).update({
      'role': newRole,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    await _logs.logUserAction(
      userId: uid,
      userEmail: (m['email'] ?? '') as String,
      userName: (m['displayName'] ?? '') as String,
      action: 'update_role',
      reason: 'Role changed',
      note: note ?? '${oldRole ?? ''} → $newRole',
      adminEmail: adminEmail,
      adminName: adminName,
      oldRole: oldRole,
      newRole: newRole,
    );
  }

  Future<void> deleteUser(String uid,
      {String? note, String? adminEmail, String? adminName}) async {
    final m = await _get(uid);
    await _col.doc(uid).delete();
    await _logs.logUserAction(
      userId: uid,
      userEmail: (m['email'] ?? '') as String,
      userName: (m['displayName'] ?? '') as String,
      action: 'delete_user',
      reason: 'Account removed',
      note: note,
      adminEmail: adminEmail,
      adminName: adminName,
    );
  }

  // Thin wrappers so existing UI calling setStatus/setRole keeps working
  Future<void> setStatus(String uid, String status,
      {String? note, String? adminEmail, String? adminName}) {
    final makeActive = status.toLowerCase() == 'active';
    return makeActive
        ? restoreUser(uid, note: note, adminEmail: adminEmail, adminName: adminName)
        : suspendUser(uid,
            reason: 'Manual change', note: note, adminEmail: adminEmail, adminName: adminName);
  }

  Future<void> setRole(String uid, String role,
      {String? note, String? adminEmail, String? adminName}) {
    return updateRole(uid, role, note: note, adminEmail: adminEmail, adminName: adminName);
  }
}
