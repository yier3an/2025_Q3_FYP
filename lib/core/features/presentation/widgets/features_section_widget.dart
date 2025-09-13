import 'package:flutter/material.dart';

class FeaturesSectionWidget extends StatelessWidget {
  const FeaturesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Features',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 24, // horizontal spacing
                runSpacing: 24, // vertical spacing
                children: const [
                  FeatureCard(
                    icon: Icons.fitness_center,
                    title: 'Personalized Workouts',
                    description:
                        'Get daily workout plans tailored to your goals, fitness level, and schedule.',
                  ),
                  FeatureCard(
                    icon: Icons.watch,
                    title: 'Easy Activity Tracking',
                    description:
                        'Connect wearables for automatic tracking of steps, calories, and heart rate.',
                  ),
                  FeatureCard(
                    icon: Icons.people,
                    title: 'Social Connection',
                    description:
                        'Share your milestones, follow friends, and cheer each other on.',
                  ),
                  FeatureCard(
                    icon: Icons.verified,
                    title: 'Professional Guidance',
                    description:
                        'Access verified fitness professionals for tips, structured workouts, and expert content.',
                  ),
                  FeatureCard(
                    icon: Icons.alarm,
                    title: 'Smart Reminders',
                    description:
                        'Stay consistent with gentle nudges for workouts, recovery, and daily movement.',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback? onLearnMore;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 340, // fixed width for nice grid look
      child: Card(
        color: Colors.white.withOpacity(0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 32, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.5,
                    ),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: onLearnMore ??
                    () {
                      // default placeholder
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Learn more about $title')),
                      );
                    },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Learn More',
                      style: TextStyle(color: Colors.lightBlueAccent),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward,
                        size: 16, color: Colors.lightBlueAccent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
