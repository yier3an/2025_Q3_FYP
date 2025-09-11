import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wise_workout_admin/models/fitness_category.dart';

class FitnessCategoryService {
  final _col = FirebaseFirestore.instance.collection('fitness_categories');

  /// Live categories ordered by sortOrder asc, then createdAt desc
  Stream<List<FitnessCategory>> streamCategories() {
    return _col
        .orderBy('sortOrder')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => FitnessCategory.fromDoc(d)).toList());
  }

  /// Helper to compute the next sort order (simple & safe for admin-only writes)
  Future<int> _nextSortOrder() async {
    final snap = await _col.orderBy('sortOrder', descending: true).limit(1).get();
    if (snap.docs.isEmpty) return 1;
    return ((snap.docs.first.data()['sortOrder'] ?? 0) as int) + 1;
  }

  Future<String> addCategory({
    required String name,
    required String description,
    bool isActive = true,
  }) async {
    final sortOrder = await _nextSortOrder();
    final doc = await _col.add({
      'name': name,
      'description': description,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  Future<void> updateCategory(FitnessCategory c) async {
    await _col.doc(c.id).update({
      'name': c.name,
      'description': c.description,
      'isActive': c.isActive,
      'sortOrder': c.sortOrder,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteCategory(String id) async {
    // (Optional) also delete subcollection 'exercises' if you want full cleanup
    await _col.doc(id).delete();
  }

  Future<void> setActive(String id, bool isActive) =>
      _col.doc(id).update({'isActive': isActive, 'updatedAt': FieldValue.serverTimestamp()});

  Future<void> moveUp(FitnessCategory c) =>
      _col.doc(c.id).update({'sortOrder': c.sortOrder - 1, 'updatedAt': FieldValue.serverTimestamp()});

  Future<void> moveDown(FitnessCategory c) =>
      _col.doc(c.id).update({'sortOrder': c.sortOrder + 1, 'updatedAt': FieldValue.serverTimestamp()});
}
