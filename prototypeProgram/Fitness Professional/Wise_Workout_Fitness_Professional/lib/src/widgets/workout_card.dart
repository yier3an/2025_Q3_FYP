import 'package:flutter/material.dart';

class WorkoutCard extends StatelessWidget {
  final String title;
  final String description;
  final String createdLabel;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  const WorkoutCard({
    super.key,
    required this.title,
    required this.description,
    required this.createdLabel,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.fitness_center),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(description),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(createdLabel, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton(onPressed: onDelete, child: const Text('Delete')),
                  const SizedBox(width: 8),
                  OutlinedButton(onPressed: onEdit, child: const Text('Update')),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
