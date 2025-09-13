import 'package:flutter/material.dart';
import 'package:my_website/core/theme/app_color.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.fitness_center, color: AppColors.accent2, size: 28),
        const SizedBox(width: 8),
        Text(
          'Wise Workout',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}