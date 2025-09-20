
import 'package:flutter/material.dart';
<<<<<<< HEAD
import '../theme/app_theme.dart';
class StatCard extends StatelessWidget {
  final String title; // label
  final String value; // number
  final IconData icon;
  final Color? background; // optional tinted icon background
  final bool square; // unused now, kept for API compatibility
=======

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? background;
  final bool square;
>>>>>>> origin/main
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.background,
    this.square = false,
  });

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final color = background ?? AppTheme.purple.withOpacity(0.15);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.purpleDark),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text(title, style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
=======
    final card = Container(
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.black87)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );

    if (square) {
      return AspectRatio(aspectRatio: 1.7, child: card);
    }
    return card;
  }
}
>>>>>>> origin/main
