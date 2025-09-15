
import 'package:flutter/material.dart';

class PremiumWall extends StatelessWidget {
  final String title;
  final String message;
  const PremiumWall({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.55), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(message, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: (){},
            style: const ButtonStyle(foregroundColor: WidgetStatePropertyAll(Colors.white)),
            child: const Text('Go Premium'),
          ),
        ],
      ),
    );
  }
}
