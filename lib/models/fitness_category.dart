import 'package:cloud_firestore/cloud_firestore.dart';

class FitnessCategory {
  final String id;
  final String name;
  final String description;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime? updatedAt;

  FitnessCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.sortOrder,
    required this.createdAt,
    this.updatedAt,
  });

  factory FitnessCategory.fromDoc(DocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data() ?? {};
    DateTime _toDate(v) =>
        v is Timestamp ? v.toDate() : DateTime.tryParse('$v') ?? DateTime.now();
    return FitnessCategory(
      id: d.id,
      name: (m['name'] ?? '') as String,
      description: (m['description'] ?? '') as String,
      isActive: (m['isActive'] ?? true) as bool,
      sortOrder: (m['sortOrder'] ?? 0) as int,
      createdAt: _toDate(m['createdAt']),
      updatedAt: m['updatedAt'] != null ? _toDate(m['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'description': description,
        'isActive': isActive,
        'sortOrder': sortOrder,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      };

  FitnessCategory copyWith({
    String? name,
    String? description,
    bool? isActive,
    int? sortOrder,
  }) =>
      FitnessCategory(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        isActive: isActive ?? this.isActive,
        sortOrder: sortOrder ?? this.sortOrder,
        createdAt: createdAt,
        updatedAt: DateTime.now(),
      );
}
