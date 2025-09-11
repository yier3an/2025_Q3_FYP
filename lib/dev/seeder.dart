import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Call this in main() only in debug builds.
/// It creates a few 'users' docs if the collection is empty.
class DevSeeder {
  static Future<void> seedUsersIfEmpty() async {
    if (!kDebugMode) return; // safety: never seed in release

    final col = FirebaseFirestore.instance.collection('users');
    final exists = await col.limit(1).get();
    if (exists.size > 0) return; // already have data

    final now = DateTime.now();

    // helper: stable doc id derived from email (so we don’t duplicate)
    String docIdFromEmail(String email) =>
        email.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '-');

    final samples = [
      {
        'name': 'Isabella Christensen',
        'email': 'isabella@gmail.com',
        'role': 'free',           // free | premium | fitness | admin
        'status': 'inactive',     // active | inactive
        'joinedAt': Timestamp.fromDate(now.subtract(const Duration(days: 120))),
        'avatarUrl': null,
        'seed': true,             // easy to clean up later
      },
      {
        'name': 'Mathilde Andersen',
        'email': 'mathilde@gmail.com',
        'role': 'premium',
        'status': 'active',
        'joinedAt': Timestamp.fromDate(now.subtract(const Duration(days: 115))),
        'avatarUrl': null,
        'seed': true,
      },
      {
        'name': 'Karla Sorensen',
        'email': 'karla@gmail.com',
        'role': 'fitness',
        'status': 'active',
        'joinedAt': Timestamp.fromDate(now.subtract(const Duration(days: 113))),
        'avatarUrl': null,
        'seed': true,
      },
      {
        'name': 'Ida Jorgensen',
        'email': 'ida@hotmail.com',
        'role': 'admin',
        'status': 'active',
        'joinedAt': Timestamp.fromDate(now.subtract(const Duration(days: 110))),
        'avatarUrl': null,
        'seed': true,
      },
      {
        'name': 'Albert Andersen',
        'email': 'albert@gmail.com',
        'role': 'free',
        'status': 'inactive',
        'joinedAt': Timestamp.fromDate(now.subtract(const Duration(days: 50))),
        'avatarUrl': null,
        'seed': true,
      },
    ];

    final batch = FirebaseFirestore.instance.batch();
    for (final u in samples) {
      final doc = col.doc(docIdFromEmail(u['email'] as String));
      batch.set(doc, u);
    }
    await batch.commit();
  }

  /// If you want to remove the dummy data later:
  static Future<void> clearSeededUsers() async {
    final col = FirebaseFirestore.instance.collection('users');
    final q = await col.where('seed', isEqualTo: true).get();
    final batch = FirebaseFirestore.instance.batch();
    for (final d in q.docs) {
      batch.delete(d.reference);
    }
    await batch.commit();
  }
}
