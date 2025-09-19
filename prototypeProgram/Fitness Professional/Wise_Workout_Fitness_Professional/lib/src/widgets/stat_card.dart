
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
class StatCard extends StatelessWidget {
  final String title; // label
  final String value; // number
  final IconData icon;
  final Color? background; // optional tinted icon background
  final bool square; // unused now, kept for API compatibility
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